#include <llvm/IR/BasicBlock.h>
#include <llvm/IR/Constants.h>
#include <llvm/IR/DerivedTypes.h>
#include <llvm/IR/Function.h>
#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/Module.h>
#include <llvm/IR/Type.h>
#include <llvm/IR/Verifier.h>

#include <iostream>
#include <memory>

#ifdef DEBUG  // 用于调试信息,大家可以在编译过程中通过" -DDEBUG"来开启这一选项
#define DEBUG_OUTPUT std::cout << __LINE__ << std::endl;  // 输出行号的简单示例
#else
#define DEBUG_OUTPUT
#endif

using namespace llvm;  // 指明命名空间为llvm
#define CONST(num) \
  ConstantInt::get(context, APInt(32, num))  //得到常数值的表示,方便后面多次用到

int main() {
    LLVMContext context;
    IRBuilder<> builder(context);
    Type *TYPE32 = Type::getInt32Ty(context);
    auto module = new Module("assign.c", context);
    auto mainFun = Function::Create(FunctionType::get(TYPE32, false), GlobalValue::LinkageTypes::ExternalLinkage, "main", module);
    auto entry = BasicBlock::Create(context, "entry", mainFun);
    builder.SetInsertPoint(entry);
    auto aAlloca = builder.CreateAlloca(TYPE32);
    
    builder.CreateStore(CONST(1), aAlloca);
    auto aLoad = builder.CreateLoad(aAlloca);
    DEBUG_OUTPUT
    builder.CreateRet(aLoad);
    module->print(outs(), nullptr);
    return 0;
}