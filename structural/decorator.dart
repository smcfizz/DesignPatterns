/*
* The Decorator pattern (a.k.a Wrapper) allows for attaching new behaviors to
* objects by placing these objects inside special wrapper objects that contain
* the behaviors. It should be used when the client is expected to utilize
* multiple of the additional behaviors in conjunction with one another. In this
* example we see a Notifier that supports notifying users through several
* different platforms: email, slack, and SMS.
*
* The decorator pattern enables the client code to configure their Notifier to
* send notifications to any and all platforms that are relevant to them, while
* avoiding bloating the codebase with an exponential amount of subclasses
* representing all possible combinations of notifications, as would be the case
* if we were to simply use subclasses of Notifier for each new platform.
* Avoiding inheritance also offers other benefits such as being able to alter
* behavior at runtime and being able to encapsulate functionality from multiple
* other classes where inheritance would limit us to a single parent.
* */

void main() {
  Notifier notifier = EmailNotifier();
  notifier = SMSDecorator(notifier);
  notifier = SlackDecorator(notifier);

  notifier.send('This is a new notification!');
}

/// The `Component` which declares the common interface for both wrappers and
/// wrapped objects.
abstract interface class Notifier {
  void send(String message);
}

/// The `Concrete Component` is a class of objects being wrapped. It defines
/// basic behavior, which can be altered by decorators.
class EmailNotifier implements Notifier {
  @override
  void send(String message) {
    print('Email: $message');
  }
}

/// The `Base Decorator` class has a field for referencing the wrapped object.
/// The field's type should be declared as the component interface so it can
/// contain both concrete components and decorators. The base decorator
/// delegates all operations to the wrapped object.
class NotifierDecorator implements Notifier {
  NotifierDecorator(this._wrappee);

  Notifier _wrappee;

  @override
  void send(String message) {
    _wrappee.send(message);
  }
}

/// `Concrete Decorators` define extra behavior that can be dynamically added
/// to components. Concrete decorators override methods of the base decorator
/// and execute their behavior either before or after calling the parent method.
class SMSDecorator extends NotifierDecorator {
  SMSDecorator(super.notifier);

  @override
  void send(String message) {
    print('SMS: $message');
    super.send(message);
  }
}

class SlackDecorator extends NotifierDecorator {
  SlackDecorator(super.notifier);

  @override
  void send(String message) {
    print('Slack: $message');
    super.send(message);
  }
}