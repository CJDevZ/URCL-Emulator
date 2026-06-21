import llvmlite.binding as llvm

class Compiler:
    def compile(self, text: str):
        llvm_module = llvm.parse_assembly(text)
        llvm_module.verify()
        print(llvm_module)
