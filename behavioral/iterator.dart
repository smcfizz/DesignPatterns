/*
* Iterator pattern lets you traverse elements of a collection without exposing
* its underlying representation (list, stack, tree, etc). The main idea is to
* extract traversal behavior of a collection into a separate object called an
* iterator.
*
* The example below shows how custom iterators can be used to traverse a tree
* in different ways, such as depth first search and breadth first search.
* */

void main() {

}

abstract class Collection<E> {
  Iterator<E> createDepthFirstIterator();
  Iterator<E> createBreadthFirstIterator();
}

class TreeNode {
  TreeNode(this.value, {this.right = null, this.left = null});
  int value;
  TreeNode? left;
  TreeNode? right;
}

class Tree implements Collection {
  @override
  Iterator<TreeNode> createBreadthFirstIterator() {
    return new BFSIterator();
  }

  @override
  Iterator<TreeNode> createDepthFirstIterator() {
    return new DFSIterator();
  }
}

abstract class Iterator<E> {
  E next();
  bool hasNext();
}

class DFSIterator<E> implements Iterator<E> {
  @override
  bool hasNext() {
    // TODO: implement hasNext
    throw UnimplementedError();
  }

  @override
  E next() {
    // TODO: implement next
    throw UnimplementedError();
  }
}

class BFSIterator<E> implements Iterator<E> {
  @override
  bool hasNext() {
    // TODO: implement hasNext
    throw UnimplementedError();
  }

  @override
  E next() {
    // TODO: implement next
    throw UnimplementedError();
  }
}