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

    // parameters in the function
    // 
    Type * para;
    std::vector<Type *> Ints(1, TYPE32);
    auto module = new Module("assign.c", context);
    auto mainFun = Function::Create(FunctionType::get(TYPE32, false), GlobalValue::LinkageTypes::ExternalLinkage, "main", module);
    auto mainBB = BasicBlock::Create(context, "entry", mainFun);
    auto calleeFun = Function::Create(FunctionType::get(TYPE32, Ints, false), GlobalValue::LinkageTypes::ExternalLinkage, "callee", module);

    auto calleeBB = BasicBlock::Create(context, "calleeEntry", calleeFun);
    builder.SetInsertPoint(calleeBB);

    
    auto arg = calleeFun->arg_begin();
    auto res = builder.CreateNSWMul(CONST(2), arg);
    builder.CreateRet(res);
    
    builder.SetInsertPoint(mainBB);
    auto retValue = builder.CreateAlloca(TYPE32);
    builder.CreateStore(retValue, CONST(10));
    auto retLoad = builder.CreateLoad(retValue);
    auto call = builder.CreateCall(calleeFun, {retLoad});

    builder.CreateRet(call);


    module->print(outs(), nullptr);
    return 0;
}