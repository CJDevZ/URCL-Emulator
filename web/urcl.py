import array
from typing import Callable

from lark import Transformer, v_args, Lark, UnexpectedCharacters, UnexpectedToken
from lark.tree import Meta

from compiler import Compiler, Error, ParameterToken, OpCode, dataclass, TypedValue


@dataclass(slots=True,frozen=True)
class Label:
    name: str

    def build(self, instruction: int, error: Callable[[str], None], defines: dict[str, ParameterToken]):
        if self.name in defines:
            error(f"Duplicate label '{self.name}'")
            return
        defines[self.name] = ParameterToken('number', instruction)


@dataclass(slots=True,frozen=True)
class Define:
    name: str
    value: TypedValue

    def build(self, error: Callable[[str], None], defines: dict[str, ParameterToken]):
        if self.name in defines:
            error(f"Duplicate constant '{self.name}'")
            return
        defines[self.name] = ParameterToken(*self.value)


@dataclass(slots=True,frozen=True)
class DefineWords:
    words: list[TypedValue]

    @property
    def length(self) -> int:
        return len(self.words)

    def build(self, compiled: list[int], error: Callable[[str], None], defines: dict[str, ParameterToken]):
        for arg_type, value in self.words:
            while arg_type in ('define', 'label'):
                defined = defines.get(value)
                if defined is None:
                    error(f"Unknown constant '{value}'")
                    return
                arg_type, value = defined.value_type, defined.value
            try:
                compiled.append(ParameterToken(arg_type, value).get_binary('number')[1])
            except ValueError as e:
                error(str(e))


@dataclass(slots=True,frozen=True)
class Instruction:
    name: str
    arguments: list[tuple[[str, str]]]

    @property
    def length(self) -> int:
        return len(self.arguments) + 1

    def build(self, compiled: list[int], error: Callable[[str], None], defines: dict[str, ParameterToken]):
        try:
            operator: OpCode = OpCode[self.name]
        except KeyError:
            error(f"Invalid op code '{self.name}'")
            return
        if (e := operator.add(compiled, defines.get, *self.arguments)) is not None:
            error(e)


class URCLTransformer(Transformer):

    def NUMBER(self, tok):
        return "number", int(tok, 0)

    def WORD(self, tok):
        return str(tok)

    def CHAR(self, tok):
        text = str(tok[1:-1])
        return "number", int.from_bytes(text.encode().decode("unicode_escape").encode(), "big")

    def dot_label(self, items):
        return "label", f'.{items[0]}'

    def defined(self, items):
        return 'define', items[0]

    def param(self, items):
        return items[0]

    @v_args(meta=True)
    def line(self, meta: Meta, items):
        return meta.line - 1, items[0]

    def instruction(self, items):
        operator: str = items[0].upper()
        arguments: list[str] = items[1:]

        return Instruction(operator, arguments)

    def label(self, items):
        return Label(items[0][1])

    def define(self, items):
        return Define(*items)

    def define_word(self, items):
        return DefineWords([items[0]])

    def define_word_list(self, items):
        return DefineWords(items)

    def start(self, items):
        return items

class URCLCompiler(Compiler):
    def __init__(self):
        with open("urcl.lark", "r") as f:
            super().__init__(Lark(f.read(), parser="lalr", propagate_positions=True))

    def compile(self, text: str) -> bytes | list[Error]:
        text += "\n"
        errors: dict[int, Error] = {}
        try:
            tree = self.parser.parse(text)
        except (UnexpectedCharacters, UnexpectedToken) as e:
            errors[e.line - 1] = Error(e.line - 1, str(e), 'error')
            return list(errors.values())
        program = URCLTransformer().transform(tree)

        defines: dict[str, ParameterToken] = {}
        for i in range(99):
            defines['r'+str(i)] = ParameterToken('register', i)
            defines['R'+str(i)] = ParameterToken('register', i)
            defines['$'+str(i)] = ParameterToken('register', i)
        defines['SP'] = ParameterToken('register', 99)
        instruction = 0

        def make_error_handler(line):
            return lambda error: errors.__setitem__(
                line,
                Error(line, error, "error")
            )

        for (line, buildable) in program:
            add_error = make_error_handler(line)

            if isinstance(buildable, Label):
                buildable.build(instruction, add_error, defines)
            elif isinstance(buildable, Define):
                buildable.build(add_error, defines)
            elif isinstance(buildable, (DefineWords, Instruction)):
                instruction += buildable.length

        compiled: list[int] = []
        for (line, buildable) in program:
            if not isinstance(buildable, (Instruction, DefineWords)):
                continue
            add_error = make_error_handler(line)
            buildable.build(compiled, add_error, defines)

        if errors:
            return list(errors.values())

        compiled.append(OpCode.HLT.id)
        try:
            program_bytes: bytes = array.array('I', compiled).tobytes()
        except OverflowError:
            errors[0] = Error(0, f"Program using more than 32 bits for some words", type="error")
            return list(errors.values())
        return program_bytes
