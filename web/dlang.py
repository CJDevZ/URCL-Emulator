from __future__ import annotations

import array
import operator
from abc import ABC, abstractmethod
from contextlib import contextmanager, ExitStack
from enum import Enum
from typing import Optional, Callable, Any

from lark import Transformer, v_args, Lark, UnexpectedCharacters, UnexpectedToken
from lark.exceptions import VisitError, ParseError, UnexpectedInput
from lark.tree import Meta

import utils
from compiler import Compiler, Error, OpCode, dataclass


TypedValue = tuple[str, int]


RETURN_VALUE: TypedValue = 'register', 1
STACK_POINTER: TypedValue = 'register', 99


class LinkType(Enum):
    RAW = "raw"
    DATA = "data"
    FUTURE = "future"


class UnexpectedType(ParseError, UnexpectedInput):
    def __init__(self, token, expected, line: int, column: int):
        self.token = token
        self.expected = expected
        self.line = line
        self.column = column

    def __str__(self):
        return ("Expected %r, got %r"
                % (self.expected, self.token))


class VarType:
    def __init__(self, name: str, size: int, signed: bool = False):
        self.name = name
        self.size = size
        self.signed = signed

    def __eq__(self, other):
        return isinstance(other, VarType) and self.name == other.name and self.size == other.size

    def __str__(self):
        return self.name


class PointerVarType(VarType):
    def __init__(self, base: VarType):
        super().__init__(f"*{base.name}", 1)
        self.base = base

    def __eq__(self, other):
        return isinstance(other, PointerVarType) and self.base == other.base


VOID = VarType('void', 0)
I32 = VarType('i32', 1, True)


class ValueGetter(ABC):
    def get(self, block: Block, compiled: list[int], data: list[int], destination: int) -> VarType:
        return I32

    def get_either(self, block: Block, compiled: list[int], data: list[int], destination: int) -> tuple[VarType, TypedValue]:
        if (constant := self.get_constant(block, data)) is not None:
            return constant[0], ('number', constant[1])
        return self.get(block, compiled, data, destination), ('register', destination)

    def get_constant(self, block: Block, data: list[int], index: Optional[ValueGetter] = None) -> Optional[tuple[VarType, int]]:
        return None


@dataclass(slots=True,frozen=True)
class ConstValue(ValueGetter):
    var_type: VarType
    value: int

    def get_constant(self, block: Block, data: list[int], index: Optional[int] = None) -> tuple[VarType, int]:
        return self.var_type, self.value


@dataclass(slots=True,frozen=True)
class DataValue(ValueGetter):
    var_type: VarType
    value: Any
    
    def get_constant(self, block: Block, data: list[int], index: Optional[int] = None) -> Optional[tuple[VarType, int]]:
        current_index = len(data)
        if isinstance(self.value, list):
            data.extend(self.value)
        else:
            data.extend(self.value)
        return self.var_type, current_index


@dataclass(slots=True,frozen=True)
class VariableValue(ValueGetter):
    name: str
    index: Optional[ValueGetter] = None

    def get_constant(self, block: Block, data: list[int], index: Optional[int] = None) -> Optional[tuple[VarType, int]]:
        if (variable := block.variables.get(self.name)) is None:
            return None
        if self.index is None:
            return variable.get_constant(block, data, None)
        return variable.get_constant(block, data, self.index)

    def get(self, block: Block, compiled: list[int], data: list[int], destination: int) -> VarType:
        if (variable := block.variables.get(self.name)) is None:
            block.error(f"Unknown variable '{self.name}'")
            return VOID
        return variable.get_value(block, compiled, data, self.index, destination)


class Buildable:
    def build(self, block: Block, compiled: list[int], data: list[int]):
        pass


@dataclass(slots=True)
class Variable(ValueGetter):
    var_type: VarType

    def get_value(self, block: Block, compiled: list[int], data: list[int], index: Optional[ValueGetter], destination: int) -> VarType:
        pass

    def set_value(self, block: Block, compiled: list[int], data: list[int], index: Optional[ValueGetter], operator: MathOperator, value: Optional[tuple[VarType, TypedValue]]) -> None:
        pass


@dataclass(slots=True)
class DirectRegister(Variable):
    var_type: VarType
    register: int

    def set_value(self, block: Block, compiled: list[int], data: list[int], index: Optional[ValueGetter], operator: MathOperator, value: Optional[tuple[VarType, TypedValue]]) -> None:
        if index is not None:
            block.error("Variable is not indexable")
            return
        value_type, gotten_value = value
        if value_type != self.var_type:
            block.error("Type mismatch")
            return
        operator.apply(compiled, self.register, ('register', self.register), gotten_value)


@dataclass(slots=True)
class ConstVariable(Variable):
    value: int

    def get_constant(self, block: Block, data: list[int], index: Optional[ValueGetter] = None) -> Optional[tuple[VarType, int]]:
        if index is None:
            return self.var_type, self.value
        if not isinstance(self.var_type, PointerVarType):
            block.error("Variable is not indexable")
            return self.var_type, self.value
        if (const_index := index.get_constant(block, data, None)) is None:
            return None
        index_type, index_value = const_index
        if index_type != I32:
            block.error("Cannot index an array with a non-integer type")
            return self.var_type, self.value
        return self.var_type.base, data[self.value + index_value]

    def get_value(self, block: Block, compiled: list[int], data: list[int], index: Optional[ValueGetter], destination: int) -> VarType:
        if index is not None:
            if not isinstance(self.var_type, PointerVarType):
                block.error("Variable is not indexable")
                return self.var_type
            with block.acquire_register() as index_register:
                index_type, index_tuple = index.get_either(block, compiled, data, index_register)
            if index_type != I32:
                block.error("Cannot index an array with a non-integer type")
                return self.var_type
            OpCode.LLOD.add(compiled, None, ('register', destination), ('number', 0), index_tuple)
            block.linker(len(compiled) - 2, self.value, LinkType.RAW, LinkType.DATA)
            return self.var_type.base
        else:
            if self.var_type == I32:
                OpCode.IMM.add(compiled, None, ('register', destination), ('number', self.value))
            elif isinstance(self.var_type, PointerVarType):
                OpCode.IMM.add(compiled, None, ('register', destination), ('number', 0))
                block.linker(len(compiled) - 1, self.value, LinkType.RAW, LinkType.DATA)
        return self.var_type

    def set_value(self, block: Block, compiled: list[int], data: list[int], index: Optional[ValueGetter], operator: MathOperator, value: ValueGetter) -> None:
        block.error("Constant cannot be changed")
        return


@dataclass(slots=True)
class StaticVariable(Variable):
    data_index: int

    def get_value(self, block: Block, compiled: list[int], data: list[int], index: Optional[ValueGetter], destination: int) -> VarType:
        if index is not None:
            if not isinstance(self.var_type, PointerVarType):
                block.error("Variable is not indexable")
                return self.var_type
            with block.acquire_register() as index_register:
                index_type, index_tuple = index.get_either(block, compiled, data, index_register)
            if index_type != I32:
                block.error("Cannot index an array with a non-integer type")
                return self.var_type
            OpCode.LOD.add(compiled, None, ('register', destination), ('number', 0))
            block.linker(len(compiled) - 1, self.data_index, LinkType.RAW, LinkType.DATA)
            OpCode.LLOD.add(compiled, None, ('register', destination), ('register', destination), index_tuple)
            return self.var_type.base
        else:
            OpCode.LOD.add(compiled, None, ('register', destination), ('number', 0))
            block.linker(len(compiled) - 1, self.data_index, LinkType.RAW, LinkType.DATA)
        return self.var_type

    def set_value(self, block: Block, compiled: list[int], data: list[int], index: Optional[ValueGetter], operator: MathOperator, value: Optional[tuple[VarType, TypedValue]]) -> None:
        if value is None:
            block.error("Value is Null")
            return
        value_type, gotten_value = value
        if index is not None:
            if not isinstance(self.var_type, PointerVarType):
                block.error("Variable is not an array")
                return
            if value_type != self.var_type.base:
                block.error(f"Expected '{self.var_type.base}', got '{value_type}'")
                return
            with ExitStack() as stack:
                if operator != MathOperator.SET:
                    store_register = stack.enter_context(block.acquire_register())
                    index_register = stack.enter_context(block.acquire_register())

                    store_type = self.get_value(block, compiled, data, index, store_register)
                    index_type, index_tuple = index.get_either(block, compiled, data, index_register)

                    if index_type != I32:
                        block.error("Cannot index an array with a non-integer type")
                        return
                    operator.apply(compiled, store_register, ('register', store_register), gotten_value)
                    if isinstance(self.var_type, PointerVarType):
                        value_register = stack.enter_context(block.acquire_register())
                        OpCode.LOD.add(compiled, None, ('register', value_register), ('number', 0))
                        block.linker(len(compiled) - 1, self.data_index, LinkType.RAW, LinkType.DATA)
                        OpCode.LSTR.add(compiled, None, ('register', value_register), index_tuple, ('register', store_register))
                    else:
                        block.linker(len(compiled) + 1, self.data_index, LinkType.RAW, LinkType.DATA)
                        OpCode.LSTR.add(compiled, None, ('number', 0), index_tuple, ('register', store_register))
                else:
                    index_register = stack.enter_context(block.acquire_register())
                    index_type, index_tuple = index.get_either(block, compiled, data, index_register)
                    if index_type != I32:
                        block.error("Cannot index an array with a non-integer type")
                        return
                    if isinstance(self.var_type, PointerVarType):
                        value_register = stack.enter_context(block.acquire_register())
                        OpCode.LOD.add(compiled, None, ('register', value_register), ('number', 0))
                        block.linker(len(compiled) - 1, self.data_index, LinkType.RAW, LinkType.DATA)
                        OpCode.LSTR.add(compiled, None, ('register', value_register), index_tuple, gotten_value)
                    else:
                        block.linker(len(compiled) + 1, self.data_index, LinkType.RAW, LinkType.DATA)
                        OpCode.LSTR.add(compiled, None, ('number', 0), index_tuple, gotten_value)
        else:
            if self.var_type is not None and value_type != self.var_type:
                block.error(f"Expected '{self.var_type}', got '{value_type}'")
                return
            if operator != MathOperator.SET:
                with block.acquire_register() as store_register:
                    store_type = self.get_value(block, compiled, data, index, store_register)
                operator.apply(compiled, store_register, ('register', store_register), gotten_value)
                block.linker(len(compiled) + 1, self.data_index, LinkType.RAW, LinkType.DATA)
                OpCode.STR.add(compiled, None, ('number', 0), ('register', store_register))
            else:
                block.linker(len(compiled) + 1, self.data_index, LinkType.RAW, LinkType.DATA)
                OpCode.STR.add(compiled, None, ('number', 0), gotten_value)


@dataclass(slots=True)
class LocalVariable(Variable):
    offset: int

    def get_value(self, block: Block, compiled: list[int], data: list[int], index: Optional[ValueGetter], destination: int) -> VarType:
        if self.offset:
            OpCode.LLOD.add(compiled, None, ('register', destination), STACK_POINTER, ('number', self.offset))
        else:
            OpCode.LOD.add(compiled, None, ('register', destination), STACK_POINTER)
        return self.var_type

    def set_value(self, block: Block, compiled: list[int], data: list[int], index: Optional[ValueGetter], operator: MathOperator, value: Optional[tuple[VarType, TypedValue]]):
        value_type, gotten_value = value
        if self.var_type is not None and value_type != self.var_type:
            block.error(f"Expected '{self.var_type}', got '{value_type}'")
            return
        if operator == MathOperator.SET:
            if self.offset:
                OpCode.LSTR.add(compiled, None, STACK_POINTER, ('number', self.offset), gotten_value)
            else:
                OpCode.STR.add(compiled, None, STACK_POINTER, gotten_value)
        else:
            with block.acquire_register() as store_register:
                store_type = self.get_value(block, compiled, data, index, store_register)
            operator.apply(compiled, store_register, ('register', store_register), gotten_value)
            if self.offset:
                OpCode.LSTR.add(compiled, None, STACK_POINTER, ('number', self.offset), ('register', store_register))
            else:
                OpCode.STR.add(compiled, None, STACK_POINTER, ('register', store_register))


@dataclass(slots=True)
class VarDeclaration(Buildable):
    name: str
    var_type: Optional[VarType]
    value: ValueGetter
    const: bool = False
    static: bool = False

    def build(self, block: Block, compiled: list[int], data: list[int]):
        if self.value is None and self.var_type is None:
            block.error("Cannot find variable's type from context")
            return
        if self.const:
            if self.value is None:
                block.error(f"Constant variable must have an initial value")
                return
            if (constant := self.value.get_constant(block, data)) is None:
                block.error("Value isn't constant")
                return
            value_type, value = constant
            if self.var_type is None:
                self.var_type = value_type
            if not self.var_type.__eq__(value_type):
                print(object.__str__(self.var_type), object.__str__(value_type))
                block.error(f"Expected variable type '{self.var_type}', got '{value_type}' instead")
                return
            block.variables[self.name] = ConstVariable(self.var_type, value)
        elif self.static or block.root:
            if self.value is None:
                constant = self.var_type, 0
            elif (constant := self.value.get_constant(block, data)) is None:
                block.error("Value isn't constant")
                return
            value_type, value = constant
            if self.var_type is None:
                self.var_type = value_type
            if not self.var_type.__eq__(value_type):
                print(object.__str__(self.var_type), object.__str__(value_type))
                block.error(f"Expected variable type '{self.var_type}', got '{value_type}' instead")
                return
            data_index = len(data)
            block.variables[self.name] = StaticVariable(self.var_type, data_index)
            if isinstance(self.var_type, PointerVarType):
                block.linker(len(data), value, LinkType.DATA, LinkType.DATA)
            data.append(value)
        else:
            if block.root:
                block.error("Variables must be static in root")
                return
            if self.value is not None:
                with block.acquire_register() as value_register:
                    value_tuple = self.value.get_either(block, compiled, data, value_register)
                value_type = value_tuple[0]
                if self.var_type is None:
                    self.var_type = value_type
                elif not value_type.__eq__(self.var_type):
                    print(object.__str__(self.var_type), object.__str__(value_type))
                    block.error(f"Expected variable type '{self.var_type}', got '{value_type}' instead")
                    return
            else:
                value_tuple: tuple[VarType, TypedValue] = self.var_type, ('number', 0)
            variable = LocalVariable(self.var_type, block.local_variable_offset)
            block.variables[self.name] = variable
            block.local_variable_offset += self.var_type.size
            variable.set_value(block, compiled, data, None, MathOperator.SET, value_tuple)


@dataclass(slots=True)
class VarAssignment(Buildable):
    name: str
    index: Optional[ValueGetter]
    operator: MathOperator
    value: ValueGetter
    value_index: Optional[ValueGetter]

    def build(self, block: Block, compiled: list[int], data: list[int]):
        variable = block.variables.get(self.name)
        if variable is None:
            block.error(f"Variable '{self.name}' is not defined")
            return
        with block.acquire_register() as value_register:
            variable.set_value(block, compiled, data, self.index, self.operator, self.value.get_either(block, compiled, data, value_register))


@dataclass(slots=True,frozen=True)
class FunctionCall(Buildable, ValueGetter):
    name: str
    arguments: list[ValueGetter]

    def build(self, block: Block, compiled: list[int], data: list[int]):
        function = block.functions.get(self.name)
        if function is None:
            block.error(f"Function '{self.name}' is not defined")
            return
        function.call(block, compiled, data, self.arguments, 0)

    def get(self, block: Block, compiled: list[int], data: list[int], destination: int) -> Optional[VarType]:
        function = block.functions.get(self.name)
        if function is None:
            block.error(f"Function '{self.name}' is not defined")
            return VOID
        return function.call(block, compiled, data, self.arguments, destination)


@dataclass(slots=True,frozen=True)
class LoopBlock(Buildable):
    body: Block

    def build(self, block: Block, compiled: list[int], data: list[int]):
        start = len(compiled)
        end = 0
        self.body.copy_standard(block)
        self.body.loop_start_index = start
        self.body.loop_end_future = block.future(lambda: end)
        self.body.build(block, compiled, data)
        OpCode.JMP.add(compiled, None, ('number', start))
        end = len(compiled)


class MathOperator(Enum):
    SET = "=", OpCode.MOV, None, True
    ADD = "+", OpCode.ADD, operator.add
    SUB = "-", OpCode.SUB, operator.sub
    MUL = "*", OpCode.MLT, operator.mul
    DIV = "/", OpCode.DIV, operator.floordiv
    MOD = "%", OpCode.MOD, operator.mod
    NOT = "!", OpCode.NOT, lambda a, b: operator.not_(b),
    LSH = "<<", OpCode.BSL, operator.lshift
    RSH = ">>", OpCode.BSR, operator.rshift
    ADD_SELF = "+=", OpCode.ADD, operator.add, True
    SUB_SELF = "-=", OpCode.SUB, operator.sub, True
    MUL_SELF = "*=", OpCode.MLT, operator.mul, True
    DIV_SELF = "/=", OpCode.DIV, operator.floordiv, True
    MOD_SELF = "%=", OpCode.MOD, operator.mod, True
    AND_SELF = "&=", OpCode.AND, operator.and_, True
    OR_SELF = "|=", OpCode.OR, operator.or_, True
    XOR_SELF = "^=", OpCode.XOR, operator.xor, True
    LSH_SELF = "<<=", OpCode.BSL, operator.lshift, True
    RSH_SELF = ">>=", OpCode.BSR, operator.rshift, True

    def __new__(cls, symbol: str, opcode: OpCode, py_operator: Callable[[int, int], int], self_operation: bool = False):
        obj = object.__new__(cls)
        obj._value_ = symbol
        obj.opcode = opcode
        obj.py_operator = py_operator
        obj.self_operation = self_operation
        return obj

    def apply(self, compiled: list[int], destination: int, a: TypedValue, b: TypedValue):
        if self.self_operation:
            self.opcode.add(compiled, None, ('register', destination), b)
        elif a[0] == 'number' and b[0] == 'number':
            OpCode.IMM.add(compiled, None, ('register', destination), ('number', self.py_operator(a[1], b[1])))
        else:
            self.opcode.add(compiled, None, ('register', destination), a, b)


@dataclass(slots=True,frozen=True)
class MathOperation(ValueGetter):
    a: ValueGetter
    operator: MathOperator
    b: ValueGetter

    def get_constant(self, block: Block, data: list[int], index: Optional[int] = None) -> Optional[tuple[VarType, int]]:
        if (constant_a := self.a.get_constant(block, data)) is not None and (constant_b := self.b.get_constant(block, data)):
            a_type, a_value = constant_a
            b_type, b_value = constant_b
            if a_type != b_type:
                block.error("Type mismatch")
                return None
            return a_type, self.operator.py_operator(a_value, b_value)
        return None

    def get(self, block: Block, compiled: list[int], data: list[int], destination: int) -> VarType:
        with block.acquire_register() as a_register, block.acquire_register() as b_register:
            a_tuple = self.a.get_either(block, compiled, data, a_register)
            b_tuple = self.b.get_either(block, compiled, data, b_register)
            a_type = a_tuple[0]
            b_type = b_tuple[0]

            if a_type != b_type:
                block.error("Type mismatch")
                return I32

            self.operator.apply(compiled, destination, a_tuple[1], b_tuple[1])
            return a_type


class CompOperator(Enum):
    GE = ">=", OpCode.BGE, OpCode.SBGE
    LE = "<=", OpCode.BLE, OpCode.SBLE
    GT = ">", OpCode.BRG, OpCode.SBRG
    LT = "<", OpCode.BRL, OpCode.SBRL
    EQ = "==", OpCode.BRE, OpCode.BRE
    NE = "!=", OpCode.BNE, OpCode.BNE

    def __new__(cls, symbol: str, true: OpCode, signed_true: OpCode):
        obj = object.__new__(cls)
        obj._value_ = symbol
        obj.true = true
        obj.signed_true = signed_true
        return obj

    __NEGATED_CACHE = None
    __ZERO_BRANCH = None

    @classmethod
    def _negated_map(cls):
        if cls.__NEGATED_CACHE is None:
            cls.__NEGATED_CACHE = {
                cls.GE: cls.LT,
                cls.LE: cls.GT,
                cls.GT: cls.LE,
                cls.LT: cls.GE,
                cls.EQ: cls.NE,
                cls.NE: cls.EQ
            }
        return cls.__NEGATED_CACHE

    @classmethod
    def _zero_branches(cls):
        if cls.__ZERO_BRANCH is None:
            cls.__ZERO_BRANCH = {
                cls.EQ: OpCode.BRZ,
                cls.NE: OpCode.BNZ,
            }
        return cls.__ZERO_BRANCH

    @property
    def negated(self):
        return self.__class__._negated_map()[self]

    def branch(self, block: Block, compiled: list[int], a: TypedValue, b: TypedValue, jump: Callable[[], int], signed: bool = False):
        block.linker(len(compiled) + 1, block.future(jump), LinkType.RAW, LinkType.FUTURE)
        zero_opcode = CompOperator._zero_branches().get(self)
        if zero_opcode is not None:
            if b == ('number', 0):
                zero_opcode.add(compiled, None, ('number', 0), a)
                return
            if a == ('number', 0):
                zero_opcode.add(compiled, None, ('number', 0), b)
                return
        (self.signed_true if signed else self.true).add(compiled, None, ('number', 0), a, b)


@dataclass(slots=True,frozen=True)
class Comparison:
    a: ValueGetter | Comparison
    operator: CompOperator
    b: ValueGetter | Comparison

    def build(self, block: Block, compiled: list[int], data: list[int], jump: Callable[[], int]):
        with ExitStack() as stack:
            if (constant := self.a.get_constant(block, data)) is not None:
                a_type, a_tuple = constant[0], ('number', constant[1])
            else:
                a_register = stack.enter_context(block.acquire_register())
                a_type = self.a.get(block, compiled, data, a_register)
                a_tuple = ('register', a_register)

            if (constant := self.b.get_constant(block, data)) is not None:
                b_type, b_tuple = constant[0], ('number', constant[1])
            else:
                b_register = stack.enter_context(block.acquire_register())
                b_type = self.b.get(block, compiled, data, b_register)
                b_tuple = ('register', b_register)

            if a_type != b_type:
                block.error("Type mismatch")
                return

            self.operator.negated.branch(block, compiled, a_tuple, b_tuple, jump, a_type.signed)


@dataclass(slots=True,frozen=True)
class IfStatement(Buildable):
    condition: Comparison
    body: Block
    else_: Optional[IfStatement | Block]

    def build(self, block: Block, compiled: list[int], data: list[int]):
        self.condition.build(block, compiled, data, lambda: self.body.end_index)
        self.body.copy_standard(block)
        self.body.build(block, compiled, data)

        if self.else_ is not None:
            jump_index = 0
            OpCode.JMP.add(compiled, None, ('number', 0))
            self.body.end_index = len(compiled)
            block.linker(len(compiled) - 1, block.future(lambda: jump_index), LinkType.RAW, LinkType.FUTURE)
            if isinstance(self.else_, Block):
                self.else_.copy_standard(block)
            self.else_.build(block, compiled, data)
            jump_index = len(compiled)


@dataclass(slots=True,frozen=True)
class ReturnStatement(Buildable):
    def build(self, block: Block, compiled: list[int], data: list[int]):
        OpCode.ADD.add(compiled, None, STACK_POINTER, STACK_POINTER, ('number', 0))
        block.linker(len(compiled) - 1, block.future(lambda: block.local_variable_offset), LinkType.RAW, LinkType.FUTURE)
        compiled.append(OpCode.RET.id)


@dataclass(slots=True,frozen=True)
class BreakStatement(Buildable):
    def build(self, block: Block, compiled: list[int], data: list[int]):
        if block.loop_end_future < 0:
            block.error("Cannot break outside a loop")
            return
        OpCode.JMP.add(compiled, None, ('number', 0))
        block.linker(len(compiled) - 1, block.loop_end_future, LinkType.RAW, LinkType.FUTURE)


@dataclass(slots=True,frozen=True)
class ContinueStatement(Buildable):
    def build(self, block: Block, compiled: list[int], data: list[int]):
        if block.start_index < 0:
            block.error("Cannot continue outside a loop")
            return
        OpCode.JMP.add(compiled, None, ('number', block.start_index))


class ListVarType(PointerVarType):
    def __init__(self, base: VarType, length: int):
        super().__init__(base)
        self.name = f'[{base.name};{length}]'
        self.length = length

    def __eq__(self, other):
        return isinstance(other, ListVarType) and self.base == other.base and self.length == other.length

    def __str__(self):
        return self.name


@dataclass(slots=True)
class Block(Buildable):
    data: list[tuple[int, Buildable]]
    variables: dict[str, Variable]
    functions: dict[str, CallableFunction]
    error: Callable[[Optional[str]], None] = lambda *args: None
    error_line: Callable[[int, str], None] = lambda *args: None
    linker: Callable[[int, int, LinkType, LinkType], None] = lambda *args: None
    future: Callable[[Callable[[], int]], int] = lambda *args: 0
    root: bool = False
    allow_return: bool = False
    local_variable_offset: int = 0
    start_index: int = -1
    end_index: int = -1
    loop_start_index: int = -1
    loop_end_future: int = -1
    registers: int = 0
    g_compiled: list[int] = None
    g_data: list[int] = None

    def copy_standard(self, block: Block):
        self.variables = dict(block.variables)
        self.functions = dict(block.functions)
        self.error_line = block.error_line
        self.linker = block.linker
        self.future = block.future
        self.local_variable_offset = block.local_variable_offset
        self.loop_start_index = block.loop_start_index
        self.loop_end_future = block.loop_end_future
        self.registers = block.registers
        self.g_compiled = block.g_compiled
        self.g_data = block.g_compiled

    def emit(self, opcode: OpCode, *params: ValueGetter, destination: Optional[Variable] = None, destination_index: int = 0):
        arguments: list[TypedValue] = []
        with ExitStack() as stack:
            dest_register: int
            for i, param in enumerate(params):
                if destination is not None and destination_index == i:
                    dest_register = stack.enter_context(self.acquire_register())
                    arguments.append(('register', dest_register))
                if (constant := param.get_constant(self, self.g_data)) is not None:
                    arguments.append(('number', constant[1]))
                else:
                    arg_register = stack.enter_context(self.acquire_register())
                    param.get(self, self.g_compiled, self.g_data, arg_register)
                    arguments.append(('register', arg_register))
            if destination is not None:
                destination.set_value(self, self.g_compiled, self.g_data, None, MathOperator.SET,(destination.var_type, ('register', dest_register)))
        opcode.add(self.g_compiled, None, *arguments)


    def build(self, block: Optional[Block], compiled: list[int], data: list[int]):
        self.start_index = len(compiled)
        for (line, buildable), is_last in utils.iterate_with_last(self.data):
            self.error = lambda error: self.error_line(line, error)
            print(buildable)
            buildable.build(self, compiled, data)
        self.end_index = len(compiled)
        if block is not None:
            block.local_variable_offset = self.local_variable_offset

    @contextmanager
    def acquire_register(self):
        try:
            self.registers += 1
            yield self.registers
        finally:
            print(f"Put register {self.registers} back")
            self.registers -= 1


class CallableFunction(ABC):
    @abstractmethod
    def call(self, block: Block, compiled: list[int], data: list[int], arguments: list[ValueGetter], destination: int) -> Optional[VarType]:
        ...


@dataclass(slots=True)
class Function(Buildable, CallableFunction):
    name: str
    parameters: list[LocalVariable]
    return_type: VarType
    body: Block
    code_index: int = -1

    def build(self, block: Block, compiled: list[int], data: list[int]):
        block.functions[self.name] = self

        self.code_index = len(compiled)
        local_variable_offset = 0
        OpCode.SUB.add(compiled, None, STACK_POINTER, STACK_POINTER, ('number', 0))
        block.linker(len(compiled) - 1, block.future(lambda: local_variable_offset), LinkType.RAW, LinkType.FUTURE)
        self.body.copy_standard(block)
        self.body.build(block, compiled, data)
        local_variable_offset = self.body.local_variable_offset
        if local_variable_offset == 1:
            OpCode.INC.add(compiled, None, STACK_POINTER, STACK_POINTER)
        elif local_variable_offset:
            OpCode.ADD.add(compiled, None, STACK_POINTER, STACK_POINTER, ('number', local_variable_offset))

        compiled.append(OpCode.RET.id)

    def call(self, block: Block, compiled: list[int], data: list[int], arguments: list[ValueGetter], destination: int) -> Optional[VarType]:
        OpCode.CAL.add(compiled, None, ('number', self.code_index))


@dataclass(slots=True)
class InlineFunction(Function):
    pass


@dataclass(slots=True,frozen=True)
class SysFunction(CallableFunction):
    builder: Callable[[Block, list[int], list[TypedValue], int], Optional[tuple[VarType, TypedValue]]]

    @staticmethod
    def tunnel(op_code: OpCode) -> SysFunction:
        def builder(block: Block, compiled: list[int], arguments: list[TypedValue], destination: int) -> Optional[VarType]:
            block.error(op_code.add(compiled, None, *arguments))
            return None

        return SysFunction(builder)

    def call(self, block: Block, compiled: list[int], data: list[int], arguments: list[ValueGetter], destination: int) -> Optional[tuple[VarType, TypedValue]]:
        with ExitStack() as stack:
            resolved: list[TypedValue] = []
            for i, arg in enumerate(arguments):
                if (constant := arg.get_constant(block, data)) is not None:
                    var_type, value = constant
                    if isinstance(var_type, PointerVarType):
                        arg_register = stack.enter_context(block.acquire_register())
                        OpCode.IMM.add(compiled, None, ('register', arg_register), ('number', value))
                        resolved.append(('register', arg_register))
                    else:
                        resolved.append(('number', value))
                else:
                    arg_register = stack.enter_context(block.acquire_register())
                    arg.get_either(block, compiled, data, arg_register)
                    resolved.append(('register', arg_register))
            print(resolved)
            return self.builder(block, compiled, resolved, destination)


class DLangTransformer(Transformer):
    def num(self, tokens):
        return ConstValue(I32, int(tokens[0].value, 0))

    def str(self, tokens):
        text = tokens[0].value[1:-1]
        value = [*text.encode().decode('unicode_escape').encode('ascii'), 0]
        return DataValue(ListVarType(I32, len(value)), value)

    def char(self, tokens):
        text = tokens[0].value[1:-1].encode().decode('unicode_escape').encode('ascii')
        if len(text):
            return ConstValue(I32, ord(text))
        return ConstValue(I32, 0)

    @v_args(meta=True)
    def list_literal(self, meta: Meta, values: list[ConstValue]):
        if values[0] is None:
            return DataValue(ListVarType(VOID, 0), [])
        print(values)
        if any(x.var_type != values[0].var_type for x in values):
            raise UnexpectedType(values[1].var_type.name, values[0].var_type.name, meta.line, meta.column)
        return DataValue(ListVarType(values[0].var_type, len(values)), [value.value for value in values])

    def list_lit(self, tokens):
        return tokens[0]

    def list_repeated(self, tokens):
        size = int(tokens[1].value)
        repeat_value = tokens[0]
        return DataValue(ListVarType(repeat_value.var_type, size), [repeat_value.value] * size)

    def list_rep(self, tokens):
        return tokens[0]

    def CNAME(self, tok):
        return tok

    def var(self, tokens):
        return VariableValue(tokens[0].value, tokens[1])

    def basic_type(self, tokens):
        if tokens[0].value == 'i32':
            return I32
        elif tokens[0].value == 'void':
            return VOID
        return None

    def list_type(self, tokens):
        return ListVarType(tokens[0], int(tokens[1].value))

    def block(self, tokens):
        return Block(tokens, {}, {})

    def FACT_OP(self, tokens):
        return MathOperator(tokens[0])

    def factor(self, tokens):
        return MathOperation(tokens[0], tokens[1], tokens[2])

    def func_def(self, tokens):
        return Function(tokens[0].value, [] if tokens[1] is None else tokens[1], VOID if tokens[2] is None else tokens[2], tokens[3])

    def TERM_OP(self, tok):
        return MathOperator(tok)

    def term(self, tokens):
        return MathOperation(tokens[0], tokens[1], tokens[2])

    def var_declaration(self, tokens):
        var_type = tokens[2]
        pointer_depth = tokens[1] or 0
        for i in range(pointer_depth):
            var_type = PointerVarType(var_type)

        return VarDeclaration(tokens[0].value, var_type, tokens[3])

    def static_declaration(self, tokens):
        var_type = tokens[2]
        pointer_depth = tokens[1] or 0
        for i in range(pointer_depth):
            var_type = PointerVarType(var_type)

        return VarDeclaration(tokens[0].value, var_type, tokens[3], static=True)

    def const_declaration(self, tokens):
        var_type = tokens[2]
        pointer_depth = tokens[1] or 0
        for i in range(pointer_depth):
            var_type = PointerVarType(var_type)

        return VarDeclaration(tokens[0].value, var_type, tokens[3], const=True)

    def pointer_list(self, tokens):
        return len(tokens)

    @v_args(meta=True)
    def stmt(self, meta: Meta, tokens):
        return meta.line - 1, tokens[0]

    def assign(self, tokens):
        return VarAssignment(tokens[0].value, tokens[1], MathOperator(tokens[2].value), tokens[3], tokens[4])

    def comparison(self, tokens):
        return Comparison(tokens[0], CompOperator(tokens[1].value), tokens[2])

    def if_stmt(self, tokens):
        return tokens[0]

    def matched_if(self, tokens):
        return IfStatement(tokens[0], tokens[1], tokens[2])

    def unmatched_if(self, tokens):
        return IfStatement(tokens[0], tokens[1], None)

    def loop_stmt(self, tokens):
        return LoopBlock(tokens[0])

    def return_stmt(self, _):
        return ReturnStatement()

    def break_stmt(self, _):
        return BreakStatement()

    def continue_stmt(self, _):
        return ContinueStatement()

    def arglist(self, tokens) -> list:
        return tokens

    def call(self, tokens):
        arguments = tokens[1]
        return FunctionCall(tokens[0].value, [] if arguments is None else arguments)

    def start(self, tokens):
        return Block(tokens, {}, {}, root=True)


class DLangCompiler(Compiler):
    def __init__(self):
        with open("dlang.lark", "r") as f:
            super().__init__(Lark(f.read(), parser="lalr", propagate_positions=True))

        def get_port(_: Block, compiled: list[int], arguments: list[TypedValue], destination: int) -> VarType:
            OpCode.IN.add(compiled, None, ('register', destination), *arguments)
            return I32

        def malloc(_: Block, compiled: list[int], arguments: list[TypedValue], destination: int) -> VarType:
            OpCode.OUT.add(compiled, None, ('number', 10), *arguments)
            if destination and destination != 1:
                OpCode.MOV.add(compiled, None, ('register', destination), RETURN_VALUE)
            return I32

        def sleep(_: Block, compiled: list[int], arguments: list[TypedValue], destination: int) -> None:
            OpCode.OUT.add(compiled, None, ('number', 2), *arguments)

        def print(_: Block, compiled: list[int], arguments: list[TypedValue], destination: int) -> None:
            OpCode.OUT.add(compiled, None, ('number', 9), *arguments)

        def print_number(_: Block, compiled: list[int], arguments: list[TypedValue], destination: int) -> None:
            OpCode.OUT.add(compiled, None, ('number', 1), *arguments)

        self.builtin_functions: dict[str, SysFunction] = {
            'set_port': SysFunction.tunnel(OpCode.OUT),
            'get_port': SysFunction(get_port),
            'malloc': SysFunction(malloc),
            'sleep': SysFunction(sleep),
            'print': SysFunction(print),
            'print_number': SysFunction(print_number)
        }

    @classmethod
    def emit_instruction(cls, compiled: list[int], instruction: str, operands: list):
        match instruction:
            case "ret void": compiled.append(OpCode.RET.id)

    def compile(self, text: str) -> bytes | list[Error]:
        errors: dict[int, Error] = {}
        try:
            tree = self.parser.parse(text)
        except (UnexpectedCharacters, UnexpectedToken) as e:
            errors[e.line - 1] = Error(e.line - 1, str(e), 'error', e.column)
            return list(errors.values())
        try:
            program: Block = DLangTransformer().transform(tree)
        except VisitError as e:
            if isinstance(e.orig_exc, UnexpectedType):
                errors[e.orig_exc.line - 1] = Error(e.orig_exc.line - 1, str(e.orig_exc), 'error', e.orig_exc.column)
                return list(errors.values())
            else:
                raise e

        compiled: list[int] = []
        link_table: list[tuple[int, int, LinkType, LinkType]] = []
        data: list[int] = []
        future: list[Callable[[], int]] = []

        def add_link(index: int, target_index: int, index_link_type: LinkType = LinkType.RAW, target_link_type: LinkType = LinkType.RAW):
            link_table.append((index, target_index, index_link_type, target_link_type))

        def add_future(value: Callable[[], int]) -> int:
            index = len(future)
            future.append(value)
            return index

        def add_error(line: int, error: Optional[str], column: int = 0):
            if error is None:
                return
            errors[line] = Error(line, error, 'error', column)

        main_function_index = 0
        OpCode.CAL.add(compiled, None, ('number', 0))
        add_link(len(compiled) - 1, add_future(lambda: main_function_index), LinkType.RAW, LinkType.FUTURE)
        compiled.append(OpCode.HLT.id)

        program.functions = dict(self.builtin_functions)
        program.linker = add_link
        program.error_line = add_error
        program.future = add_future
        program.g_compiled = compiled
        program.g_data = data
        program.build(None, compiled, data)

        if errors:
            return list(errors.values())

        data_start = len(compiled)
        compiled.extend(data)

        main_function = program.functions.get('main')
        if main_function is None or not isinstance(main_function, Function):
            errors[0] = Error(0, "Function 'main' not found", "error")
            return list(errors.values())
        main_function_index = main_function.code_index

        for index, target_index, index_link_type, target_link_type in link_table:
            if target_link_type == LinkType.DATA:
                target_index += data_start
            elif target_link_type == LinkType.FUTURE:
                target_index = future[target_index]()
            if index_link_type == LinkType.DATA:
                index += data_start
            elif index_link_type == LinkType.FUTURE:
                index = future[index]()
            compiled[index] = target_index
        print(compiled)
        print(len(compiled))

        try:
            program_bytes: bytes = array.array('I', compiled).tobytes()
        except OverflowError:
            errors[0] = Error(0, f"Program using more than 32 bits for some words", type="error")
            return list(errors.values())
        return program_bytes
