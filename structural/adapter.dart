/*
* The Adapter pattern (also known as Wrapper) allows objects with incompatible
* interfaces to collaborate. It is useful in situations such as integrating with
* a library that does not match any existing interfaces for similar features
* within an application.
*
* There are two types of Adapters - Object Adapters and Class Adapters. An 
* Object Adapter implements an interface and is composed of a service class
* whose interface we we are trying to Adapt. A Class Adapter uses multiple 
* inheritance of an Existing class with the desired interface and a Service 
* class. The translation from the Existing interface to the Service interface 
* happens in the overridden methods of the Adapter class. This example will 
* demonstrate an Object Adapter, as the Dart programming language does not 
* support multiple inheritance.
* 
* The example shown below is a software model of creating an adapter to allow
* a square peg to fit into a round hole.
* */

import 'dart:math';

void main() {
  RoundHole hole = RoundHole(13.25);
  RoundPeg rp1 = RoundPeg(25.123);
  RoundPeg rp2 = RoundPeg(7.33);
  SquarePeg sp = SquarePeg(6.75);
  SquarePeg sp2 = SquarePeg(25.256);
  SquarePegAdapter spa = SquarePegAdapter(sp);
  SquarePegAdapter spa2 = SquarePegAdapter(sp2);

  print('Fitting pegs into hole...');
  hole.fits(rp1);
  hole.fits(rp2);
  hole.fits(spa);
  hole.fits(spa2);
}

class RoundHole {
  RoundHole(this._radius);
  double _radius;
  
  get getRadius => _radius;
  
  void fits(RoundPeg peg) {
    getRadius >= peg.getRadius ?
    print('Round peg with radius ${peg.getRadius} fits in a round hole with radius $getRadius.') :
    print('Round peg with radius ${peg.getRadius} does not fit in a round hole with radius $getRadius.');
  }
}

class RoundPeg {
  RoundPeg([this.radius = 0.0]);
  double radius;
  
  get getRadius => radius;
}

class SquarePeg {
  SquarePeg(this._width);
  double _width;
  
  get width => _width;
}

class SquarePegAdapter extends RoundPeg {
  SquarePegAdapter(this._peg);
  SquarePeg _peg;
  
  @override
  get getRadius => _peg.width * sqrt2 / 2;
}