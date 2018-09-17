#include<stdio.h>

int first = 0;
int second = 1;
int fibNum = 0;
int savedShit[100];

// max value utpo 100.
int fib(int n){
	
	if(n == 0){
		return first;
	} else if( n == 1){
		return second;
	} else {
		if(savedShit[n] != NULL){
			return savedShit[n];
		} else {
			savedShit[n] = fib(n-1) + fib(n-2);
			//printf("savedshit[n] is: %d", savedShit[n]);
		}
	}
	return savedShit[n];
}

int main(){
	int f = 0, n = 0;
	
	printf("Please enter the fibonacci number: \n");
	scanf("%d", &n);
	
	f = fib(n);
	
	printf("The fibonacci number is: %d\n", f);

	return 0;
}