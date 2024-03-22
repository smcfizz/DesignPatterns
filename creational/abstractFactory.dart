/*
* The Abstract Factory pattern is similar to the factory pattern but differs in
* that the Abstract Factory typically returns a family of related products
* without specifying their concrete classes. Unlike the Factory pattern, the
* Abstract Factory does not contain any business logic and instead returns the
* Products it creates directly to the client code to use.
*
* This example shows how multiple UI components of varying style can be rendered
* for an application based on the user's preferences.
* */

void main() {
  String UI_PREFERENCE = 'apple';
  UIFactory uiFactory;

  switch(UI_PREFERENCE) {
    case 'apple':
      uiFactory = AppleUIFactory();
      break;
    case 'material':
      uiFactory = MaterialUIFactory();
      break;
    default:
      throw UnimplementedError();
  }

  Application(uiFactory);
}

class Application {
  Application(UIFactory ui) {
    ui.createButton().render();
    ui.createCheckbox().render();
  }
}

abstract interface class UIFactory {
  Button createButton();
  Checkbox createCheckbox();
}

/// Renders UI components that follow Google's Material Design guidelines
class MaterialUIFactory implements UIFactory {
  @override
  Button createButton() {
    return MaterialButton();
  }

  @override
  Checkbox createCheckbox() {
    return MaterialCheckbox();
  }
}

/// Renders UI components that follow Apple's Human Interface Guidelines
class AppleUIFactory implements UIFactory {
  @override
  Button createButton() {
    return AppleButton();
  }

  @override
  Checkbox createCheckbox() {
    return AppleCheckbox();
  }
}

abstract interface class Button {
  void render();
}

class MaterialButton implements Button {
  @override
  void render() {
    print('This is a MaterialButton!');
  }
}

class AppleButton implements Button {
  @override
  void render() {
    print('This is an AppleButton!');
  }
}

abstract interface class Checkbox {
  void render();
}

class MaterialCheckbox implements Checkbox {
  @override
  void render() {
    print('This is a MaterialCheckbox!');
  }
}

class AppleCheckbox implements Checkbox {
  @override
  void render() {
    print('This is an AppleCheckbox!');
  }
}