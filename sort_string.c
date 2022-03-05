#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"
	
//passing command line arguments

void sort(char str[]) {
    int i, j;
    char temp;
    int stringLength = strlen(str);
    for (i = 0; i < stringLength - 1; i++) {
        for (j = i + 1; j < stringLength; j++) {
                if (str[i] > str[j]) {
            temp = str[i];
            str[i] = str[j];
            str[j] = temp;
      }
    }
  }
}

int main(int argc, char *argv[])
{
    if (argc < 2)
        printf(1, "Enter string.\n");
    else {
        char str[128];
        strcpy(str, argv[1]);
        sort(str);
        
        int file = open("sort_string.txt", O_CREATE | O_RDWR);
        write(file, str ,strlen(str));
        write(file, "\n", 1);
        close(file);
    }
    exit();
}