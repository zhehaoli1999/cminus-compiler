int b;
int call(int a[], int b){
    int c;
    c = a[1];
    return c + b * 2;
}
int main(void){
    int a[10];
    a[0] = 1;
    a[2] = 5;
    return a[2];
}
