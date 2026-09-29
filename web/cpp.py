import array
from clang import cindex
import subprocess

import ir
from compiler import Compiler, Error, ParameterToken, OpCode
from llvmlite import binding

index = cindex.Index.create()

def print_cursor(cursor: cindex.Cursor):
    print(cursor.kind, cursor.spelling)
    for cursor in cursor.get_children():
        print_cursor(cursor)

class CPPCompiler(Compiler):
    def __init__(self):
        super().__init__(None)

    def compile(self, text: str, **kwargs) -> bytes | list[Error]:
        subprocess.run(
            [
                "clang++",
                "-O3",
                "-S",
                "-emit-llvm",
                "-o",
                "temp.ll",
                "-x", "c++",
                "-"
            ],
            input=text.encode(),
            check=True,
        )

        with open("temp.ll") as ll:
            mod = binding.parse_assembly(ll.read())
            mod.verify()

        return ir.compile(mod)
