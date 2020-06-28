#include <stdlib.h>
#include <stdio.h>

#define BUFFER_SIZE 512

static char ** programMemory;
static int currentMemorySize = 0;

char* readStdInput() {
  char *buffer = malloc(BUFFER_SIZE-1);
  programMemory = realloc(programMemory, ++currentMemorySize * sizeof(char *));
  fgets(buffer, BUFFER_SIZE-1, stdin);
  programMemory[currentMemorySize - 1] = buffer;
  return buffer;
}

void freeProgramMemory(){
  for(int i = 0; i < currentMemorySize; i++){
    free(programMemory[i]);
  }
  if(programMemory != NULL){
    free(programMemory);
  }
}