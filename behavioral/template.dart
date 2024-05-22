/*
* The Template Method pattern defines a skeleton of an algorithm in a superclass
* and allows subclasses override specific steps of the algorithm without
* changing it's structure.
*
* Compare use cases of the Template Method pattern with those of the Factory
* and Strategy patters. The Template pattern is based on inheritance while the
* Strategy pattern is based on composition.
*
* Our example below demonstrates how a Template Method pattern can be used to
* implement various entity AIs for a map-based strategy game.
* */

import 'dart:mirrors';

void main() {
  // Initialize game entities
  List<EntityAI> entities = [];
  entities.add(BarbarianAI());
  entities.add(FactionAI());

  for (var entity in entities) {
    print('\n- Beginning turn for ${entity.runtimeType} -');
    entity.takeTurn();
  }
}

/// Hypothetical interfaces to assist with example
abstract class Building {
  void collect();
}

abstract class Target {}

/// Base class outlining two Template Methods - takeTurn and attack
abstract class EntityAI {
  List<Building> buildings = [];

  void takeTurn() {
    collectResources();
    buildStructures();
    buildUnits();
    attack();
  }

  void attack({Target? t = null}) {
    if (t != null) {
      sendWarriors(t);
    } else {
      sendScouts(t);
    }
  }

  void sendScouts(Target);
  void sendWarriors(Target);

  void collectResources() {
    for (var building in buildings) {
      building.collect();
    }
  }

  void buildStructures();
  void buildUnits();
}

class FactionAI extends EntityAI {
  @override
  void buildStructures() {
    print('Building structures for FactionAI.');
  }

  @override
  void buildUnits() {
    print('Building units for FactionAI.');
  }

  @override
  void sendScouts(Target) {
    print('Sending scouts for FactionAI.');
  }

  @override
  void sendWarriors(Target) {
    print('Sending warriors for FactionAI.');
  }
}

class BarbarianAI extends EntityAI {
  @override
  void collectResources() {
    print('Barbarians don\'t collect resources.');
  }

  @override
  void buildStructures() {
    print('Barbarians don\'t build structures.');
  }

  @override
  void buildUnits() {
    print('Barbarians don\'t build units.');
  }

  @override
  void sendScouts(Target) {
    print('Barbarians don\'t have any scouts.');
  }

  @override
  void sendWarriors(Target) {
    print('Sending warriors for BarbarianAI.');
  }
}