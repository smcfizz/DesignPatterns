/*
* The Strategy pattern is best suited to cases where the "how" of a problem
* is solved may change, but the goal remains the same. The example used here is
* that of a maze solver where the specific search algorithm used can vary.
* Notice how we are able to swap out the search algorithm the MazeSolver class
* uses during runtime. This is a unique trait of the Strategy when compared to
* some other similar patterns.
*
* Not only does this pattern keep code flexible and maintainable, but it
* decreases the need for testing by splitting business logic out from
* application logic, resulting in new changes having no effect on existing
* logic, as can occur in cases where this pattern is not used such as a
* conditional if-else branch.
*
* This pattern can also ease development strains by splitting each
* strategy into its own file in order to prevent merge conflicts where
* */

import 'dart:collection';

void main() {
  Maze maze = Maze();
  MazeSolver solver = MazeSolver(maze, BreadthFirstSearch());

  void testSolver() {
    List<int> solution = solver.solve();
    if (solution[0] >= 0) {
      print('A solution was found at [${solution[0]}, ${solution[1]}].');
    } else {
      print('A solution was not found.');
    }
  }

  testSolver();

  // Update our search algorithm
  solver.algorithm = DepthFirstSearch();

  testSolver();
}

class MazeSolver {
  ISearchAlgorithm algorithm;
  Maze maze;

  MazeSolver(this.maze, this.algorithm);

  List<int> solve() {
    return algorithm.search(maze);
  }
}

class Maze {
  List<List<int>> _maze;

  get length => _maze.length;

  // Say we have a 5x5 maze, where any positive value represents a wall and
  // the negative value represents the goal, of which there is only ever one
  Maze()
    : _maze = [
      [0, 0, 0, 0, 0],
      [0, 1, 1, 0, 0],
      [0, 0, 1, -1, 0],
      [0, 0, 1, 1, 0],
      [0, 0, 0, 0, 0]
  ];

  List<int> operator [](int index) {
    if (0 <= index && index < _maze.length) {
      return _maze[index];
    } else {
      throw RangeError('The index \'$index\' is out of range.');
    }
  }
}

/// An interface that our strategies will implement
abstract class ISearchAlgorithm {
  /// Given a Maze, this method will return the coordinates of the goal, if
  /// present. In the event no goal is present, the method will return
  /// [\[-1, -1]\]. The search always begins from position [\[0, 0]\].
  List<int> search(Maze m);
}

// Below we have a number of strategies that our application can use.

/*
* And we can continue to add more and more strategies with minimal effort.
* e.g.
* Greedy Best First Search
* A*
* Dijkstra's (add support for weighted mazes)
* etc.
* */

class BreadthFirstSearch implements ISearchAlgorithm {
  @override
  List<int> search(Maze m) {
    print('Solving with Breadth First Search...');

    Set<List<int>> visited = {};
    Queue<List<int>> queue = Queue<List<int>>();

    queue.add([0, 0]);
    visited.add([0, 0]);

    while (queue.isNotEmpty) {
      // Dequeue coordinates from the queue
      List<int> currentCoordinates = queue.removeFirst();
      int row = currentCoordinates[0];
      int col = currentCoordinates[1];

      // Check if the current position is the target (-1)
      if (m[row][col] == -1) {
        return [row, col];
      }

      // Get neighboring coordinates
      List<List<int>> neighbors = [
        [row - 1, col], // Up
        [row + 1, col], // Down
        [row, col - 1], // Left
        [row, col + 1], // Right
      ];

      // Enqueue valid neighbors if not visited and not a wall (1)
      for (List<int> neighbor in neighbors) {
        int newRow = neighbor[0];
        int newCol = neighbor[1];

        if (newRow >= 0 &&
            newRow <  m.length &&
            newCol >= 0 &&
            newCol < m[0].length &&
            m[newRow][newCol] != 1 &&
            !visited.contains(neighbor)) {
          queue.add(neighbor);
          visited.add(neighbor);
        }
      }
    }

    // Target was not found
    return [-1, -1];
  }
}

class DepthFirstSearch implements ISearchAlgorithm {
  @override
  List<int> search(Maze m) {
    print('Solving with Depth First Search...');

    Set<List<int>> visited = {};

    List<int>? solution = dfs(m, 0, 0, visited);

    return solution ?? [-1, -1];
  }

  List<int>? dfs(Maze m, int row, int col, Set visited) {
    visited.add([row, col]);

    if (m[row][col] == -1) {
      return [row, col];
    }

    List<List<int>> neighbors = [
      [row - 1, col], // Up
      [row + 1, col], // Down
      [row, col - 1], // Left
      [row, col + 1], // Right
    ];

    // Check all directions that are in bounds
    for (List<int> neighbor in neighbors) {
      int newRow = neighbor[0];
      int newCol = neighbor[1];

      if (newRow >= 0 &&
          newRow <  m.length &&
          newCol >= 0 &&
          newCol < m[0].length &&
          m[newRow][newCol] != 1 &&
          (visited.where((e) => e == neighbor).length == 0)) {
        return dfs(m, newRow, newCol, visited);
      }
    }

    return null;
  }
}