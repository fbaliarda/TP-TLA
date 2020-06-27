#include <stdlib.h>
#include <stdio.h>

#define BUFFER_SIZE 512

static char ** programMemory;
static int currentMemorySize = 0;

char* readStdInput() {
  char *buffer = malloc(BUFFER_SIZE-1);
  programMemory = realloc(programMemory, ++currentMemorySize);
  fgets(buffer, BUFFER_SIZE-1, stdin);
  return buffer;
}

void freeProgramMemory(){
  for(int i = 0; i < currentMemorySize; i++){
    free(*(programMemory + i));
  }
  free(programMemory);
}