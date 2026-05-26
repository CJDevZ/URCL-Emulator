import array

from lark import Transformer, v_args, Lark, UnexpectedCharacters
from lark.tree import Meta

from compiler import Compiler, Error, ParameterToken, OpCode


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
        if items[0][0] == '\n':
            return meta.line, 'newline', '\n', None
        return meta.line - 1, *items[0]

    def instruction(self, items):
        opname = items[0].upper()
        args = items[1:]

        return 'instruction', opname, args

    def label(self, items):
        return 'label', items[0][1], None

    def define(self, items):
        return 'define', *items

    def start(self, items):
        return items

class URCLCompiler(Compiler):
    def __init__(self):
        with open("urcl.lark", "r") as f:
            super().__init__(Lark(f.read(), parser="lalr", propagate_positions=True))

    def compile(self, text: str) -> bytes | list[Error]:
        errors: dict[int, Error] = {}
        try:
            tree = self.parser.parse(text)
        except UnexpectedCharacters as e:
            errors[e.line - 1] = Error(e.line - 1, str(e), 'error')
            return list(errors.values())
        program = URCLTransformer().transform(tree)

        defines: dict[str, ParameterToken] = {}
        for i in range(99):
            defines['r'+str(i)] = ParameterToken('register', i)
            defines['R'+str(i)] = ParameterToken('register', i)
        defines['SP'] = ParameterToken('register', 99)
        instruction = 0
        for line, instruction_type, name, args in program:
            if instruction_type == "instruction":
                try:
                    operator: OpCode = OpCode[name]
                except KeyError:
                    errors[line] = Error(line, f"Invalid op code '{name}'", "error")
                    continue
                instruction += len(args)
                if operator.id >= 0:
                    instruction += 1
            elif instruction_type == "label":
                defines[name] = ParameterToken('number', instruction)
            elif instruction_type == "define":
                defines[name] = ParameterToken(*args)

        compiled: list[int] = []
        for line, instruction_type, name, args in program:
            if instruction_type == "instruction":
                try:
                    operator: OpCode = OpCode[name]
                except KeyError:
                    continue
                error = operator.add(compiled, defines.get, *args)
                if error is not None:
                    errors[line] = Error(line, error, "error")

        if errors:
            return list(errors.values())

        compiled.append(OpCode.HLT.id)
        try:
            program_bytes: bytes = array.array('I', compiled).tobytes()
        except OverflowError:
            errors[0] = Error(0, f"Program using more than 32 bits for some words", type="error")
            return list(errors.values())
        return program_bytes
