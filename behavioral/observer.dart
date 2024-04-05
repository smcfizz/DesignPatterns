/*
* The Observer pattern lets you define a subscription mechanism to notify
* multiple objects about any events that happen to the object they're observing.
*
* The Observer pattern is comprised of a Publisher class which is responsible
* for sending notifications to it's Concrete Subscribers, which all implement
* a shared Subscriber interface to ensure consistency between various types of
* subscribers. The same can be done for the Publisher as well - force all
* Publishers to implement a shared Publisher interface so any Subscriber can
* subscribe to any Publisher without compatibility issues.
*
* The example shown below consists of a RecordStore class serving as a Publisher
* that notifies users who are subscribed to their mailing list any time a new
* album is released and is available for purchase.
* */

void main() {
  RecordStore rs = RecordStore();
  Customer c1 = Customer('Customer 1');
  Customer c2 = Customer('Customer 2');
  Customer c3 = Customer('Customer 3');

  rs.subscribeCustomer(c1);
  rs.subscribeCustomer(c2);
  // Notice c3 is not subscribed

  rs.addNewRelease('Dark Side of the Moon');
}

/// Subscriber
abstract interface class Observer {
  void onUpdate(String data);
}

/// Publisher
mixin class Notifier {
  List<Observer> _subscribers = List.empty(growable: true);

  void addObserver(Observer o) {
    _subscribers.add(o);
  }

  void removeObserver(Observer o) {
    _subscribers.remove(o);
  }

  void notifyObservers(String data) {
    for (Observer s in _subscribers) {
      s.onUpdate(data);
    }
  }
}

class Customer implements Observer {
  Customer(this.name);

  String name;

  @override
  void onUpdate(String data) {
    print('$name notified of a new release: \'$data\'!');
  }
}

class RecordStore extends Notifier {
  void subscribeCustomer(Customer c) {
    addObserver(c);
  }
  void unsubscribeCustomer(Customer c) {
    removeObserver(c);
  }
  void addNewRelease(String title) {
    notifyObservers(title);
  }
}