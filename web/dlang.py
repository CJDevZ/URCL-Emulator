from __future__ import annotations

import array
from enum import Enum
from typing import Optional, Callable, Any

from lark import Transformer, v_args, Lark, UnexpectedCharacters, UnexpectedToken
from lark.exceptions import VisitError, ParseError, UnexpectedInput
from lark.tree import Meta

import utils
from compiler import Compiler, Error, OpCode, dataclass


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


class ReferenceVarType(VarType):
    def __init__(self, base: VarType):
        super().__init__(f"&{base.name}", 1)
        self.base = base

    def __eq__(self, other):
        return isinstance(other, ReferenceVarType) and self.base == other.base


I32 = VarType('i32', 1, True)
STR = ReferenceVarType(VarType('str', 1))


@dataclass(slots=True,frozen=True)
class Value:
    value_type: VarType
    value: Any

    def get(self, block: Block, compiled: list[int], data: list[int]) -> tuple[str, str | int]:
        if self.value_type.name == 'variable':
            variable = block.variables.get(self.value)
            if variable is None:
                raise NameError(f"Unknown variable '{self.value}'")
            variable.get_value(block, compiled, data, None, ('register', 2))
            return 'register', 2
        elif self.value_type == STR:
            encoded = [*self.value.encode().decode('unicode_escape').encode('ascii'), 0]
            current_index = len(data)
            data.extend(encoded)
            return 'data', current_index

        if isinstance(self.value_type, ListVarType):
            length = len(self.value)

            offsets: list[int] = [0] * length
            payload: list[int] = []

            data_index = len(data)
            current_index = len(data) + length

            for i, value in enumerate(self.value):
                block.linker(data_index + i, current_index, LinkType.DATA, LinkType.DATA)

                if isinstance(value, str):
                    encoded = [*value.encode().decode('unicode_escape').encode('ascii'), 0]
                    payload.extend(encoded)
                    current_index += len(encoded)
                else:
                    payload.append(value)
                    current_index += 1

            data.extend(offsets)
            data.extend(payload)
            return 'number', data_index

        return 'number', int(self.value)


class Buildable:
    def build(self, block: Block, compiled: list[int], data: list[int]):
        pass


@dataclass(slots=True)
class Variable:
    var_type: Optional[VarType]

    def get_value(self, block: Block, compiled: list[int], data: list[int], index: Optional[Value], destination: tuple[str, str | int]):
        pass

    def set_value(self, block: Block, compiled: list[int], data: list[int], index: Optional[Value], operator: MathOperator, value: Value):
        pass


@dataclass(slots=True)
class ConstVariable(Variable):
    data_index: int

    def get_value(self, block: Block, compiled: list[int], data: list[int], index: Optional[Value], destination: tuple[str, str | int]):
        if index is not None:
            if not isinstance(self.var_type, ListVarType):
                block.error("Variable is not an array")
                return
            OpCode.LLOD.add(compiled, None, destination, index.get(block, compiled, data), ('number', 0))
        else:
            OpCode.LOD.add(compiled, None, destination, ('number', 0))
        block.linker(len(compiled) - 1, self.data_index, LinkType.RAW, LinkType.DATA)

    def set_value(self, block: Block, compiled: list[int], data: list[int], index: Optional[Value], operator: MathOperator, value: Value):
        block.error("Constant cannot be changed")
        return


@dataclass(slots=True)
class StaticVariable(Variable):
    data_index: int

    def get_value(self, block: Block, compiled: list[int], data: list[int], index: Optional[Value], destination: tuple[str, str | int]):
        if index is not None:
            if not isinstance(self.var_type, ListVarType):
                block.error("Variable is not an array")
                return
            OpCode.LLOD.add(compiled, None, destination, index.get(block, compiled, data), ('number', 0))
        else:
            OpCode.LOD.add(compiled, None, destination, ('number', 0))
        block.linker(len(compiled) - 1, self.data_index, LinkType.RAW, LinkType.DATA)

    def set_value(self, block: Block, compiled: list[int], data: list[int], index: Optional[Value], operator: MathOperator, value: Value):
        if index is not None:
            if not isinstance(self.var_type, ListVarType):
                block.error("Variable is not an array")
                return
            if self.var_type.base != value.value_type:
                block.error(f"Expected '{self.var_type.base}', got '{value.value_type}'")
                return
            self.get_value(block, compiled, data, index, ('register', 3))
            operator.apply(block, compiled, data, ('register', 3), ('register', 3), value.get(block, compiled, data))
            block.linker(len(compiled) + 1, self.data_index, LinkType.RAW, LinkType.DATA)
            OpCode.LSTR.add(compiled, None, ('number', 0), index.get(block, compiled, data), ('register', 3))
        else:
            if self.var_type != value.value_type:
                block.error(f"Expected '{self.var_type}', got '{value.value_type}'")
                return
            self.get_value(block, compiled, data, None, ('register', 3))
            operator.apply(block, compiled, data, ('register', 3), ('register', 3), value.get(block, compiled, data))
            block.linker(len(compiled) + 1, self.data_index, LinkType.RAW, LinkType.DATA)
            OpCode.STR.add(compiled, None, ('number', 0), ('register', 3))


@dataclass(slots=True)
class LocalVariable(Variable):
    offset: int

    def get_value(self, block: Block, compiled: list[int], data: list[int], index: Optional[Value], destination: tuple[str, str | int]):
        if self.offset:
            OpCode.LLOD.add(compiled, None, destination, ('register', 99), ('number', self.offset))
        else:
            OpCode.LOD.add(compiled, None, destination, ('register', 99))

    def set_value(self, block: Block, compiled: list[int], data: list[int], index: Optional[Value], operator: MathOperator, value: Value):
        if self.offset:
            OpCode.LSTR.add(compiled, None, ('register', 99), ('number', self.offset), value.get(block, compiled, data))
        else:
            OpCode.STR.add(compiled, None, ('register', 99), value.get(block, compiled, data))


@dataclass(slots=True)
class VarDeclaration(Buildable):
    name: str
    var_type: Optional[VarType]
    value: Value
    const: bool

    def build(self, block: Block, compiled: list[int], data: list[int]):
        if self.var_type is None:
            self.var_type = self.value.value_type
        elif self.value.value_type != self.var_type:
            print(object.__str__(self.var_type), object.__str__(self.value.value_type))
            block.error(f"Expected variable type '{self.var_type}', got '{self.value.value_type}' instead")
            return
        if self.const:
            data_index = len(data)
            store_type, stored = self.value.get(block, compiled, data)
            block.variables[self.name] = ConstVariable(self.var_type, data_index)
            data.append(stored)
        elif block.root:
            data_index = len(data)
            store_type, stored = self.value.get(block, compiled, data)
            block.variables[self.name] = StaticVariable(self.var_type, data_index)
            data.append(stored)
        else:
            block.variables[self.name] = LocalVariable(self.var_type, block.local_variable_offset)
            block.local_variable_offset += self.var_type.size


@dataclass(slots=True)
class VarAssignment(Buildable):
    name: str
    index: Value
    operator: MathOperator
    value: Value

    def build(self, block: Block, compiled: list[int], data: list[int]):
        variable = block.variables.get(self.name)
        if variable is None:
            block.error(f"Variable '{self.name}' is not defined")
            return
        variable.set_value(block, compiled, data, self.index, self.operator, self.value)


@dataclass(slots=True,frozen=True)
class FunctionCall(Buildable):
    name: str
    arguments: list[Value]

    def build(self, block: Block, compiled: list[int], data: list[int]):
        function = block.functions.get(self.name)
        if function is None:
            block.error(f"Unknown function '{self.name}'")
        else:
            function.build(block, compiled, data, self.arguments)


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
    SET = "=", OpCode.MOV, True
    ADD = "+", OpCode.ADD
    SUB = "-", OpCode.SUB
    MUL = "*", OpCode.MLT
    DIV = "/", OpCode.DIV
    MOD = "%", OpCode.MOD
    NOT = "!", OpCode.NOT
    ADD_SELF = "+=", OpCode.ADD, True
    SUB_SELF = "-=", OpCode.SUB, True
    MUL_SELF = "*=", OpCode.MLT, True
    DIV_SELF = "/=", OpCode.DIV, True
    MOD_SELF = "%=", OpCode.MOD, True
    AND_SELF = "&=", OpCode.AND, True
    OR_SELF = "|=", OpCode.OR, True
    XOR_SELF = "^=", OpCode.XOR, True

    def __new__(cls, symbol: str, opcode: OpCode, self_operation: bool = False):
        obj = object.__new__(cls)
        obj._value_ = symbol
        obj.opcode = opcode
        obj.self_operation = self_operation
        return obj

    def apply(self, block: Block, compiled: list[int], data: list[int], store: tuple[str, str | int], a: tuple[str, str | int], b: tuple[str, str | int]):
        if self.self_operation:
            self.opcode.add(compiled, None, store, store, b)
        else:
            self.opcode.add(compiled, None, store, a, b)


class CompOperator(Enum):
    GE = ">=", OpCode.BGE, OpCode.SBGE, OpCode.BRL, OpCode.SBRL
    LE = "<=", OpCode.BLE, OpCode.SBLE, OpCode.BRG, OpCode.SBRG
    GT = ">", OpCode.BRG, OpCode.SBRG, OpCode.BLE, OpCode.SBLE
    LT = "<", OpCode.BRL, OpCode.SBRL, OpCode.BGE, OpCode.SBGE
    EQ = "==", OpCode.BRE, OpCode.BRE, OpCode.BNE, OpCode.BNE
    NE = "!=", OpCode.BNE, OpCode.BNE, OpCode.BRE, OpCode.BRE

    def __new__(cls, symbol: str, true: OpCode, signed_true: OpCode, false: OpCode, signed_false: OpCode):
        obj = object.__new__(cls)
        obj._value_ = symbol
        obj.true = true
        obj.signed_true = signed_true
        obj.false = false
        obj.signed_false = signed_false
        return obj

    def branch_true(self, block: Block, compiled: list[int], a: tuple[str, str | int], b: tuple[str, str | int], jump: Callable[[], int], signed: bool = False):
        block.linker(len(compiled) + 1, block.future(jump), LinkType.RAW, LinkType.FUTURE)
        (self.signed_true if signed else self.true).add(compiled, None, ('number', 0), a, b)

    def branch_false(self, block: Block, compiled: list[int], a: tuple[str, str | int], b: tuple[str, str | int], jump: Callable[[], int], signed: bool = False):
        block.linker(len(compiled) + 1, block.future(jump), LinkType.RAW, LinkType.FUTURE)
        (self.signed_false if signed else self.false).add(compiled, None, ('number', 0), a, b)


@dataclass(slots=True,frozen=True)
class Comparison:
    a: Value | Comparison
    operator: CompOperator
    b: Value | Comparison

    def build(self, block: Block, compiled: list[int], data: list[int], jump: Callable[[], int]):
        #print("Types", self.a.value_type, self.b.value_type)
        #if self.a.value_type != self.b.value_type:
        #    block.error("Comparison with different types")
        #    return
        self.operator.branch_false(block, compiled, self.a.get(block, compiled, data), self.b.get(block, compiled, data), jump, self.a.value_type.signed)


@dataclass(slots=True,frozen=True)
class IfStatement(Buildable):
    condition: Comparison
    body: Block

    def build(self, block: Block, compiled: list[int], data: list[int]):
        self.condition.build(block, compiled, data, lambda: self.body.end_index)
        self.body.copy_standard(block)
        self.body.build(block, compiled, data)


@dataclass(slots=True,frozen=True)
class BreakStatement(Buildable):
    def build(self, block: Block, compiled: list[int], data: list[int]):
        if block.loop_end_future < 0:
            block.error("Cannot continue outside a loop")
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


class ListVarType(VarType):
    def __init__(self, base: VarType, length: int):
        super().__init__(f"[{base.name};{length}]", 1)
        self.base = base
        self.length = length

    def __eq__(self, other):
        return isinstance(other, ListVarType) and self.base == other.base and self.length == other.length

    def __str__(self):
        return f'[{self.name}, {self.length}]'


@dataclass(slots=True)
class Block(Buildable):
    data: list[tuple[int, Buildable]]
    variables: dict[str, Variable]
    functions: dict[str, SysFunction]
    error: Callable[[Optional[str]], None] = lambda *args: None
    error_line: Callable[[int, str], None] = lambda *args: None
    linker: Callable[[int, int, LinkType, LinkType], None] = lambda *args: None
    future: Callable[[Callable[[], None]], int] = lambda *args: 0
    root: bool = False
    local_variable_offset: int = 0
    start_index: int = -1
    end_index: int = -1
    loop_start_index: int = -1
    loop_end_future: int = -1

    def copy_standard(self, block: Block):
        self.variables = dict(block.variables)
        self.functions = dict(block.functions)
        self.error_line = block.error_line
        self.linker = block.linker
        self.future = block.future
        self.loop_start_index = block.loop_start_index
        self.loop_end_future = block.loop_end_future

    def build(self, block: Optional[Block], compiled: list[int], data: list[int]):
        self.start_index = len(compiled)
        for (line, buildable), is_last in utils.iterate_with_last(self.data):
            self.error = lambda error: self.error_line(line, error)
            print(buildable)
            if self.root:
                buildable.build(self, compiled, data)
            else:
                buildable.build(self, compiled, data)
        self.end_index = len(compiled)


@dataclass(slots=True,frozen=True)
class Function(Buildable):
    name: str
    parameters: list[str]
    body: Block


@dataclass(slots=True,frozen=True)
class InlineFunction(Function):
    pass


@dataclass(slots=True,frozen=True)
class SysFunction:
    op_code: OpCode

    def build(self, block: Block, compiled: list[int], data: list[int], arguments: list[Value]):
        try:
            block.error(self.op_code.add(compiled, None, *(arg.get(block, compiled, data) for index, arg in enumerate(arguments))))
        except NameError as e:
            return e.args[0]
        except NotImplementedError as e:
            return e.args[0]
        return None


class DLangTransformer(Transformer):
    def num(self, tokens):
        return Value(I32, int(tokens[0].value, 0))

    def str(self, tokens):
        text = tokens[0].value[1:-1]
        #.encode().decode('unicode_escape').encode('ascii')
        return Value(STR, text)

    @v_args(meta=True)
    def list_literal(self, meta: Meta, values: list[Value]):
        if any(x.value_type != values[0].value_type for x in values):
            print(values)
            raise UnexpectedType(values[1].value_type.name, values[0].value_type.name, meta.line, meta.column)
        return Value(ListVarType(values[0].value_type, len(values)), [value.value for value in values])

    def list_lit(self, tokens):
        return tokens[0]

    def list_repeated(self, tokens):
        size = int(tokens[1].value)
        return Value(ListVarType(tokens[0].value_type, size), [tokens[0].value] * size)

    def list_rep(self, tokens):
        return tokens[0]

    def CNAME(self, tok):
        return tok

    def var(self, tokens):
        return Value(VarType('variable', 0), tokens[0].value)

    def basic_type(self, tokens):
        return VarType(tokens[0].value, 1)

    def list_type(self, tokens):
        return ListVarType(tokens[0], int(tokens[1].value))

    def block(self, tokens):
        return Block(tokens, {}, {})

    @v_args(meta=True)
    def func_def(self, meta: Meta, tokens):
        return meta.line - 1, Function(tokens[0].value, tokens[1], tokens[2])

    @v_args(meta=True)
    def var_declaration(self, meta: Meta, tokens):
        var_type = tokens[2]
        if tokens[1] is not None:
            var_type = ReferenceVarType(var_type)
        return meta.line - 1, VarDeclaration(tokens[0].value, var_type, tokens[3], False)

    @v_args(meta=True)
    def const_declaration(self, meta: Meta, tokens):
        var_type = tokens[2]
        if tokens[1] is not None:
            var_type = ReferenceVarType(var_type)
        return meta.line - 1, VarDeclaration(tokens[0].value, var_type, tokens[3], True)

    @v_args(meta=True)
    def assign(self, meta: Meta, tokens):
        return meta.line - 1, VarAssignment(tokens[0].value, tokens[1], MathOperator(tokens[2].value), tokens[3])

    def comparison(self, tokens):
        return Comparison(tokens[0], CompOperator(tokens[1].value), tokens[2])

    @v_args(meta=True)
    def if_stmt(self, meta: Meta, tokens):
        return meta.line - 1, IfStatement(tokens[0], tokens[1])

    @v_args(meta=True)
    def loop_stmt(self, meta: Meta, tokens):
        return meta.line - 1, LoopBlock(tokens[0])

    @v_args(meta=True)
    def break_stmt(self, meta: Meta, _):
        return meta.line - 1, BreakStatement()

    @v_args(meta=True)
    def continue_stmt(self, meta: Meta, _):
        return meta.line - 1, ContinueStatement()

    def arglist(self, tokens) -> list:
        return tokens

    @v_args(meta=True)
    def call(self, meta: Meta, tokens):
        return meta.line - 1, FunctionCall(tokens[0].value, tokens[1])

    def start(self, tokens):
        return Block(tokens, {}, {}, root=True)


class DLangCompiler(Compiler):
    def __init__(self):
        with open("dlang.lark", "r") as f:
            super().__init__(Lark(f.read(), parser="lalr", propagate_positions=True))

        self.builtin_functions: dict[str, SysFunction] = {'set_port': SysFunction(OpCode.OUT)}

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
        future: list[Callable[[], None]] = []

        def add_link(index: int, target_index: int, index_link_type: LinkType = LinkType.RAW, target_link_type: LinkType = LinkType.RAW):
            link_table.append((index, target_index, index_link_type, target_link_type))

        def add_future(value: Callable[[], None]) -> int:
            index = len(future)
            future.append(value)
            return index

        def add_error(line: int, error: Optional[str], column: int = 0):
            if error is None:
                return
            errors[line] = Error(line, error, 'error', column)

        program.functions = dict(self.builtin_functions)
        program.linker = add_link
        program.error_line = add_error
        program.future = add_future
        program.build(None, compiled, data)

        if errors:
            return list(errors.values())

        compiled.append(OpCode.HLT.id)
        data_start = len(compiled)
        compiled.extend(data)
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

        try:
            program_bytes: bytes = array.array('I', compiled).tobytes()
        except OverflowError:
            errors[0] = Error(0, f"Program using more than 32 bits for some words", type="error")
            return list(errors.values())
        return program_bytes
