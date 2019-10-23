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

    auto aAlloc = builder.CreateAlloca(TYPE32);
    auto iAlloc = builder.CreateAlloca(TYPE32);
    builder.CreateStore(CONST(10), aAlloc);
    builder.CreateStore(CONST(0), iAlloc);

    // create branches
    auto loop = BasicBlock::Create(context, "loop", mainFun);
    auto body = BasicBlock::Create(context, "body", mainFun);
    auto exit = BasicBlock::Create(context, "exit", mainFun);
    auto br = builder.CreateBr(loop);

    // loop-start
    builder.SetInsertPoint(loop);
    auto iLoad = builder.CreateLoad(iAlloc);

    auto icmp = builder.CreateICmpSLT(iLoad, CONST(10));
    auto br2 = builder.CreateCondBr(icmp, body, exit);

    // loop-body
    builder.SetInsertPoint(body);
    auto aLoad = builder.CreateLoad(aAlloc);
    auto iAdd = builder.CreateNSWAdd(iLoad, CONST(1));
    auto aAdd = builder.CreateNSWAdd(aLoad, iAdd);
    auto br_loop = builder.CreateBr(loop);

    // exit
    auto iLoad_end = builder.CreateLoad(iAlloc);
    builder.CreateRet(iLoad_end);

    module->print(outs(), nullptr);
    return 0;
}