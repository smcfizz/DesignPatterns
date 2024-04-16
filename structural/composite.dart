/*
* The Composite Pattern (a.k.a. Object Tree) allows for composing objects into
* tree structures and then work with these structures as if they were individual
* objects. Using this pattern only makes sense when the core model of you app
* can be represented as a tree. The greatest benefit of this approach is that
* you don't need to care about the concrete classes of objects that compose the
* tree.
*
* The example used here is one of stacking geometric shapes in a graphical
* editor.
* */

void main() {
  ImageEditor editor = ImageEditor();

  Dot d1 = Dot(2, 3);
  Circle c1 = Circle(2, 3, 5);
  Dot d2 = Dot(1, 4);
  Circle c2 = Circle(1, 4, 7);

  print('Creating group 1 out of d1 c1');

  editor.addGraphic(d1);
  editor.addGraphic(c1);
  CompoundGraphic group1 = editor.groupSelected([d1, c1]);

  print('\nGrouping d2 c2 with group 1');

  editor.addGraphic(d2);
  editor.addGraphic(c2);
  CompoundGraphic group2 = editor.groupSelected([d2, c2, group1]);
}

class ImageEditor {
  CompoundGraphic all = CompoundGraphic();

  void addGraphic(Graphic g) {
    all.add(g);
  }

  CompoundGraphic groupSelected(List<Graphic> graphics) {
    CompoundGraphic group = CompoundGraphic();
    for (Graphic g in graphics) {
      group.add(g);
      all.remove(g);
    }
    all.add(group);
    all.draw();
    return group;
  }
}

abstract interface class Graphic {
  void move(int x, int y);
  void draw();
}

class CompoundGraphic implements Graphic {
  List<Graphic> children = [];

  void add(Graphic g) {
    children.add(g);
  }

  void remove(Graphic g) {
    children.remove(g);
  }

  @override
  void draw() {
    for (Graphic g in children) {
      g.draw();
    }
  }

  @override
  void move(int x, int y) {
    for (Graphic g in children) {
      g.move(x, y);
    }
  }
}

class Dot implements Graphic {
  Dot(this.x, this.y);

  int x;
  int y;

  @override
  void draw() {
    print('Drawing Dot $this');
  }

  @override
  void move(int x, int y) {
    print('Moving Dot $this to ($x, $y)');
    this.x = x;
    this.y = y;
  }
}

class Circle extends Dot {
  Circle(super.x, super.y, this.radius);

  int radius;

  @override
  void draw() {
    print('Drawing Circle $this with radius of $radius');
  }

  @override
  void move(int x, int y) {
    print('Moving Circle $this to ($x, $y) with radius of $radius');
  }
}

// Add as many more shapes as desired

