from __future__ import annotations

import array
from typing import Optional, Callable

from lark import Transformer, v_args, Lark, UnexpectedCharacters, UnexpectedToken
from lark.tree import Meta

from compiler import Compiler, Error, OpCode, dataclass


@dataclass(slots=True,frozen=True)
class Value:
    value_type: str
    value: str

    def to_urcl(self, variable_getter: Callable[[str], VarDeclaration], linker: Callable[[int, int], None], index: int):
        if self.value_type == 'variable':
            variable = variable_getter(self.value)
            if variable is None:
                raise NameError(f"Unknown variable '{self.value}'")
            if variable.const:
                linker(index, variable.data_index)
                return 'number', 0
            raise NotImplementedError("Haven't handled non-constants yet")
        return 'number', int(self.value)


@dataclass(slots=True,frozen=True)
class VarType:
    var_type: str


@dataclass(slots=True)
class VarDeclaration:
    name: str
    var_type: VarType
    value: Value
    const: bool
    data_index: int = 0


@dataclass(slots=True,frozen=True)
class FunctionCall:
    name: str
    arguments: list[Value]


@dataclass(slots=True,frozen=True)
class ListVarType(VarType):
    size: int


@dataclass(slots=True)
class Block:
    data: list
    variables: dict[str, VarDeclaration]

    def build(self, get_builtin_function: Callable[[str], SysFunction], compiled: list[int], data: list[int], linker: Callable[[int, int], None], add_error: Callable[[int, str], None]):
        for line, tree in self.data:
            print(tree)
            if isinstance(tree, VarDeclaration):
                if tree.const and tree.var_type.var_type == 'str':
                    tree.data_index = len(data)
                    data.extend(tree.value.value.encode().decode('unicode_escape').encode('ascii'))
                    data.append(0)
                self.variables[tree.name] = tree
            elif isinstance(tree, FunctionCall):
                function = get_builtin_function(tree.name)
                if function is None:
                    add_error(line, f"Unknown function '{tree.name}'")
                    continue
                else:
                    error = function.build(compiled, self.variables.get, linker, tree.arguments)
                    if error is not None:
                        add_error(line, error)
            elif isinstance(tree, Function):
                pass


@dataclass(slots=True,frozen=True)
class Function:
    name: str
    parameters: list[str]
    body: Block


@dataclass(slots=True,frozen=True)
class InlineFunction(Function):
    def build(self, compiled: list[int], arguments: list[Value]):
        pass


@dataclass(slots=True,frozen=True)
class SysFunction:
    def build(self, compiled: list[int], variable_getter: Callable[[str], VarDeclaration], linker: Callable[[int, int], None], arguments: list[Value]) -> Optional[str]:
        try:
            arg_index = len(compiled) + 1
            error = OpCode.OUT.add(compiled, None, *(arg.to_urcl(variable_getter, linker, arg_index + index) for index, arg in enumerate(arguments)))
            if error is not None:
                return error
        except NameError as e:
            return e.args[0]
        except NotImplementedError as e:
            return e.args[0]
        return None


class DLangTransformer(Transformer):
    def num(self, tokens):
        return Value('i32', int(tokens[0].value))

    def str(self, tokens):
        return Value('str', tokens[0].value[1:-1])

    def CNAME(self, tok):
        return tok

    def var(self, tokens):
        return Value('variable', tokens[0].value)

    def basic_type(self, tokens):
        return VarType(tokens[0].value)

    def list_type(self, tokens):
        return ListVarType(tokens[0].var_type, int(tokens[1].value))

    def block(self, tokens):
        return Block(tokens, {})

    @v_args(meta=True)
    def func_def(self, meta: Meta, tokens):
        return meta.line - 1, Function(tokens[0].value, tokens[1], tokens[2])

    @v_args(meta=True)
    def var_declaration(self, meta: Meta, tokens):
        return meta.line - 1, VarDeclaration(tokens[0].value, tokens[1], tokens[2], False)

    @v_args(meta=True)
    def const_declaration(self, meta: Meta, tokens):
        return meta.line - 1, VarDeclaration(tokens[0].value, tokens[1], tokens[2], True)

    def arglist(self, tokens) -> list:
        return tokens

    @v_args(meta=True)
    def call(self, meta: Meta, tokens):
        return meta.line - 1, FunctionCall(tokens[0].value, tokens[1])

    def start(self, tokens):
        return Block(tokens, {})


class DLangCompiler(Compiler):
    def __init__(self):
        with open("dlang.lark", "r") as f:
            super().__init__(Lark(f.read(), parser="lalr", propagate_positions=True))

        self.builtin_functions: dict[str, SysFunction] = {'set_port': SysFunction()}

    def compile(self, text: str) -> bytes | list[Error]:
        errors: dict[int, Error] = {}
        try:
            tree = self.parser.parse(text)
        except (UnexpectedCharacters, UnexpectedToken) as e:
            errors[e.line - 1] = Error(e.line - 1, str(e), 'error')
            return list(errors.values())
        program: Block = DLangTransformer().transform(tree)

        compiled: list[int] = []
        link_table: dict[int, list[int]] = {}
        data: list[int] = []

        def add_link(linked: int, data_index: int):
            if data_index not in link_table:
                link_table[data_index] = []
            link_table[data_index].append(linked)

        def add_error(line: int, error: str):
            errors[line] = Error(line, error, 'error')

        program.build(self.builtin_functions.get, compiled, data, add_link, add_error)

        if errors:
            return list(errors.values())

        compiled.append(OpCode.HLT.id)
        data_start = len(compiled)
        compiled.extend(data)
        for data_index, linked in link_table.items():
            for link in linked:
                compiled[link] = data_start + data_index
        print(compiled)

        try:
            program_bytes: bytes = array.array('I', compiled).tobytes()
        except OverflowError:
            errors[0] = Error(0, f"Program using more than 32 bits for some words", type="error")
            return list(errors.values())
        return program_bytes
