#include "types.h"
#include "user.h"
#include "fcntl.h"

int toint(char *str){

  int result = 0;

  while ((*str >= '0') && (*str <= '9')) {
      result = (result * 10) + ((*str) - '0');
      str++;
  }
  return result;
}

int main(int argc, char *argv[]){

    if (argc != 2){
        printf(1,"Error: Number of arguments are not correct\n");
        exit();
    }
    
    char result[1000];
    int result_index = 0;
    int input = toint(argv[1]);

    for (int i = 1; i <= input; i++){
        if (input % i == 0){
            char reverse[10];
            int num = i;
            int end = 0;
            for(int j = 0 ; num > 0 ; j++){
                reverse[j] = (char)(num%10 + 48);
                num/=10;
                end = j;
            }
            reverse[end+1] = 0;
            for (int j = strlen(reverse)-1; j >= 0 ; j--){
                result[result_index] = reverse[j];
                result_index++;
            }
            result[result_index] = ' ';
            result_index++;
        }   
    }

    if (result[result_index-1] == ' ') result[result_index-1] = '\n';
    result[result_index] = '\n';

    int file = open("factor_result.text",O_CREATE | O_RDWR);
    write(file,result,strlen(result));
    close(file);

    exit();
}