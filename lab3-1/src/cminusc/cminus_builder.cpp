#include "cminus_builder.hpp"
#include <iostream>

using namespace llvm;
// You can define global variables here
// to store state
Value * ret;
Type * retType;

void CminusBuilder::visit(syntax_program &node) {
    // program → declaration-list 
    // just visit all declarations in declaration-list
    
    for(auto d : node.declarations){
        d->accept(*this);
    }
}

void CminusBuilder::visit(syntax_num &node) {  }

void CminusBuilder::visit(syntax_var_declaration &node) {
    // assert var can NOT be void type
    Type* TYPE32 = Type::getInt32Ty(context);
    auto ldAlloc = builder.CreateAlloca(TYPE32);
     scope.push(node.id, ldAlloc);
}

// TODO: There are two productions involoved in this 
void CminusBuilder::visit(syntax_fun_declaration &node) {
    //In the declaration, parameters identifier should be pushed into the callee function scope. And function identifier should be caller function scope
    scope.enter();
    // if(scope.find(node.id) == nullptr){
    //     // std::cout<<"[ERR] Function"<<node.id<<"is referred before declaration"<<std::endl;
    //     exit(1);
    // }
    std::cout<<"enter func declaration"<<std::endl;
    Type* TYPE32 = Type::getInt32Ty(context);
    Type* TYPEV = Type::getVoidTy(context);
    Type* TYPEARRAY_32 = Type::getInt32PtrTy(context);
    Type * funType = node.type == TYPE_VOID ? TYPEV : TYPE32;

    // function parameters' type
    std::vector<Type *> args;
    //TODO; whether the variables in class have been initialized
    // Note that node.params are Syntrx Tree Node ptr, it can NOT be directly passed into function declaration list
    for(auto arg : node.params ) {
        arg->accept(*this);
        auto pValue = scope.find(arg->id);
        if(pValue == nullptr){
            // ERR
        } else {
            args.push_back(pValue->getType());
        }
    }
    // Note that it should be module.get() instead of module
    auto funcFF = Function::Create(FunctionType::get(funType, args, false),GlobalValue::LinkageTypes::ExternalLinkage,node.id, module.get());
    auto funBB = BasicBlock::Create(context, "entry", funcFF);
    builder.SetInsertPoint(funBB);

    // store parameters' value
    std::vector<Value *> args_value;
    for (auto arg = funcFF->arg_begin(); arg != funcFF->arg_end(); arg++){
        args_value.push_back(arg);
    }
    if(node.params.size() > 0){
        int i = 0;
        for (auto arg : node.params){
            auto pAlloc = scope.find(arg->id);
            if(pAlloc == nullptr){
                //ERR
            } else {
                builder.CreateStore(args_value[i++], pAlloc);
            }
        }
    }

    node.compound_stmt->accept(*this);
    scope.exit();
    // for later use
    scope.push(node.id, funcFF);
}

void CminusBuilder::visit(syntax_param &node) {
    // It is a declaration in the function
    // Hence, it should add parameters into scope
    Type* TYPE32 = Type::getInt32Ty(context);
    Type* TYPEV = Type::getVoidTy(context);
    Type* TYPEARRAY_32 = Type::getInt32PtrTy(context);
    if(node.type == TYPE_INT && !node.isarray){
            auto pAlloc = builder.CreateAlloca(TYPE32);
            scope.push(node.id, pAlloc);
        } else if (node.type == TYPE_INT && node.isarray){
            auto pAlloc = builder.CreateAlloca(TYPEARRAY_32);
            scope.push(node.id, pAlloc);
        } else{
            // void

        }
}

void CminusBuilder::visit(syntax_compound_stmt &node) {
    // TODO: how to deal with global varibale decalarations
    // accept local declarations
    // accept statementlist
    for(auto ld : node.local_declarations){
        // assert ld.type is INT
        // accpet var declaration
        ld->accept(*this);
    }

    for(auto s : node.statement_list){
        s->accept(*this);
    }

}

void CminusBuilder::visit(syntax_expresion_stmt &node) {}

void CminusBuilder::visit(syntax_selection_stmt &node) {}

void CminusBuilder::visit(syntax_iteration_stmt &node) {}

void CminusBuilder::visit(syntax_return_stmt &node) {
    if(node.expression == nullptr){
        builder.CreateRetVoid();
    } else {
        // TODO: for other expressions' type
    }
}

void CminusBuilder::visit(syntax_var &node) {}

void CminusBuilder::visit(syntax_assign_expression &node) {}

void CminusBuilder::visit(syntax_simple_expression &node) {}

void CminusBuilder::visit(syntax_additive_expression &node) {}

void CminusBuilder::visit(syntax_term &node) {}

void CminusBuilder::visit(syntax_call &node) {}


