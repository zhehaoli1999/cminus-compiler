
int call(int a[], int b){
    return a[111];
}


int main(void){
   int a[10];       /* int a = 10; 是错的，不符合C-语法*/
   a[0] = 10;
   a[2] = 0;
   a[2] = a[2] < 2 ;
   return call(a, 10);
//    return a[2];
}