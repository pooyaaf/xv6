
    if(argc != 2){
        printf(2, "please enter valid a value\n");
        exit();
    }
   char* z[128];
   
   strcpy(z,argv[1]);
   
printf(1, "My first xv6 program learnt at GFG\n%s\n",z);
exit();