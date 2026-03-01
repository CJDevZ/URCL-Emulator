import array
import random
from dataclasses import dataclass
from typing import Any

from dacite import from_dict
from enum import IntFlag

from dataclasses_json import dataclass_json
from flask import Flask, send_file, request
from flask_limiter import Limiter
from flask_limiter.util import get_remote_address
import redis
from uuid import UUID


database = redis.Redis(host='localhost', port=6379, db=0)


app = Flask(__name__)
limiter = Limiter(
    key_func=get_remote_address,
    default_limits=["6 per minute"],
)

@app.route('/emulator/urcl')
def hello_world():
    return send_file('http/index.html', mimetype='text/html'), 200


@dataclass(slots=True,frozen=True)
class Token:
    line: int


class ParameterType(IntFlag):
    IMMEDIATE = 1
    REGISTER = 2
    ANY = IMMEDIATE | REGISTER
    DWORD = 4

    def get_int(self):
        return self.value - 1


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
class OpToken(Token):
    value: str

    def get_binary(self) -> int:
        return op_codes[self.value.upper()].id


@dataclass(slots=True,frozen=True)
class ParameterToken(Token):
    value: str

    def get_binary(self, arg_type: ParameterType) -> list[int]:
        type_value: ParameterType = ParameterType(self.value[0].isalpha() + 1)
        int_value: int = int(self.value, 0) if self.value[0].isdigit() else int(self.value[1:])
        if not arg_type.value & type_value:
            raise ValueError(f"Op requires '{arg_type.name}', found '{type_value.name}'")
        elif abs(int_value) > 0xffffffff:
            raise ValueError(f"Immediate Value too Large")
        return [type_value - 1, int_value & 0xffffffff] if arg_type == ParameterType.ANY else [int_value & 0xffffffff]


@dataclass_json
@dataclass(slots=True,frozen=True)
class GetRequest:
    uuid: list[int]
    auth: int

@dataclass(slots=True,frozen=True)
class GetResponse:
    uuid: UUID
    compiled: list[int]


@app.route('/emulator/urcl/get', methods=["POST"])
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


@app.route('/emulator/urcl/compile', methods=['POST'])
@limiter.limit("5 per minute")
def compile():
    body: bytes = request.get_json()
    if not isinstance(body, str):
        return send_file('http/index.html', mimetype='text/html'), 400

    defines: dict[str, ParameterToken] = {}
    tokens: list[list[Token]] = []

    line_number: int = -1
    instruction: int = 0
    lines = body.split('\n')
    has_error = False
    errors: dict[int, Error] = {}

    for line in lines:
        skip = False
        line_number += 1
        split = iter([a.strip() for a in line.split(' ')])
        for e in split:
            if skip: break
            if e == '': continue
            if e[0] in [';', '#']: break
            if e[0] == '.':
                defines[e] = ParameterToken(line_number, str(instruction))
            elif e.lower() == '@define':
                define_name = ''
                while define_name == '':
                    define_name = next(split)
                parameter = ''
                while parameter == '':
                    parameter = next(split)
                defines[define_name] = ParameterToken(line_number, parameter)
            else:
                try:
                    instruction += 1
                    arguments = op_codes[e.upper()].arguments
                    if len(arguments) > 0:
                        if arguments[0] == ParameterType.DWORD:
                            instruction -= 1
                            instruction += sum(1 for a in line.split(" ") if a != '') - 1
                        else:
                            instruction += sum((arg == ParameterType.ANY) + 1 for arg in arguments)

                except KeyError:
                    has_error = True
                    errors[line_number] = Error(line_number, f"Invalid op code '{e}'", "error")
                skip = True

    line_number = -1
    instruction = 0
    for line in lines:
        skip = False
        line_number += 1
        split = [a.strip() for a in line.split(' ')]
        operands: list = []
        first = True
        for e in split:
            if e == '': continue
            if e[0] == '.': skip = True
            break

        if skip: continue
        for e in split:
            if e == '': continue
            if e[0] in [';', '#']: break
            elif e.lower() == "@define":
                break
            else:
                define = defines.get(e)
                if first:
                    operands.append(OpToken(line_number, e))
                else:
                    operands.append(ParameterToken(line_number, define.value if define is not None else e))
                instruction += 1
            first = False
        if operands:
            tokens.append(operands)

    compiled: list[int] = []
    for token_list in tokens:
        operand = token_list.pop(0)
        if not isinstance(operand, OpToken): continue
        op_code_integer: int
        try:
            op_code_integer = operand.get_binary()
        except KeyError:
            has_error = True
            errors[line_number] = Error(line_number, f"Invalid op code '{operand.value}'", "error")
            continue
        if op_code_integer >= 0:
            compiled.append(op_code_integer)
        args_list = op_codes[operand.value.upper()].arguments
        if len(args_list) == 0:
            continue
        if args_list[0] == ParameterType.DWORD:
            for token in token_list:
                for value in token.get_binary(ParameterType.IMMEDIATE):
                    compiled.append(value)
            continue

        if len(args_list) != len(token_list):
            has_error = True
            errors[operand.line] = Error(operand.line, "Invalid parameter count", "error")

        args = iter(args_list)
        for token in token_list:
            token: ParameterToken
            try:
                for value in token.get_binary(next(args)):
                    compiled.append(value)
            except ValueError:
                has_error = True
                errors[token.line] = Error(token.line, f"Invalid parameter '{token.value}'", "error")
            except StopIteration:
                has_error = True
                errors[token.line] = Error(token.line, f"Invalid parameter count", "error")

    auth_integer = random.randint(1, 2147483647)
    compiled.append(op_codes["HLT"].id)
    program_bytes: bytes | None = None
    try:
        program_bytes = array.array('I', compiled).tobytes()
    except OverflowError:
        has_error = True
        errors[0] = Error(line_number, f"Program using more than 32 bits for some words", type="error")

    if has_error:
        return list(errors.values()), 400
    database.setex(auth_integer.to_bytes(4, signed=True), 300, program_bytes)
    return f"ok {auth_integer}", 200

if __name__ == '__main__':
    app.run()