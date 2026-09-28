import array

from llvmlite import binding as llvm, ir

from compiler import Error, OpCode


def compile(mod: llvm.ModuleRef):
    errors: dict[int, Error] = {}
    compiled: list[int] = []
    ro_mem: list[int] = []

    llvm_ir = str(mod)
    #ir_mod = .from_assembly(llvm_ir)
    print(str(mod))

    OpCode.CAL.add(compiled, None, ('number', 0))
    compiled.append(OpCode.HLT.id)

    try:
        program_bytes: bytes = array.array('I', compiled).tobytes()
    except OverflowError:
        errors[0] = Error(0, f"Program using more than 32 bits for some words", type="error")
        return list(errors.values())
    return program_bytes
