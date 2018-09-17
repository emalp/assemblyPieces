// fib.c
#include<stdio.h>

int first = 0;
int second = 1;

int fib(int n){
	
	int fibNum = 0;
	
	if(n == 0){
		fibNum =  first;
	} else if(n == 1){
		fibNum = second;
	} else {
		fibNum = fib(n-1) + fib(n-2);
	}
	
	return fibNum;
}

int main(){
	int n = 0, f = 0;
	
	while( n < 2 || n > 45){
		printf("Please enter the number n:\n");
		scanf("%d", &n);
	}
	f = fib(n);
	printf("The fibonacci number is: %d\n", f);
	return 0;
}

