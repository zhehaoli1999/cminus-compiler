#include "SyntaxTree.h"

int main()
{
	SyntaxTree * tree = newSyntaxTree();
	tree->root = newSyntaxTreeNode("root");
	SyntaxTreeNode * newNode;
	SyntaxTreeNode * aNode;
	SyntaxTreeNode * bNode;
	newNode = newSyntaxTreeNode("a");
	aNode = newNode;
	SyntaxTreeNode_AddChild(tree->root, newNode);
	newNode = newSyntaxTreeNode("b");
	SyntaxTreeNode_AddChild(tree->root, newNode);
	newNode = newSyntaxTreeNode("c");
	SyntaxTreeNode_AddChild(tree->root, newNode);
	newNode = newSyntaxTreeNode("aa");
	SyntaxTreeNode_AddChild(aNode, newNode);
	bNode = newSyntaxTreeNode("ac");
	SyntaxTreeNode_AddChild(aNode, bNode);
	newNode = newSyntaxTreeNode("aca");
	SyntaxTreeNode_AddChild(bNode, newNode);
	newNode = newSyntaxTreeNode("acb");
	SyntaxTreeNode_AddChild(bNode, newNode);

	printSyntaxTree(stdout, tree);
	return 0;
}
