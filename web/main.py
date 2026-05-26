import array
import random
from dataclasses import dataclass
from typing import Any
from uuid import UUID

import redis
from dacite import from_dict
from dataclasses_json import dataclass_json
from flask import Flask, send_file, request
from flask_limiter import Limiter
from flask_limiter.util import get_remote_address

from compiler import Error, Compiler
from dlang import DLangCompiler
from urcl import URCLCompiler

database = redis.Redis(host='localhost', port=6379, db=0)


app = Flask(__name__)
limiter = Limiter(
    key_func=get_remote_address,
    default_limits=["6 per minute"],
)

@app.get('/emulator/urcl')
def hello_world_urcl():
    return send_file('http/urcl.html')

@app.get('/emulator/dlang')
def hello_world_dlang():
    return send_file('http/dlang.html')


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


urcl_compiler = URCLCompiler()
dlang_compiler = DLangCompiler()

def compile_code(compiler: Compiler, body: bytes):
    program_bytes: bytes | list[Error] = compiler.compile(body)

    if isinstance(program_bytes, bytes):
        auth_integer = random.randint(1, 2147483647)
        database.setex(auth_integer.to_bytes(4, signed=True), 300, program_bytes)
        return f"ok {auth_integer}", 200
    else:
        return program_bytes, 400

@app.post('/emulator/urcl/compile')
@limiter.limit("5 per minute")
def compile_urcl():
    body: bytes = request.get_json()
    if not isinstance(body, str):
        return send_file('http/urcl.html', mimetype='text/html'), 400
    return compile_code(urcl_compiler, body)

@app.post('/emulator/dlang/compile')
@limiter.limit("5 per minute")
def compile_dlang():
    body: bytes = request.get_json()
    if not isinstance(body, str):
        return send_file('http/dlang.html', mimetype='text/html'), 400
    return compile_code(dlang_compiler, body)


if __name__ == '__main__':
    app.run()
