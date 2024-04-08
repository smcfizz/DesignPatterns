/*
* The Command pattern turns a request into a standalone object that contains all
* information about the request. The transformation lets us parameterize
* methods with different requests, delay or queue a request's execution, and
* support undoable operations.
*
* The Command patten is commonly used as a means for the UI layer to delegate
* tasks to the business layer and suggests that the UI layer shouldn't send
* these requests directly. Command objects serve as links between various UI
* elements and business logic. This keeps the requests generalized and allows
* the client code to work with various different types of requests. The Command
* pattern is also very useful for keeping track of which commands have been
* issued so far and supporting the ability to undo commands.
*
* The example below shows how the Command pattern can be used as a middle layer
* between a GUI for a text editor and the business logic that determines how the
* editor should function.
* */

void main() {
  // Initialize application
  Application app = Application();
  Map<String, Button> uiButtons = app.createUI();

  // Run some commands
  uiButtons['copy']!.click();
  app.captureShortcut('Ctrl+V');
  app.captureShortcut('Ctrl+V');
  app.captureShortcut('Ctrl+V');
  uiButtons['undo']!.click();
  app.captureShortcut('Ctrl+X');
  uiButtons['paste']!.click();
  app.captureShortcut('Ctrl+Z');

  // Undo a bunch
  uiButtons['undo']!.click();
  uiButtons['undo']!.click();
  uiButtons['undo']!.click();
}

class Application {
  Application() {
    Editor e = Editor();
    _editors.add(e);
    _activeEditor = e;
  }

  late String clipboard;
  CommandHistory _history = CommandHistory();
  List<Editor> _editors = List.empty(growable: true);
  late Editor _activeEditor;
  Shortcuts _shortcuts = Shortcuts();

  Map<String, Button> createUI() {
    Map<String, Button> buttons = {};

    // Copy
    Button copyButton = Button();
    buttons['copy'] = copyButton;
    void copy() {
      executeCommand(CopyCommand(this, _activeEditor));
    }
    copyButton.setCallback(copy);
    _shortcuts.registerShortcut('Ctrl+C', copy);

    // Cut
    Button cutButton = Button();
    buttons['cut'] = cutButton;
    void cut() {
      executeCommand(CutCommand(this, _activeEditor));
    }
    cutButton.setCallback(cut);
    _shortcuts.registerShortcut('Ctrl+X', cut);

    // Paste
    Button pasteButton = Button();
    buttons['paste'] = pasteButton;
    void paste() {
      executeCommand(PasteCommand(this, _activeEditor));
    }
    pasteButton.setCallback(paste);
    _shortcuts.registerShortcut('Ctrl+V', paste);

    // Undo
    Button undoButton = Button();
    buttons['undo'] = undoButton;
    void undo() {
      executeCommand(UndoCommand(this, _activeEditor));
    }
    undoButton.setCallback(undo);
    _shortcuts.registerShortcut('Ctrl+Z', undo);

    return buttons;
  }

  void captureShortcut(String s) {
    _shortcuts.runShortcut(s);
  }

  void executeCommand(Command c) {
    print('Executing ${c.toString()}');
    if (c.execute()) {
      _history.push(c);
    }
  }

  void undo() {
    Command? c = _history.pop();
    if (c != null) {
      print('Undoing ${c.toString()}');
      c.undo();
    }
  }
}

class Editor {
  String text = '';

  String getSelection() {
    // Return currently selected text
    return '';
  }

  void deleteSelection() {
    // Delete the currently selected text
  }
  void replaceSelection(String s) {
    // Replace the currently selected text with `s`
  }
}

abstract class Command {
  Command(this._app, this._editor);

  Application _app;
  Editor _editor;
  String _backup = '';

  void saveBackup() {
    _backup = _editor.text;
  }

  void undo() {
    _editor.text = _backup;
  }

  /// Returns `true` or `false` whether command changes editor's state
  bool execute();
}

class Button {
  late Function _commandCallback;

  void setCallback(Function c) {
    _commandCallback = c;
  }

  void click() {
    _commandCallback();
  }
}

class Shortcuts {
  Map<String, Function> _shortcuts = {};

  void registerShortcut(String s, Function callback) {
    _shortcuts[s] = callback;
  }

  void runShortcut(String s) {
    Function? f = _shortcuts[s];
    if (f != null) {
      f();
    }
  }
}

class CopyCommand extends Command {
  CopyCommand(super.app, super.editor);

  @override
  bool execute() {
    this._app.clipboard = this._editor.getSelection();
    return false;
  }

  @override
  String toString() {
    return 'CopyCommand';
  }
}

class CutCommand extends Command {
  CutCommand(super.app, super.editor);

  @override
  bool execute() {
    this.saveBackup();
    this._app.clipboard = this._editor.getSelection();
    this._editor.deleteSelection();
    return true;
  }

  @override
  String toString() {
    return 'CutCommand';
  }
}

class PasteCommand extends Command {
  PasteCommand(super.app, super.editor);

  @override
  bool execute() {
    this.saveBackup();
    this._editor.replaceSelection(this._app.clipboard);
    return true;
  }

  @override
  String toString() {
    return 'PasteCommand';
  }
}

class UndoCommand extends Command {
  UndoCommand(super.app, super.editor);

  @override
  bool execute() {
    this._app.undo();
    return false;
  }

  @override
  String toString() {
    return 'UndoCommand';
  }
}

class CommandHistory {
  List<Command> _history = List.empty(growable: true);

  void push(Command c) {
    _history.add(c);
  }

  Command? pop() {
    return _history.length > 0 ? _history.removeLast() : null;
  }
}
