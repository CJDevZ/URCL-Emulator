from dataclasses import dataclass
from enum import Enum
from typing import Callable, Optional

from lark import Lark


@dataclass(slots=True,frozen=True)
class Error:
    row: int
    text: str
    type: str

@dataclass(slots=True,frozen=True)
class ParameterToken:
    value_type: str
    value: int

    def get_binary(self, arg_type: str | list[str]) -> tuple[str, int]:
        if isinstance(arg_type, str):
            if self.value_type != arg_type:
                raise ValueError(f"Op requires '{arg_type}', found '{self.value_type}'")
        elif not self.value_type in arg_type:
            raise ValueError(f"Op requires '{'\' or \''.join(arg_type)}', found '{self.value_type}'")
        elif abs(self.value) > 0xffffffff:
            raise ValueError(f"Immediate Value '{self.value}' is too Large")
        return self.value_type, self.value & 0xffffffff


class OpCode(Enum):
    ADD = 0, ['register', ['register', 'number'], ['register', 'number']]
    RSH = 1, ['register', 'register']
    LOD = 2, ['register', ['register', 'number']]
    STR = 3, [['register', 'number'], ['register', 'number']]
    BGE = 4, [['register', 'number'], ['register', 'number'], ['register', 'number']]
    NOR = 5, ['register', ['register', 'number'], ['register', 'number']]
    SUB = 6, ['register', ['register', 'number'], ['register', 'number']]
    JMP = 7, [['register', 'number']]
    MOV = 8, ['register', ['register', 'number']]
    NOP = 9, []
    IMM = 10, ['register', 'number']
    LSH = 11, ['register', 'register']
    INC = 12, ['register', 'register']
    DEC = 13, ['register', 'register']
    NEG = 14, ['register', 'register']
    AND = 15, ['register', ['register', 'number'], ['register', 'number']]
    OR = 16, ['register', ['register', 'number'], ['register', 'number']]
    NOT = 17, ['register', 'register']
    XNOR = 18, ['register', ['register', 'number'], ['register', 'number']]
    XOR = 19, ['register', ['register', 'number'], ['register', 'number']]
    NAND = 20, ['register', ['register', 'number'], ['register', 'number']]
    BRL = 21, [['register', 'number'], ['register', 'number'], ['register', 'number']]
    BRG = 22, [['register', 'number'], ['register', 'number'], ['register', 'number']]
    BRE = 23, [['register', 'number'], ['register', 'number'], ['register', 'number']]
    BNE = 24, [['register', 'number'], ['register', 'number'], ['register', 'number']]
    BOD = 25, [['register', 'number'], 'register']
    BEV = 26, [['register', 'number'], 'register']
    BLE = 27, [['register', 'number'], ['register', 'number'], ['register', 'number']]
    BRZ = 28, [['register', 'number'], 'register']
    BNZ = 29, [['register', 'number'], 'register']
    BRN = 30, [['register', 'number'], 'register']
    BRP = 31, [['register', 'number'], 'register']
    PSH = 32, [['register', 'number']]
    POP = 33, ['register']
    CAL = 34, [['register', 'number']]
    RET = 35, []
    HLT = 36, []
    CPY = 37, [['register', 'number'], ['register', 'number']]
    BRC = 38, [['register', 'number'], ['register', 'number'], ['register', 'number']]
    BNC = 39, [['register', 'number'], ['register', 'number'], ['register', 'number']]
    MLT = 40, ['register', ['register', 'number'], ['register', 'number']]
    UMLT = 41, ['register', ['register', 'number'], ['register', 'number']]
    SUMLT = 42, ['register', ['register', 'number'], ['register', 'number']]
    DIV = 43, ['register', ['register', 'number'], ['register', 'number']]
    SDIV = 44, ['register', ['register', 'number'], ['register', 'number']]
    MOD = 45, ['register', ['register', 'number'], ['register', 'number']]
    BSR = 46, ['register', ['register', 'number'], ['register', 'number']]
    BSL = 47, ['register', ['register', 'number'], ['register', 'number']]
    SRS = 48, ['register', 'register']
    BSS = 49, ['register', ['register', 'number'], ['register', 'number']]
    SBRL = 50, [['register', 'number'], ['register', 'number'], ['register', 'number']]
    SBRG = 51, [['register', 'number'], ['register', 'number'], ['register', 'number']]
    SBLE = 52, [['register', 'number'], ['register', 'number'], ['register', 'number']]
    SBGE = 53, [['register', 'number'], ['register', 'number'], ['register', 'number']]
    SETE = 54, ['register', ['register', 'number'], ['register', 'number']]
    SETNE = 55, ['register', ['register', 'number'], ['register', 'number']]
    SETG = 56, ['register', ['register', 'number'], ['register', 'number']]
    SETL = 57, ['register', ['register', 'number'], ['register', 'number']]
    SETGE = 58, ['register', ['register', 'number'], ['register', 'number']]
    SETLE = 59, ['register', ['register', 'number'], ['register', 'number']]
    SETC = 60, ['register', ['register', 'number'], ['register', 'number']]
    SETNC = 61, ['register', ['register', 'number'], ['register', 'number']]
    SSETG = 62, ['register', ['register', 'number'], ['register', 'number']]
    SSETL = 63, ['register', ['register', 'number'], ['register', 'number']]
    SSETGE = 64, ['register', ['register', 'number'], ['register', 'number']]
    SSETLE = 65, ['register', ['register', 'number'], ['register', 'number']]
    LLOD = 66, ['register', ['register', 'number'], ['register', 'number']]
    LSTR = 67, [['register', 'number'], ['register', 'number'], ['register', 'number']]
    ABS = 68, ['register', 'register']
    IN = 69, ['register', 'number']
    OUT = 70, ['number', ['register', 'number']]
    DW = -1, []

    def __init__(self, id: int, arguments: list[str | list[str]]):
        self.id = id
        self.arguments = arguments

    def add(self, compiled: list[int], define_getter: Callable[[str], ParameterToken], *params: tuple[str, str]) -> Optional[str]:
        if self.id < 0:
            for arg_type, value in params:
                try:
                    while arg_type in ('define', 'label'):
                        defined = define_getter(value)
                        arg_type, value = defined.value_type, defined.value
                except KeyError:
                    arg_type, value = 'number', 0
                    return f"Unknown constant '{value}'"
                try:
                    compiled.append(ParameterToken(arg_type, value).get_binary('number')[1])
                except ValueError as e:
                    return str(e)
            return None
        args_iter = iter(self.arguments)
        arg_mask = 0
        operator_index = len(compiled)
        compiled.append(0)
        for arg in params:
            arg_type, value = arg
            try:
                try:
                    while arg_type in ('define', 'label'):
                        defined = define_getter(value)
                        arg_type, value = defined.value_type, defined.value
                except KeyError:
                    arg_type, value = 'number', 0
                    return f"Unknown constant '{value}'"
                arg_type, value = ParameterToken(arg_type, value).get_binary(next(args_iter))
                arg_mask <<= 1
                if arg_type == 'register':
                    arg_mask |= 1
                compiled.append(value)
            except ValueError as e:
                return str(e)
            except StopIteration:
                return f"Invalid parameter count"

        compiled[operator_index] = self.id | (arg_mask << 8)
        return None

class Compiler:
    def __init__(self, parser: Lark):
        self.parser = parser

    def compile(self, text: str) -> str | list[Error]:
        return []
