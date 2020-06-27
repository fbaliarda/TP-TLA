/*
 *    Credits to: @ChuOkupai
 *    https://github.com/ChuOkupai/n-ary-tree
 */

#ifndef _NODE_H

#include <stdlib.h>

#define MAX_DATA_TYPES 256

typedef enum type {

  _branch, _variable, _literal, _main, _opar, _cpar, _obracket, _cbracket, _endline,
  _equal, _plus, _minus, _multiplication, _division, _comma, _return, _and, _or, _not, _is_equal, _is_greater,
  _is_lower, _if, _while, _one, _zero, _integer, _string, _boolean, _readStdIn, _writeStdIn, _atoi, _freeMemory

} type;

static char * types[MAX_DATA_TYPES] = {
   "branch", "variable", "literal", "int main", "(", ")", "{\n", "}\n", ";\n", "=", "+", "-", "*", "/", ",", "return",
   "&&", "||", "!", "==", ">", "<", "if", "while", "1", "0", "int", "char *", "bool", "readStdInput", "printf", "atoi", "freeProgramMemory();\n"
 };

typedef struct Node Node;
struct Node {
  type type;
  char  * data;
  Node  * next;
  Node  * prev;
  Node  * parent;
  Node  * children;
};

/* Creates a new Node containing the given data type is notLeaf_*/
/** Returns NULL on error **/
Node * nodeNew(char * data);

/* Creates a new Node containing the given data and given type */
/** Returns NULL on error **/
Node * nodeNewLeaf(char * data, type type);

/* Inserts a Node as the last child of the given parent */
/** Returns NULL on error **/
#define nodeAppend(parent, node)  nodeInsertBefore((Node *)parent, NULL, (Node *)node)

/* Inserts a Node beneath the parent before the given sibling */
/** If sibling is NULL, the node is inserted as the last child of parent **/
/** Returns NULL on error **/
Node * nodeInsertBefore(Node * parent, Node * sibling, Node * node);

/* Returns a positive value if a Node is the root of a tree else 0 */
#define nodeIsRoot(node)  (! ((Node *)(node))->parent && ! ((Node *)(node))->next)

/* Gets the root of a tree */
/** Returns NULL on error **/
Node * nodeRoot(Node * node);

/* Finds a Node in a tree */
Node * nodeFind(Node * node, void * data, int (* compare)(void * a, void * b));

/* Gets a child of a Node, using the given index */
/** Returns NULL if the index is too big **/
Node * nodeNthChild(Node * node, int n);

/* Gets the number of nodes in a tree */
int nodeTotal(Node  * root);

/* Unlinks a Node from a tree, resulting in two separate trees */
void  nodeUnlink(Node * node);

/* Removes root and its children from the tree, freeing any memory allocated */
void  nodeDestroy(Node * root);

int numberOfChildren(Node * node);

void printTree(Node * node);

void printIncludes();

#endif /* node.h */