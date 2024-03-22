/*
* The Factory pattern should be used when your application must function with
* various different objects that are all related and provide the same general
* functionality. This example is an application that interfaces with various
* different types of data stores. Each data store shares the same requirements
* of allowing the client to connect, read, write, and disconnect.
*
* The creator class usually also contains some core business logic that relies
* on product objects returned by the factory method. Subclasses can indirectly
* change the business logic by overriding the factory method and returning a
* different type of product from it.
*
* The factory pattern enables the client code to function independently of the
* specific type of data store due to their shared interface and also makes
* the addition of new data stores easier and does not require any changes to the
* client code
* */

void main() {
  String DATA_CONFIG = 's3';
  DataStore data;
  switch(DATA_CONFIG) {
    case 'db':
      data = Database();
      break;
    case 's3':
      data = S3Storage();
      break;
    default:
      throw UnimplementedError('Unsupported DataStore config!');
  }

  String oldData = data.transferData('Here is some new data!');
  print(oldData);
}

abstract class DataStore {
  // Creator method
  DataConnection connect();

  // Business logic
  String transferData(String newData) {
    DataConnection connection = connect();
    String oldData = connection.load();
    connection.save(newData);
    return 'Old data was: $oldData';
  }
}

class Database extends DataStore {
  @override
  DataConnection connect() {
    return DatabaseConnection();
  }
}

class S3Storage extends DataStore {
  @override
  DataConnection connect() {
    return S3StorageConnection();
  }
}

abstract interface class DataConnection {
  void save(String s);
  String load();
}

class DatabaseConnection implements DataConnection {
  @override
  String load() {
    return 'Hello world from the database!';
  }

  @override
  void save(String s) {
    print('Saving data \'$s\' to database!');
  }
}

class S3StorageConnection implements DataConnection {
  @override
  String load() {
    return 'Hello world from S3 storage!';
  }

  @override
  void save(String s) {
    print('Saving data \'$s\' to S3 storage!');
  }
}