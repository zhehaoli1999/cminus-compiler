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
bool isAssign = 0;
// ConstantAggregateZero

//store function for creating basic block
int number;

// std::vector<struct array> arrayList;
Function * currentFunc;
BasicBlock* expHandler;
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

    // std::cout<<"enter var declarations"<<std::endl;
    // Note that in param declaration, it just declare a pointer
    // But in var declarasiton, it should declare a array with its len
    if(!scope.in_global()){
        if(node.num){
        // TODO: local array
            // std::cout<<"declare an array"<<std::endl;

            // 创建ArrayType用于分配数组的空间
            ArrayType* arrayType = ArrayType::get(TYPE32, node.num->value);
            auto lArrayAlloc = builder.CreateAlloca(arrayType); 
            scope.push(node.id,lArrayAlloc);
            // 存储数组长度：
            scope.push(node.id+"_len",CONST(node.num->value));
        } 
        else{
            auto ldAlloc = builder.CreateAlloca(TYPE32);
            // AllocaInst* ldAlloc = new AllocaInst(TYPE32,node.num->value);
            scope.push(node.id, ldAlloc);
        }
    } else {
        if(node.num){
            // std::cout<<"enter global array declarations"<<std::endl;
            // TODO: global array
            ArrayType* arrayType = ArrayType::get(TYPE32, node.num->value);
            ConstantAggregateZero* zeroArray = ConstantAggregateZero::get(arrayType);
            auto gArrayAlloc = new GlobalVariable(*module, arrayType, false, GlobalVariable::LinkageTypes::CommonLinkage, zeroArray);
            
            // gArrayAlloc->setInitializer(zeroNum);
            scope.push(node.id, gArrayAlloc);
            // scope.push(node.id+"_len", CONST(node.num->value));
        }
        else {
            // std::cout<<"enter global var declarations"<<std::endl;
            // declarations without initialization value and name
            // TODO: Global variable declaration failed
            ConstantAggregateZero* zeroNum = ConstantAggregateZero::get(TYPE32);
            auto gdAlloc = new GlobalVariable(*module,TYPE32, false, GlobalVariable::LinkageTypes::ExternalLinkage, zeroNum);
            
            
            // gdAlloc->setAlignment(0);
            //gdAlloc->setInitializer(zeroArray);
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
    // std::cout<<"enter func declarations"<<std::endl;
    Type * funType = node.type == TYPE_VOID ? TYPEV : TYPE32;

    // function parameters' type
    std::vector<Type *> args_type;
    // get params type
    // If params type is VOID, then assert there should not be other params and return args_type with null
    if(node.params.size() > 0){
        for(auto arg : node.params){
            if(arg->isarray){
                //TODO: Should it push pointer type or array type
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
    expHandler = nullptr;
    scope.exit();
    // for later unction-call
    scope.push(node.id, funcFF);
    scope.enter();
    auto funBB = BasicBlock::Create(context, "entry", funcFF);
    builder.SetInsertPoint(funBB);
    

    // std::cout<<"enter params declarations"<<std::endl;
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
    // std::cout<<"fucntion parameters: "<<args_value.size()<<std::endl;
    
    // assert node params size = args_value size
    if(node.params.size() > 0 && args_value.size() > 0){
        int i = 0;
        for (auto arg : node.params){
            auto pAlloc = scope.find(arg->id);
            if(pAlloc == nullptr){
                std::cout<<"[ERR] Function parameter "<<arg->id<<" is referred before declaration"<<std::endl;
                exit(0);
            } else {
                builder.CreateStore(args_value[i++], pAlloc);
            }
        }
    }
    
    node.compound_stmt->accept(*this);
    if(expHandler){
        builder.SetInsertPoint(expHandler);
        auto neg_idx_except_fun = scope.find("neg_idx_except");
        builder.CreateCall(neg_idx_except_fun);
        if(funType == TYPEV) builder.CreateRetVoid();
        else if(funType == TYPE32) builder.CreateRet(CONST(0));
    }
    std::cout<<"exit func declaration"<<std::endl;
    scope.exit();
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
    
    // std::cout<<node.statement_list.size()<<" enter term"<<std::endl;
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
    // std::cout<<"enter selection statement"<<std::endl;
    node.expression->accept(*this);
    // ret = builder.CreateCast()

    Type* TYPE32 = Type::getInt32Ty(context);
    if(ret->getType() == TYPE32){
        ret = builder.CreateICmpNE(ret, ConstantInt::get(TYPE32, 0, true));
    }
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
    // std::cout<<"enter selection statement"<<std::endl;
    auto loopJudge = BasicBlock::Create(context, "loopJudge", currentFunc);
    auto loopBody = BasicBlock::Create(context, "loopBody", currentFunc);
    auto out = BasicBlock::Create(context, "outloop", currentFunc);
    Type* TYPE32 = Type::getInt32Ty(context);
    Type* TYPE1 = Type::getInt1Ty(context);
    builder.CreateBr(loopJudge);
    
    builder.SetInsertPoint(loopJudge);
    node.expression->accept(*this);
    if(ret->getType() == TYPE32){
        ret = builder.CreateICmpNE(ret, ConstantInt::get(TYPE32, 0, true));
    }
    builder.CreateCondBr(ret, loopBody, out);

    builder.SetInsertPoint(loopBody);
    node.statement->accept(*this);
    builder.CreateBr(loopJudge);

    builder.SetInsertPoint(out);
}

void CminusBuilder::visit(syntax_return_stmt &node) {
    // std::cout<<"enter return"<<std::endl;
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

    // std::cout<<"enter var:"<<node.id<<std::endl;
    Type* TY32Ptr= PointerType::getInt32PtrTy(context);
    Type* TYPE1 = Type::getInt1Ty(context);
    Type* TYPE32 = Type::getInt32Ty(context);
    auto var = scope.find(node.id);
   
    if(var){
        // 没有expression说明： 1.普通变量 或者 2. call() 语句中的参数（数组指针或者i32）
        if(!node.expression){
            // 情况1: 如果是call() 语句中的数组指针，要转为 int*
            if(var->getType() != TYPE32 && var->getType() != TY32Ptr && isParam == 1){
                // isParam = 0;
                auto i32Zero = CONST(0);
                Value* indices[2] = {i32Zero,i32Zero};
                ret = builder.CreateInBoundsGEP(var, ArrayRef<Value *>(indices, 2));   
            }
            // 情况2: 如果是函数传参i32*，就先load
            else if(isParam == 1 && var->getType() == TY32Ptr){
                // 函数参数中出现赋值语句的情况，不要load
                if(!isAssign) ret = builder.CreateLoad(var);
                else ret = var; 
                // isParam = 0; 
                }
            // 情况3: 普通变量的情况
            else ret = var;
        }
        // 有expression，说明是数组变量
        else{
            node.expression.get()->accept(*this);
            auto num = ret;  // num can be a variable, not only integer
            
            int64_t numValue, bound;
            if (num->getType() == TY32Ptr) num = builder.CreateLoad(num);
            
            // 判断数组指数为负
            /***/
            if(!expHandler) expHandler = BasicBlock::Create(context," expHandler", currentFunc);
            auto normalCond = BasicBlock::Create(context, "normalCond", currentFunc);
            auto exp = builder.CreateICmpSLT(num, CONST(0));
            builder.CreateCondBr(exp, expHandler, normalCond);
            builder.SetInsertPoint(normalCond);
            /***/
            // // 如果在scope中有 node.id+"_len"
            // if (scope.find(node.id+"_len")){ 
            // // 从 ConstantInt 类型中获取 origin value,判断越界
            //     if (ConstantInt* CI = dyn_cast<ConstantInt>(num)) {
            //         if (CI->getBitWidth() <= 32) {
            //             numValue = CI->getSExtValue();
            //             bound = dyn_cast<ConstantInt>(scope.find(node.id+"_len"))->getSExtValue();
            //         }
            //         if (numValue < 0 || numValue >= bound ) // neg_idx_except();
            //         {
            //             std::cout<<"[ERR] index exception."<<std::endl;
            //             exit(0);
            //         }
            //     }
            // }
            // // 看clang的，将i32转为i64
            num = builder.CreateIntCast(num, Type::getInt64Ty(context),true);
            
            Value* arrayPtr;
            auto varLoad = builder.CreateLoad(var);

            //在子函数中使用传入的数组指针参数的情况（note:在子函数中必须先load一次传入的数组指针参数，再getGEP）
            if(varLoad->getType() == TY32Ptr){
                // arrayPtr 类型是 i32*
                arrayPtr = builder.CreateInBoundsGEP(varLoad,num); 
            }
            // 不是在子函数中使用传入的数组指针参数的情况
            // 在main中 如 a[1] = 1, varLoad 得到的类型是[ ? x ? ],而不是i32*
            else{
                auto i32Zero = CONST(0);
                Value* indices[2] = {i32Zero,num};
                // arrayPtr 类型是 i32*
                arrayPtr = builder.CreateInBoundsGEP(var, ArrayRef<Value *>(indices, 2));  
            } 

            ret = arrayPtr;
            // 解决传参数 call(a[0]) 的问题: 需要传入int，那就再load一次
            if (isParam == 1){ 
                ret = builder.CreateLoad(ret);
            }
        } 

    }
    else{
        std::cout<<"[ERR] undefined variable: "<<node.id<<std::endl;
        exit(0);
    }

    if (ret->getType() == TYPE1){
        ret = builder.CreateIntCast(ret, Type::getInt32Ty(context), false);
    }

    // std::cout<<"out var"<<node.id<<std::endl;
    // isParam = 0;
}

void CminusBuilder::visit(syntax_assign_expression &node) {
    // var = expression
    // std::cout<<"enter assign-expression"<<std::endl;
    isAssign = 1;
    node.var.get()->accept(*this);
    isAssign = 0;
    Value* var = ret;

    node.expression.get()->accept(*this);
    
    Type* TY32Ptr= PointerType::getInt32PtrTy(context);

    if(ret->getType() == TY32Ptr) ret = builder.CreateLoad(ret);
    Type* TYPE1 = Type::getInt1Ty(context);
    // 如果ret是通过关系运算得到的，那么其类型为int1，需要转换为int32
    if (ret->getType() == TYPE1){
        ret = builder.CreateIntCast(ret, Type::getInt32Ty(context), false);
    }

    // the value of expression is stored in ret
    builder.CreateStore(ret,var);
}

void CminusBuilder::visit(syntax_simple_expression &node) {
    // simple-expression → additive-expression relop additive- expression | additive-expression

    // std::cout<<"enter simple-expression"<<std::endl;
    node.additive_expression_l.get()->accept(*this);

    // 按照 simple-expression → additive-expression relop additive- expression
    if(node.additive_expression_r != nullptr){
        Type* TYPE32 = Type::getInt32Ty(context);
        Type* TY32Ptr= PointerType::getInt32PtrTy(context);
        Value* lValue;
        Value* rValue;
        
        if(ret->getType() == TY32Ptr) lValue = builder.CreateLoad(TYPE32, ret);
        else lValue = ret;
        // lValue = builder.CreateLoad(TYPE32, ret);
        // lValue = ret;
        node.additive_expression_r.get()->accept(*this);
       
        if(ret->getType() == TY32Ptr) rValue = builder.CreateLoad(TYPE32, ret);
        else rValue = ret;
        // auto rValue = ret;

        Value* icmp ;   
        // std::cout<<"enter get type"<<std::endl;
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
        // std::cout<<"enter additive-expression -> term"<<std::endl;
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
        if(rValue->getType() == TY32Ptr) rValue = builder.CreateLoad(TYPE32, rValue);
        
        Type* TYPE1 = Type::getInt1Ty(context);
        if (lValue->getType() == TYPE1){
            lValue = builder.CreateIntCast(lValue, Type::getInt32Ty(context), false);
        }
        if (rValue->getType() == TYPE1){
            rValue = builder.CreateIntCast(rValue, Type::getInt32Ty(context), false);
        }
        
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
        // std::cout<<"enter factor"<<std::endl;
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
        Value* rValue;
        if(ret->getType() == TY32Ptr) rValue = builder.CreateLoad(TYPE32, ret, "tmp");
        else rValue = ret;
        Value* result;
        Type* TYPE1 = Type::getInt1Ty(context);
        if (lValue->getType() == TYPE1){
            lValue = builder.CreateIntCast(lValue, Type::getInt32Ty(context), false);
        }
        if (rValue->getType() == TYPE1){
            rValue = builder.CreateIntCast(rValue, Type::getInt32Ty(context), false);
        }


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

// void CminusBuilder::visit(syntax_call &node) {
//     std::cout<<"enter call"<<std::endl;
//     auto fAlloc = scope.find(node.id);
//     std::cout<<node.id<<std::endl;
//     if(fAlloc == nullptr){
//         std::cout<<"[ERR]Function"<<node.id<<"is referred before declaration"<<std::endl;
//     } else {
//         std::vector<Value *> funargs;
//         for(auto expr : node.args){
//             expr->accept(*this);
//             funargs.push_back(ret); 
//        }
//         Type* TYPE32 = Type::getInt32Ty(context);
//         Type* TY32Ptr= PointerType::getInt32PtrTy(context);
//         // auto fload = builder.CreateLoad(fAlloc);
//         if(fAlloc->getType() != TYPE32 && fAlloc->getType() != TY32Ptr){
//             auto i32Zero = CONST(0);
//             Value* indices[2] = {i32Zero,i32Zero};
//             std::cout<<"hi!!!!"<<std::endl;
//             auto fcall = builder.CreateInBoundsGEP(fAlloc, ArrayRef<Value *>(indices, 2));   // ! 这里会报段错误
//             // fcall = builder.CreateGEP(fAlloc,i32Zero); 
//             builder.CreateCall(fAlloc, funargs);
//         }
//         else{
//             builder.CreateCall(fAlloc, funargs);
//         } 
//     }
// }

void CminusBuilder::visit(syntax_call &node) {
    // std::cout<<"enter call"<<std::endl;
    auto fAlloc = scope.find(node.id);
    Type* TYPE32 = Type::getInt32Ty(context);
    auto TYPEARRAY = ArrayType::getInt32Ty(context);
    if(fAlloc == nullptr){
        std::cout<<"[ERR]Function"<<node.id<<"is referred before declaration"<<std::endl;
        exit(0);
    } 
    else {
        Type* TYPE1 = Type::getInt1Ty(context);
        std::vector<Value *> funargs;
        for(auto expr : node.args){
            isParam = 1;
            expr->accept(*this);
            // 如果ret是通过关系运算得到的，那么其类型为int1，需要转换为int32
            if (ret->getType() == TYPE1){
                ret = builder.CreateIntCast(ret, Type::getInt32Ty(context), false);
            }
            funargs.push_back(ret); 
       }
       isParam = 0;
        // std::cout<<"create call and return "<<std::endl;
        Type* TYPE32 = Type::getInt32Ty(context);
        Type* TY32Ptr= PointerType::getInt32PtrTy(context);
        ret = builder.CreateCall(fAlloc, funargs);
    }
}
