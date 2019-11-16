#include "cminus_builder.hpp"
#include <iostream>

using namespace llvm;
#define CONST(num) \
  ConstantInt::get(context, APInt(32, num))  //得到常数值的表示,方便后面多次用到

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

void CminusBuilder::visit(syntax_num &node) { 
    ret = CONST(node.value);
 }

void CminusBuilder::visit(syntax_var_declaration &node) {
    // assert var can NOT be void type
    Type* TYPE32 = Type::getInt32Ty(context);
    auto ldAlloc = builder.CreateAlloca(TYPE32);
     scope.push(node.id, ldAlloc);
}

// TODO: There are two productions involoved in this 
void CminusBuilder::visit(syntax_fun_declaration &node) {
    //In the declaration, parameter identifiers should be pushed into the callee function scope. And function identifier should be caller function scope
    scope.enter();

    Type* TYPE32 = Type::getInt32Ty(context);
    Type* TYPEV = Type::getVoidTy(context);
    Type* TYPEARRAY_32 = Type::getInt32PtrTy(context);
    Type * funType = node.type == TYPE_VOID ? TYPEV : TYPE32;

    // function parameters' type
    std::vector<Type *> args_type(node.params.size(), TYPE32);
    auto funcFF = Function::Create(FunctionType::get(funType, args_type, false),GlobalValue::LinkageTypes::ExternalLinkage,node.id, module.get());
    auto funBB = BasicBlock::Create(context, "entry", funcFF);
    builder.SetInsertPoint(funBB);
    //TODO; whether the variables in class have been initialized
    // Note that node.params are Syntrx Tree Node ptr, it can NOT be directly passed into function declaration list
    for(auto arg : node.params ) {
        arg->accept(*this);
    }
    // Note that it should be module.get() instead of module
    
    // store parameters' value
    std::vector<Value *> args_value;
    
    for (auto arg = funcFF->arg_begin(); arg != funcFF->arg_end(); arg++){
        args_value.push_back(arg);
    }
    std::cout<<"fucntion parameters: "<<args_value.size()<<std::endl;
    
    if(node.params.size() > 0 && args_value.size() > 0){
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
    std::cout<<"Scope in global? "<< scope.in_global()<<std::endl;
    scope.push(node.id, funcFF);
}

void CminusBuilder::visit(syntax_param &node) {
    // It is a declaration in the function
    // Hence, it should add parameters into scope
    Type* TYPE32 = Type::getInt32Ty(context);
    Type* TYPEV = Type::getVoidTy(context);
    Type* TYPEARRAY_32 = Type::getInt32PtrTy(context);
    Value * pAlloc;
    if(node.type == TYPE_INT && !node.isarray){
        if(scope.in_global()){
            //TODO: glocal value
            // pAlloc = new GlobalVariable(module.get(), TYPE32, false, GlobalValue::CommonLinkage, node.id);
        } else {
            pAlloc = builder.CreateAlloca(TYPE32);
        }
        scope.push(node.id, pAlloc);
        
    } else if (node.type == TYPE_INT && node.isarray){
        auto pAlloc = builder.CreateAlloca(TYPEARRAY_32);
        scope.push(node.id, pAlloc);
    } else{
            // void
            std::cout<<"[ERR]Variable void"<<std::endl;
    }
    std::cout<<"exit param"<<std::endl;
}

void CminusBuilder::visit(syntax_compound_stmt &node) {
    // TODO: how to deal with global varibale decalarations
    // accept local declarations
    // accept statementlist
    for(auto ld : node.local_declarations){
        // assert ld.type is INT
        ld->accept(*this);
    }
    std::cout<<node.statement_list.size()<<" enter term"<<std::endl;
    for(auto s : node.statement_list){
        s->accept(*this);
    }

}

void CminusBuilder::visit(syntax_expresion_stmt &node) {
    node.expression->accept(*this);
}

void CminusBuilder::visit(syntax_selection_stmt &node) {}

void CminusBuilder::visit(syntax_iteration_stmt &node) {}

void CminusBuilder::visit(syntax_return_stmt &node) {
    std::cout<<"enter return"<<std::endl;
    if(node.expression == nullptr){
        builder.CreateRetVoid();
    } else {
        
        // TODO: for other expressions' type
    }
}

void CminusBuilder::visit(syntax_var &node) {
    
}

void CminusBuilder::visit(syntax_assign_expression &node) {}

void CminusBuilder::visit(syntax_simple_expression &node) {
    // simple-expression → additive-expression relop additive- expression | additive-expression
    node.additive_expression_l.get()->accept(*this);
    if(node.additive_expression_r == nullptr){
        auto v = ret;
    } else {
        auto lValue = ret;
        auto lType = retType;
        node.additive_expression_r->accept(*this);
        // TODO: 
    }
}

void CminusBuilder::visit(syntax_additive_expression &node) {
    // additive-expression → additive-expression addop term | term 
    
    if(node.additive_expression == nullptr){
        std::cout<<"enter add"<<std::endl;
        // It seems that it doesn't matter whether use shared-ptr.get() or not to refer to its member function
        node.term.get()->accept(*this);
    } else {
        //TODO:
    }
}

void CminusBuilder::visit(syntax_term &node) {
    // term → term mulop factor | factor
    
    if(node.term == nullptr){
        std::cout<<"enter term"<<std::endl;
        node.factor->accept(*this);
    } else {
        // TODO
    }
}

void CminusBuilder::visit(syntax_call &node) {
    std::cout<<"enter call"<<std::endl;
    auto fAlloc = scope.find(node.id);
    if(fAlloc == nullptr){
        std::cout<<"[ERR]Function"<<node.id<<"is referred before declaration"<<std::endl;
    } else {
        std::vector<Value *> funargs;
        for(auto expr : node.args){
            expr->accept(*this);
            funargs.push_back(ret);
        }
        builder.CreateCall(fAlloc, funargs);
    }
}


