/*
 *    Credits to: @ChuOkupai
 *    https://github.com/ChuOkupai/n-ary-tree
 */
#include <stdlib.h>
#include <stdio.h>
#include "tree.h"

Node * nodeNewLeaf(char * data, type type) {
  Node * n = (Node *)malloc(sizeof(Node));
  
  if (n == NULL){
    return n;
  }
  n->type = type;
  n->data = data;
  n->next = NULL;
  n->prev = NULL;
  n->parent = NULL;
  n->children = NULL;
  return n;
}

Node * nodeNew(char* data) {
  Node * n = nodeNewLeaf(data, _branch);
  return n;
}

Node * nodeInsertBefore(Node *parent, Node *sibling, Node *node)
{
  if (! (parent && node) || (sibling && sibling->parent == parent))
    return NULL;
  node->parent = parent;
  if (sibling)
  {
    if (sibling->prev)
    {
      node->prev = sibling->prev;
      node->prev->next = node;
    }
    else
      node->parent->children = node;
    node->next = sibling;
    sibling->prev = node;
  }
  else
  {
    if (parent->children)
    {
      sibling = parent->children;
      while (sibling->next)
        sibling = sibling->next;
      node->prev = sibling;
      sibling->next = node;
    }
    else
      node->parent->children = node;
  }
  return node;
}

Node * nodeRoot(Node *node)
{
  if (! node)
    return NULL;
  if (node->parent)
    return nodeRoot(node->parent);
  return node;
}

Node * nodeFind(Node *node, void *data, int (*compare)(void *a, void *b))
{
  if (! node)
    return node;
  if (! compare(data, node->data))
    return node;
  if (node->next)
    return nodeFind(node->next, data, compare);
  if (node->children)
    return nodeFind(node->children, data, compare);
  return NULL;
}

Node * nodeNthChild(Node *node, int n)
{
  if (! node)
    return NULL;
  node = node->children;
  while (node && (n-- > 0))
    node = node->next;
  return node;
}

int nodeTotal(Node  *root)
{
  if (! root)
    return 0;
  int t;
  
  t = 1;
  if (root->children)
    t += nodeTotal(root->children);
  if (root->next)
    t += nodeTotal(root->next);
  return t;
}

void nodeUnlink(Node *node)
{
  if (! node)
    return;
  if (node->prev)
    node->prev->next = node->next;
  else if (node->parent)
    node->parent->children = node->next;
  if (node->next)
  {
    node->next->prev = node->prev;
    node->next = NULL;
  }
  node->prev = NULL;
  node->parent = NULL;
}

void nodeFree(Node *node)
{
  if (! node)
    return;
  if (node->children)
    nodeFree(node->children);
  if (node->next)
    nodeFree(node->next);
  free(node);
}

void nodeDestroy(Node *root)
{
  if (! root)
    return;
  if (! nodeIsRoot(root))
    nodeUnlink(root);
  nodeFree(root);
}

int numberOfChildren(Node * node){
  int ret = 0;
  Node * aux = node->children;
  while(aux != NULL){
    aux = aux->next;
    ret++;
  }
  return ret;
}


void printTree(Node * node){

  if(node == NULL){
    printf("%s\n", "ERROR");
    return;
  }

  if(node->type != _branch){

    if(node->data == NULL){
      if(node->type >= 0 && node->type < MAX_DATA_TYPES) {
      	node->data = types[node->type];
      }
      else {
      	printf("%s\n", "ERROR");
      return;
      }
    }

    printf("%s ", node->data );
    
    return;

  }

  if(node->type == _branch){

    if(node->children == NULL){
      printf("%s\n", "ERROR");
      return;
    }

    Node * aux = node->children;

    while(aux != NULL){
      printTree(aux);
      aux = aux->next;
    }
  }

}

void printIncludes(){
  printf("#include \"./include/rclib.h\"\n");
}

