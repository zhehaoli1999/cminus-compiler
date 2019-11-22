int call(int a[], int b){
    return a[0];
}

int main(void){
   int a[10];
   int b;
   b = 1;
   a[0] = 10;
   return call(a,b);
}