import array
import random
from dataclasses import dataclass
from typing import Any

from dacite import from_dict
from enum import IntFlag

from dataclasses_json import dataclass_json
from lark import Lark, Transformer, v_args
from flask import Flask, send_file, request
from flask_limiter import Limiter
from flask_limiter.util import get_remote_address
import redis
from uuid import UUID

from lark.tree import Meta

database = redis.Redis(host='localhost', port=6379, db=0)


with open("urcl.lark", "r") as f:
    parser = Lark(f.read(), parser="lalr", propagate_positions=True)
app = Flask(__name__)
limiter = Limiter(
    key_func=get_remote_address,
    default_limits=["6 per minute"],
)

@app.get('/emulator/urcl')
def hello_world():
    return send_file('http/index.html')


class ParameterType(IntFlag):
    IMMEDIATE = 1
    REGISTER = 2
    ANY = IMMEDIATE | REGISTER
    DWORD = 4


@dataclass(slots=True,frozen=True)
class OpCode:
    id: int
    arguments: list[ParameterType]


op_codes = {
    "ADD": OpCode(0, [ParameterType.REGISTER, ParameterType.ANY, ParameterType.ANY]),
    "RSH": OpCode(1, [ParameterType.REGISTER, ParameterType.REGISTER]),
    "LOD": OpCode(2, [ParameterType.REGISTER, ParameterType.ANY]),
    "STR": OpCode(3, [ParameterType.ANY, ParameterType.ANY]),
    "BGE": OpCode(4, [ParameterType.ANY, ParameterType.ANY, ParameterType.ANY]),
    "NOR": OpCode(5, [ParameterType.REGISTER, ParameterType.ANY, ParameterType.ANY]),
    "SUB": OpCode(6, [ParameterType.REGISTER, ParameterType.ANY, ParameterType.ANY]),
    "JMP": OpCode(7, [ParameterType.ANY]),
    "MOV": OpCode(8, [ParameterType.REGISTER, ParameterType.ANY]),
    "NOP": OpCode(9, []),
    "IMM": OpCode(10, [ParameterType.REGISTER, ParameterType.IMMEDIATE]),
    "LSH": OpCode(11, [ParameterType.REGISTER, ParameterType.REGISTER]),
    "INC": OpCode(12, [ParameterType.REGISTER, ParameterType.REGISTER]),
    "DEC": OpCode(13, [ParameterType.REGISTER, ParameterType.REGISTER]),
    "NEG": OpCode(14, [ParameterType.REGISTER, ParameterType.REGISTER]),
    "AND": OpCode(15, [ParameterType.REGISTER, ParameterType.ANY, ParameterType.ANY]),
    "OR": OpCode(16, [ParameterType.REGISTER, ParameterType.ANY, ParameterType.ANY]),
    "NOT": OpCode(17, [ParameterType.REGISTER, ParameterType.REGISTER]),
    "XNOR": OpCode(18, [ParameterType.REGISTER, ParameterType.ANY, ParameterType.ANY]),
    "XOR": OpCode(19, [ParameterType.REGISTER, ParameterType.ANY, ParameterType.ANY]),
    "NAND": OpCode(20, [ParameterType.REGISTER, ParameterType.ANY, ParameterType.ANY]),
    "BRL": OpCode(21, [ParameterType.ANY, ParameterType.ANY, ParameterType.ANY]),
    "BRG": OpCode(22, [ParameterType.ANY, ParameterType.ANY, ParameterType.ANY]),
    "BRE": OpCode(23, [ParameterType.ANY, ParameterType.ANY, ParameterType.ANY]),
    "BNE": OpCode(24, [ParameterType.ANY, ParameterType.ANY, ParameterType.ANY]),
    "BOD": OpCode(25, [ParameterType.ANY, ParameterType.REGISTER]),
    "BEV": OpCode(26, [ParameterType.ANY, ParameterType.REGISTER]),
    "BLE": OpCode(27, [ParameterType.ANY, ParameterType.ANY, ParameterType.ANY]),
    "BRZ": OpCode(28, [ParameterType.ANY, ParameterType.REGISTER]),
    "BNZ": OpCode(29, [ParameterType.ANY, ParameterType.REGISTER]),
    "BRN": OpCode(30, [ParameterType.ANY, ParameterType.REGISTER]),
    "BRP": OpCode(31, [ParameterType.ANY, ParameterType.REGISTER]),
    "PSH": OpCode(32, [ParameterType.ANY]),
    "POP": OpCode(33, [ParameterType.REGISTER]),
    "CAL": OpCode(34, [ParameterType.ANY]),
    "RET": OpCode(35, []),
    "HLT": OpCode(36, []),
    "CPY": OpCode(37, [ParameterType.ANY, ParameterType.ANY]),
    "BRC": OpCode(38, [ParameterType.ANY, ParameterType.ANY, ParameterType.ANY]),
    "BNC": OpCode(39, [ParameterType.ANY, ParameterType.ANY, ParameterType.ANY]),
    "MLT": OpCode(40, [ParameterType.REGISTER, ParameterType.ANY, ParameterType.ANY]),
    "UMLT": OpCode(41, [ParameterType.REGISTER, ParameterType.ANY, ParameterType.ANY]),
    "SUMLT": OpCode(42, [ParameterType.REGISTER, ParameterType.ANY, ParameterType.ANY]),
    "DIV": OpCode(43, [ParameterType.REGISTER, ParameterType.ANY, ParameterType.ANY]),
    "SDIV": OpCode(44, [ParameterType.REGISTER, ParameterType.ANY, ParameterType.ANY]),
    "MOD": OpCode(45, [ParameterType.REGISTER, ParameterType.ANY, ParameterType.ANY]),
    "BSR": OpCode(46, [ParameterType.REGISTER, ParameterType.ANY, ParameterType.ANY]),
    "BSL": OpCode(47, [ParameterType.REGISTER, ParameterType.ANY, ParameterType.ANY]),
    "SRS": OpCode(48, [ParameterType.REGISTER, ParameterType.REGISTER]),
    "BSS": OpCode(49, [ParameterType.REGISTER, ParameterType.ANY, ParameterType.ANY]),
    "SBRL": OpCode(50, [ParameterType.ANY, ParameterType.ANY, ParameterType.ANY]),
    "SBRG": OpCode(51, [ParameterType.ANY, ParameterType.ANY, ParameterType.ANY]),
    "SBLE": OpCode(52, [ParameterType.ANY, ParameterType.ANY, ParameterType.ANY]),
    "SBGE": OpCode(53, [ParameterType.ANY, ParameterType.ANY, ParameterType.ANY]),
    "SETE": OpCode(54, [ParameterType.REGISTER, ParameterType.ANY, ParameterType.ANY]),
    "SETNE": OpCode(55, [ParameterType.REGISTER, ParameterType.ANY, ParameterType.ANY]),
    "SETG": OpCode(56, [ParameterType.REGISTER, ParameterType.ANY, ParameterType.ANY]),
    "SETL": OpCode(57, [ParameterType.REGISTER, ParameterType.ANY, ParameterType.ANY]),
    "SETGE": OpCode(58, [ParameterType.REGISTER, ParameterType.ANY, ParameterType.ANY]),
    "SETLE": OpCode(59, [ParameterType.REGISTER, ParameterType.ANY, ParameterType.ANY]),
    "SETC": OpCode(60, [ParameterType.REGISTER, ParameterType.ANY, ParameterType.ANY]),
    "SETNC": OpCode(61, [ParameterType.REGISTER, ParameterType.ANY, ParameterType.ANY]),
    "SSETG": OpCode(62, [ParameterType.REGISTER, ParameterType.ANY, ParameterType.ANY]),
    "SSETL": OpCode(63, [ParameterType.REGISTER, ParameterType.ANY, ParameterType.ANY]),
    "SSETGE": OpCode(64, [ParameterType.REGISTER, ParameterType.ANY, ParameterType.ANY]),
    "SSETLE": OpCode(65, [ParameterType.REGISTER, ParameterType.ANY, ParameterType.ANY]),
    "LLOD": OpCode(66, [ParameterType.REGISTER, ParameterType.ANY, ParameterType.ANY]),
    "LSTR": OpCode(67, [ParameterType.ANY, ParameterType.ANY, ParameterType.ANY]),
    "ABS": OpCode(68, [ParameterType.REGISTER, ParameterType.REGISTER]),
    "IN": OpCode(69, [ParameterType.REGISTER, ParameterType.IMMEDIATE]),
    "OUT": OpCode(70, [ParameterType.IMMEDIATE, ParameterType.ANY]),
    "DW": OpCode(-1, [ParameterType.DWORD])
}


@dataclass(slots=True,frozen=True)
class ParameterToken:
    value_type: str
    value: int

    def get_binary(self, arg_type: ParameterType) -> tuple[ParameterType, int]:
        type_value: ParameterType = ParameterType((self.value_type == 'register') + 1)
        if not arg_type.value & type_value:
            raise ValueError(f"Op requires '{arg_type.name}', found '{type_value.name}'")
        elif abs(self.value) > 0xffffffff:
            raise ValueError(f"Immediate Value '{self.value}' is too Large")
        return type_value, self.value & 0xffffffff


@dataclass_json
@dataclass(slots=True,frozen=True)
class GetRequest:
    uuid: list[int]
    auth: int

@dataclass(slots=True,frozen=True)
class GetResponse:
    uuid: UUID
    compiled: list[int]


@app.post('/emulator/urcl/get')
def emulator_get_urcl():
    requests = request.get_json()
    if not isinstance(requests, list):
        return 'Expected Auth Integers', 400

    response: list[GetResponse] = []

    try:
        for get_request in requests:
            get_request: dict[str, Any]
            get_request: GetRequest = from_dict(data_class=GetRequest, data=get_request)
            auth: int = get_request.auth
            auth_bytes = auth.to_bytes(4, signed=True)
            binary = database.get(auth_bytes)
            if not binary:
                continue
            int_array = array.array('i')
            int_array.frombytes(binary)
            response.append(GetResponse(UUID(int=((get_request.uuid[0] & 0xFFFFFFFF) << 96) | ((get_request.uuid[1] & 0xFFFFFFFF) << 64) | ((get_request.uuid[2] & 0xFFFFFFFF) << 32) | (get_request.uuid[3] & 0xFFFFFFFF)), int_array.tolist()))
    except Exception as e:
        return str(e), 400

    return response, 200


@dataclass(slots=True,frozen=True)
class Error:
    row: int
    text: str
    type: str


class Compiler(Transformer):

    def NUMBER(self, tok):
        return "number", int(tok, 0)

    def WORD(self, tok):
        return str(tok)

    def CHAR(self, tok):
        text = str(tok[1:-1])
        return "number", ord(text.encode().decode("unicode_escape"))

    def dot_label(self, items):
        return "label", f'.{items[0]}'

    def defined(self, items):
        tok = items[0]
        return ('register', int(tok[1:])) if tok[0].upper() == 'R' else ('define', tok)

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


@app.post('/emulator/urcl/compile')
@limiter.limit("5 per minute")
def compile():
    body: bytes = request.get_json()
    if not isinstance(body, str):
        return send_file('http/index.html', mimetype='text/html'), 400

    tree = parser.parse(body)
    program = Compiler().transform(tree)

    defines: dict[str, ParameterToken] = {}
    instruction = 0
    errors: dict[int, Error] = {}
    for line, instruction_type, name, args in program:
        if instruction_type == "instruction":
            try:
                operator: OpCode = op_codes[name]
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
                operator: OpCode = op_codes[name]
            except KeyError:
                continue
            if operator.id < 0:
                for arg_type, arg in args:
                    if arg_type != 'number':
                        errors[line] = Error(line, f"Invalid parameter '{arg_type}'", "error")
                        continue
                    compiled.append(arg)
                continue
            if len(operator.arguments) != len(args):
                errors[line] = Error(line, "Invalid parameter count", "error")
            args_iter = iter(operator.arguments)
            arg_mask = 0
            operator_index = len(compiled)
            compiled.append(0)
            for arg in args:
                arg_type, arg_value = arg
                try:
                    if arg_type in ('define', 'label'):
                        try:
                            param_type, value = defines[arg_value].get_binary(next(args_iter))
                        except KeyError:
                            param_type, value = 'number', 0
                            errors[line] = Error(line, f"Invalid parameter '{arg_value}'", "error")
                    else:
                        param_type, value = ParameterToken(arg_type, arg_value).get_binary(next(args_iter))
                    arg_mask <<= 1
                    if param_type == ParameterType.REGISTER:
                        arg_mask |= 1
                    compiled.append(value)
                except ValueError as e:
                    errors[line] = Error(line, f"{e}", "error")
                except StopIteration:
                    errors[line] = Error(line, f"Invalid parameter count", "error")

            compiled[operator_index] = operator.id | (arg_mask << 8)

    if errors:
        return list(errors.values()), 400

    auth_integer = random.randint(1, 2147483647)
    compiled.append(op_codes["HLT"].id)
    try:
        program_bytes: bytes = array.array('I', compiled).tobytes()
    except OverflowError:
        errors[0] = Error(0, f"Program using more than 32 bits for some words", type="error")
        return list(errors.values()), 400

    database.setex(auth_integer.to_bytes(4, signed=True), 300, program_bytes)
    return f"ok {auth_integer}", 200

if __name__ == '__main__':
    app.run()