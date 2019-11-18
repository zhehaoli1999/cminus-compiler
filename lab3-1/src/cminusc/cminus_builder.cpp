#include "cminus_builder.hpp"
#include <llvm/IR/GlobalVariable.h>
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
    // It can be intepreted as a simple expression
    // Hence just directly return its valeu via ret
    ret = CONST(node.value);
 }

void CminusBuilder::visit(syntax_var_declaration &node) {
    // assert var can NOT be void type
    // TODO: how to deal with multi-layer array ? Is it allowed in cmiuns?
    Type* TYPE32 = Type::getInt32Ty(context);
    Type* TYPEArry = ArrayType::getInt32Ty(context);
    
    std::cout<<"enter var declarations"<<std::endl;
    // Note that in param declaration, it just declare a pointer
    // But in var declarasiton, it should declare a array with its len
    if(!scope.in_global()){
        if(node.num){
        // TODO: local array
            std::cout<<"declare an array"<<std::endl;
        } else{
            auto ldAlloc = builder.CreateAlloca(TYPE32);
            scope.push(node.id, ldAlloc);
        }
    } else {
        if(node.num){
            std::cout<<"enter global array declarations"<<std::endl;
            // TODO: global array
        } else {
            std::cout<<"enter global var declarations"<<std::endl;
            // declarations without initialization value and name
            // TODO: Global variable declaration failed
            auto gdAlloc = new GlobalVariable(TYPE32, false, GlobalVariable::LinkageTypes::ExternalLinkage);
            
            // gdAlloc->setAlignment(0);
            // gdAlloc->setInitializer(CONST(0));
            scope.push(node.id, gdAlloc);
        }
    }
    
}

void CminusBuilder::visit(syntax_fun_declaration &node) {
    //In the declaration, parameter identifiers should be pushed into the callee function scope. And function identifier should be caller function scope
    scope.enter();
    std::cout<<"enter func declarations"<<std::endl;
    Type* TYPE32 = Type::getInt32Ty(context);
    Type* TYPEV = Type::getVoidTy(context);
    Type* TYPEARRAY_32 = PointerType::getInt32PtrTy(context);
    Type * funType = node.type == TYPE_VOID ? TYPEV : TYPE32;

    // function parameters' type
    std::vector<Type *> args_type;

    // get params type
    // If params type is VOID, then assert there should not be other params and return args)type with null
    if(node.params.size() > 0){
        for(auto arg : node.params){
            if(arg->isarray){
                //TODO: Should it push pointer type or array type
                args_type.push_back(TYPEARRAY_32);
            } else {
                // it must be int
                args_type.push_back(TYPE32);
            }
        }
    }
    auto funcFF = Function::Create(FunctionType::get(funType, args_type, false),GlobalValue::LinkageTypes::ExternalLinkage,node.id, module.get());
    auto funBB = BasicBlock::Create(context, node.id, funcFF);
    builder.SetInsertPoint(funBB);
    
    std::cout<<"enter params declarations"<<std::endl;
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
    
    // assert node params size = args_value size
    if(node.params.size() > 0 && args_value.size() > 0){
        int i = 0;
        for (auto arg : node.params){
            auto pAlloc = scope.find(arg->id);
            if(pAlloc == nullptr){
                std::cout<<"[ERR] Function parameter"<<arg->id<<"is referred before declaration"<<std::endl;
            } else {
                std::cout<<"enter store value"<<std::endl;
                builder.CreateStore(args_value[i++], pAlloc);
            }
        }
    }
    
    node.compound_stmt->accept(*this);
    scope.exit();
    // for later unction-call
    scope.push(node.id, funcFF);
}

void CminusBuilder::visit(syntax_param &node) {
    // It is a declaration in the function
    // Hence, parameters cannot be in global scope
    Type* TYPE32 = Type::getInt32Ty(context);
    Type* TYPEV = Type::getVoidTy(context);
    //TODO: Should malloc or not ??? Should be array or ptr ???
    Type* TYPEARRAY_32 = PointerType::getInt32PtrTy(context);
    Value * pAlloc;
    if(node.type == TYPE_INT && !node.isarray){
        // assert that functions' parameters can NOT be global variables
        pAlloc = builder.CreateAlloca(TYPE32);
        scope.push(node.id, pAlloc);
    } else if (node.type == TYPE_INT && node.isarray){
        // array
        pAlloc = builder.CreateAlloca(TYPEARRAY_32);
        scope.push(node.id, pAlloc);
    } else{
            // void
            // std::cout<<"[ERR]Variable void"<<std::endl;
    }
    std::cout<<"exit param"<<std::endl;
}

void CminusBuilder::visit(syntax_compound_stmt &node) {
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

