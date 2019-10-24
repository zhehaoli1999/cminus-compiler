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
    
    // create branches
    // auto trueAA = BasicBlock::addUse();
    auto return1 = BasicBlock::Create(context, "return1", mainFun);
    auto return2 = BasicBlock::Create(context, "return2", mainFun);
    auto icmp = builder.CreateICmpSGT(CONST(2), CONST(1));
    auto br = builder.CreateCondBr(icmp, return1, return2);

    // if true return 1
    builder.SetInsertPoint(return1);
    builder.CreateRet(CONST(1));

    // if false retrun 0
    builder.SetInsertPoint(return2);
    builder.CreateRet(CONST(0));

    module->print(outs(), nullptr);
    return 0;
}