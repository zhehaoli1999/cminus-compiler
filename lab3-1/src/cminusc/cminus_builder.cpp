#include "cminus_builder.hpp"
#include <llvm/IR/GlobalVariable.h>
#include <iostream>
using namespace llvm;
#define CONST(num) \
  ConstantInt::get(context, APInt(32, num))  //得到常数值的表示,方便后面多次用到

#define LOAD(type, ret) builder.CreateLoad(type, ret, "tmp");

// You can define global variables here
// to store state
Value * ret;
Type * retType;
bool isParam = 0;
// ConstantAggregateZero

//store function for creating basic block
Function * currentFunc;
struct array{
    std::string id;
    Value* a;
    int len;
};

std::vector<struct array> arrayList;

void CminusBuilder::visit(syntax_program &node) {
    // program → declaration-list 
    // just visit all declarations in declaration-list
    for(auto d : node.declarations){
        d->accept(*this);
    }
    builder.ClearInsertionPoint();

}

void CminusBuilder::visit(syntax_num &node) { 
    // It can be intepreted as a simple expression
    // Hence just directly return its valeu via ret
    ret = CONST(node.value);
 }

void CminusBuilder::visit(syntax_var_declaration &node) {
    // var-declaration →type-specifier ID ; ∣ type-specifier ID [ NUM ] ;
    // assert var can NOT be void type
    Type* TYPE32 = Type::getInt32Ty(context);
    Type* TYPEV = Type::getVoidTy(context);

    std::cout<<"enter var declarations"<<std::endl;
    // Note that in param declaration, it just declare a pointer
    // But in var declarasiton, it should declare a array with its len
    if(!scope.in_global()){
        if(node.num){
        // TODO: local array
            std::cout<<"declare an array"<<std::endl;

            // 创建ArrayType用于分配数组的空间
            ArrayType* arrayType = ArrayType::get(TYPE32, node.num->value);
            auto lArrayAlloc = builder.CreateAlloca(arrayType); 
            scope.push(node.id,lArrayAlloc);
        } 
        else{
            auto ldAlloc = builder.CreateAlloca(TYPE32);
            // AllocaInst* ldAlloc = new AllocaInst(TYPE32,node.num->value);
            scope.push(node.id, ldAlloc);
        }
    } else {
        if(node.num){
            std::cout<<"enter global array declarations"<<std::endl;
            // TODO: global array
            ArrayType* arrayType = ArrayType::get(TYPE32, node.num->value);
            auto gArrayAlloc = new GlobalVariable(arrayType, false, GlobalVariable::LinkageTypes::ExternalLinkage);
        }
        else {
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
    Type* TYPE32 = Type::getInt32Ty(context);
    Type* TYPEV = Type::getVoidTy(context);
    Type* TYPEARRAY_32 = PointerType::getInt32PtrTy(context);
    std::cout<<"enter func declarations"<<std::endl;
    Type * funType = node.type == TYPE_VOID ? TYPEV : TYPE32;

    // function parameters' type
    std::vector<Type *> args_type;
    // get params type
    // If params type is VOID, then assert there should not be other params and return args_type with null
    if(node.params.size() > 0){
        for(auto arg : node.params){
            if(arg->isarray){
                //TODO: Should it push pointer type or array type
                std::cout<<"Get Array!"<<std::endl;
                args_type.push_back(TYPEARRAY_32);
            } else if(arg->type == TYPE_INT) {
                // it must be int
                args_type.push_back(TYPE32);
            }
        }
    }
    auto funcFF = Function::Create(FunctionType::get(funType, args_type, false),GlobalValue::LinkageTypes::ExternalLinkage,node.id, module.get());
    // FIXME: check if there can be labels with same id in different scope
    currentFunc = funcFF;
    auto funBB = BasicBlock::Create(context, "entry", funcFF);
    builder.SetInsertPoint(funBB);
    

    std::cout<<"enter params declarations"<<std::endl;
    // Note that node.params are Syntrx Tree Node ptr, it can NOT be directly passed into function declaration list
    for(auto arg : node.params ) {
        arg.get()->accept(*this);
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
        std::cout<<"create array param"<<std::endl;
        pAlloc = builder.CreateAlloca(TYPEARRAY_32);
        scope.push(node.id, pAlloc);
    } else{
            // void
            // std::cout<<"[ERR]Variable void"<<std::endl;
    }
}

void CminusBuilder::visit(syntax_compound_stmt &node) {
    // accept local declarations
    // accept statementlist
    if(node.local_declarations.size() > 0){
        for(auto ld : node.local_declarations){
        // assert ld.type is INT
        ld->accept(*this);
        }
    }
    
    std::cout<<node.statement_list.size()<<" enter term"<<std::endl;
    for(auto s : node.statement_list){
        s->accept(*this);
    }  
}

void CminusBuilder::visit(syntax_expresion_stmt &node) {
    // expression-stmt→expression ; ∣ ;
    if(node.expression != nullptr){
        node.expression->accept(*this);
    }
}

void CminusBuilder::visit(syntax_selection_stmt &node) {
    // selection-stmt→ ​if ( expression ) statement∣ if ( expression ) statement else statement​
    std::cout<<"enter selection statement"<<std::endl;
    node.expression->accept(*this);
    Type* TYPE32 = Type::getInt32Ty(context);
    if(node.else_statement != nullptr){
        auto trueBranch = BasicBlock::Create(context, "trueBranch", currentFunc);
        auto falseBranch = BasicBlock::Create(context, "falseBranch", currentFunc);
        auto out = BasicBlock::Create(context, "outif");
        builder.CreateCondBr(ret,trueBranch,falseBranch);

        // tureBB
        builder.SetInsertPoint(trueBranch);
        node.if_statement->accept(*this);
        int insertedFlag = 0;
        if(builder.GetInsertBlock()->getTerminator() == nullptr){ // not returned inside the block
            insertedFlag = 1;
            out->insertInto(currentFunc);
            builder.CreateBr(out);
        }
        
        
        // falseBB
        builder.SetInsertPoint(falseBranch);
        node.else_statement->accept(*this);

        if(builder.GetInsertBlock()->getTerminator() == nullptr){ // not returned inside the block
            if (!insertedFlag){
                out->insertInto(currentFunc);
                insertedFlag = 1;
            }
            builder.CreateBr(out);
        }
        
        if(insertedFlag) builder.SetInsertPoint(out);
    }
    else{
        auto trueBranch = BasicBlock::Create(context, "trueBranch", currentFunc);
        auto out = BasicBlock::Create(context, "outif", currentFunc);
        builder.CreateCondBr(ret,trueBranch,out);
        // tureBB
        builder.SetInsertPoint(trueBranch);
        node.if_statement->accept(*this);

        if(builder.GetInsertBlock()->getTerminator() == nullptr) builder.CreateBr(out); // not returned inside the block
        
        builder.SetInsertPoint(out);
    }
}

void CminusBuilder::visit(syntax_iteration_stmt &node) {
    // iteration-stmt→while ( expression ) statement
    std::cout<<"enter selection statement"<<std::endl;
    auto loopJudge = BasicBlock::Create(context, "loopJudge", currentFunc);
    auto loopBody = BasicBlock::Create(context, "loopBody", currentFunc);
    auto out = BasicBlock::Create(context, "outloop", currentFunc);
    Type* TYPE1 = Type::getInt1Ty(context);
    builder.CreateBr(loopJudge);
    
    builder.SetInsertPoint(loopJudge);
    node.expression->accept(*this);
    builder.CreateCondBr(ret, loopBody, out);

    builder.SetInsertPoint(loopBody);
    node.statement->accept(*this);
    builder.CreateBr(loopJudge);

    builder.SetInsertPoint(out);
}

void CminusBuilder::visit(syntax_return_stmt &node) {
    std::cout<<"enter return"<<std::endl;
    if(node.expression == nullptr){
        builder.CreateRetVoid();
    } else {
        node.expression.get() -> accept(*this);
        Type* TYPE32 = Type::getInt32Ty(context);
        if(ret->getType() == TYPE32) builder.CreateRet(ret);
        else{
            auto retLoad = builder.CreateLoad(TYPE32, ret, "tmp");
            builder.CreateRet(retLoad);
        }
    }
}

void CminusBuilder::visit(syntax_var &node) {
    std::cout<<"enter var:"<<node.id<<std::endl;
    Type* TY32Ptr= PointerType::getInt32PtrTy(context);
    Type* TYPE32 = Type::getInt32Ty(context);
    auto var = scope.find(node.id);
    if(var){
        // 普通变量
        if(!node.expression){
            if(var->getType() != TYPE32 && var->getType() != TY32Ptr && isParam == 1){
                isParam = 0;
                auto i32Zero = CONST(0);
                Value* indices[2] = {i32Zero,i32Zero};
                std::cout<<"hi!!!!"<<std::endl;
                ret = builder.CreateInBoundsGEP(var, ArrayRef<Value *>(indices, 2));   
            // fcall = builder.CreateGEP(fAlloc,i32Zero); 
            }
            else if(isParam == 1){ ret = builder.CreateLoad(var); isParam = 0; }
            else ret = var;
        }
        // 数组变量
        else{
            node.expression.get()->accept(*this);
            auto num = ret;  // num can be a variable, not only integer
            if (num->getType() == TY32Ptr) num = builder.CreateLoad(num);
            num = builder.CreateIntCast(num, Type::getInt64Ty(context),true);
            Value* arrayPtr;
            auto varLoad = builder.CreateLoad(var);
            if(varLoad->getType() == TY32Ptr){
                arrayPtr = builder.CreateInBoundsGEP(varLoad,num); 
            }
            else{
                auto i32Zero = CONST(0);
                Value* indices[2] = {i32Zero,num};
                arrayPtr = builder.CreateInBoundsGEP(var, ArrayRef<Value *>(indices, 2));  
            }              
            // auto arrayPtr = builder.CreateInBoundsGEP(var,num);      

            ret = arrayPtr;
            // TODO: array overflow
        } 
    }
    else{
        std::cout<<"[ERR] undefined variable: "<<node.id<<std::endl;
    }
    std::cout<<"out var"<<node.id<<std::endl;
}

void CminusBuilder::visit(syntax_assign_expression &node) {
    // var = expression
    std::cout<<"enter assign-expression"<<std::endl;
    node.var.get()->accept(*this);
    Value* var = ret;
    node.expression.get()->accept(*this);
    Type* TYPE1 = Type::getInt1Ty(context);

    // 如果ret是通过关系运算得到的，那么其类型为int1，需要转换为int32
    if (ret->getType() == TYPE1){
        ret = builder.CreateIntCast(ret, Type::getInt32Ty(context), true);
    }

    // the value of expression is stored in ret
    builder.CreateStore(ret,var);
}

void CminusBuilder::visit(syntax_simple_expression &node) {
    // simple-expression → additive-expression relop additive- expression | additive-expression

    std::cout<<"enter simple-expression"<<std::endl;
    node.additive_expression_l.get()->accept(*this);

    // 按照 simple-expression → additive-expression relop additive- expression
    if(node.additive_expression_r != nullptr){
        Type* TYPE32 = Type::getInt32Ty(context);
        Type* TY32Ptr= PointerType::getInt32PtrTy(context);
        Value* lValue;
        if(ret->getType() == TY32Ptr) lValue = builder.CreateLoad(TYPE32, ret);
        else lValue = ret;

        node.additive_expression_r.get()->accept(*this);
        auto rValue = ret;

        Value* icmp ;   
        switch (node.op)
        {
            case OP_LE:
                icmp = builder.CreateICmpSLE(lValue, rValue);      
                break;
            case OP_LT:
                icmp = builder.CreateICmpSLT(lValue, rValue);        
                break;
            case OP_GT:
                icmp = builder.CreateICmpSGT(lValue, rValue);        
                break;
            case OP_GE:
                icmp = builder.CreateICmpSGE(lValue, rValue);  
                break;
            case OP_EQ:
                icmp = builder.CreateICmpEQ(lValue, rValue);  
                break;
            case OP_NEQ:
                icmp = builder.CreateICmpNE(lValue, rValue); 
                break;
            default:
                break;
        }
        // 然后修改全局变量ret的值
        ret = icmp;
    }
    
}

void CminusBuilder::visit(syntax_additive_expression &node) {
    // additive-expression → additive-expression addop term | term 
    
    // 按照 additive-expression → term 
    if(node.additive_expression == nullptr){
        std::cout<<"enter additive-expression -> term"<<std::endl;
        // It seems that it doesn't matter whether use shared-ptr.get() or not to refer to its member function
        node.term.get()->accept(*this);
    } 

    // 按照 additive-expression → additive-expression addop term 
    else {
        node.additive_expression.get()->accept(*this);
        Type* TYPE32 = Type::getInt32Ty(context);
        Type* TY32Ptr= PointerType::getInt32PtrTy(context);
        Value* lValue;
        if(ret->getType() == TY32Ptr){
            lValue = builder.CreateLoad(TYPE32, ret);
        }
        else lValue = ret;

        node.term.get()->accept(*this);
        auto rValue = ret;

        Value* iAdd;
        if (node.op == OP_PLUS){
            //  builder.CreateNSWAdd 返回的type是TYPE32, 不是ptr to TYPE32
            iAdd = builder.CreateNSWAdd(lValue,rValue);
        }
        else if(node.op == OP_MINUS){
            iAdd = builder.CreateNSWSub(lValue,rValue);
        }
        
        ret = iAdd;
    }
}

void CminusBuilder::visit(syntax_term &node) {
    // term → term mulop factor | factor
    // 按照 term -> factor
    if(node.term == nullptr){
        // std::cout<<node.factor<<std::endl;
        std::cout<<"enter factor"<<std::endl;
        if(node.factor != nullptr) 
            node.factor->accept(*this);
    }

    // 按照 term -> term mulop factor
    else {
        Type* TYPE32 = Type::getInt32Ty(context);
        Type* TY32Ptr= PointerType::getInt32PtrTy(context);

        node.term.get()-> accept(*this);
        Value* lValue;
        if(ret->getType() == TY32Ptr) lValue = builder.CreateLoad(TYPE32, ret, "tmp");
        else lValue = ret;
        node.factor.get()->accept(*this);
        auto rValue = ret;
        Value* result;

        // mulop is declared in syntax_tree.hpp
        if(node.op == OP_MUL){
            result = builder.CreateNSWMul(lValue, rValue);
        }
        else if(node.op == OP_DIV){
            // use UDIV rather than SDIV for cminus：cminus只有int
            result = builder.CreateUDiv(lValue, rValue);
        }
        ret = result;
    }
}

void CminusBuilder::visit(syntax_call &node) {
    std::cout<<"enter call"<<std::endl;
    auto fAlloc = scope.find(node.id);
    std::cout<<node.id<<std::endl;
    if(fAlloc == nullptr){
        std::cout<<"[ERR]Function"<<node.id<<"is referred before declaration"<<std::endl;
    } else {
        std::vector<Value *> funargs;
        for(auto expr : node.args){
            isParam = 1;
            expr->accept(*this);
            funargs.push_back(ret); 
       }
        Type* TYPE32 = Type::getInt32Ty(context);
        Type* TY32Ptr= PointerType::getInt32PtrTy(context);
        ret = builder.CreateCall(fAlloc, funargs);
    }
}

