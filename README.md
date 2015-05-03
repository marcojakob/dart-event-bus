# Event Bus

A simple Event Bus using Dart [Streams](https://api.dartlang.org/apidocs/channels/stable/dartdoc-viewer/dart:async.Stream) 
for decoupling applications.


## Demo

See [Dart Event Bus in action](http://code.makery.ch/library/dart-event-bus/).

All examples are also available in the [example directory on GitHub](https://github.com/marcojakob/dart-event-bus/tree/master/example).


## Event Bus Pattern

An Event Bus follows the publish/subscribe pattern. It allows listeners to 
subscribe for events and publishers to fire events. This enables objects to
interact without requiring to explicitly define listeners and keeping track of
them.


### Event Bus and MVC

The Event Bus pattern is especially helpful for decoupling [MVC](http://wikipedia.org/wiki/Model_View_Controller) 
(or [MVP](http://wikipedia.org/wiki/Model_View_Presenter)) applications.

**One group of MVC** is not a problem.

![Model-View-Controller](https://raw.githubusercontent.com/marcojakob/dart-event-bus/master/doc/mvc.png)

But as soon as there are **multiple groups of MVCs**, those groups will have to talk
to each other. This creates a tight coupling between the controllers.

![Multi Model-View-Controllers](https://raw.githubusercontent.com/marcojakob/dart-event-bus/master/doc/mvc-multi.png)

By communication through an **Event Bus**, the coupling is reduced.

![Event Bus](https://raw.githubusercontent.com/marcojakob/dart-event-bus/master/doc/event-bus.png)


## Usage


### 1. Create an Event Bus

Create an instance of `EventBus` and make it available to other classes.

Usually there is just one Event Bus per application, but more than one may be 
set up to group a specific set of events.

```dart
import 'package:event_bus/event_bus.dart';

EventBus eventBus = new EventBus();
```

You can alternatively use the `HierarchicalEventBus` that filters events by 
event class **including** its subclasses. 

*Note that the hierarchical event bus uses `dart:mirrors` which support in 
dart2js is experimental.*

```dart
import 'package:event_bus/event_bus_hierarchical.dart';

EventBus eventBus = new HierarchicalEventBus();
```


### 2. Define Events

Any Dart class can be used as an event.

```dart
class UserLoggedInEvent {
  User user;
  
  UserLoggedInEvent(this.user);
}

class NewOrderEvent {
  Order order;
  
  NewOrderEvent(this.text);
}
```


### 3. Register Listeners

Register listeners for a **specific events**: 

```dart
eventBus.on(UserLoggedInEvent).listen((UserLoggedInEvent event) {
  print(event.user);
});
```

Register listeners for **all events**:

```dart
eventBus.on().listen((event) {
  // Print the runtime type. Such a set up could be used for logging.
  print(event.runtimeType); 
});
```


#### About Dart Streams

`EventBus` uses Dart [Streams](https://api.dartlang.org/apidocs/channels/stable/dartdoc-viewer/dart:async.Stream)
as its underlying mechanism to keep track of listeners. You may use all 
functionality available by the [Stream](https://api.dartlang.org/apidocs/channels/stable/dartdoc-viewer/dart:async.Stream)
API. One example is the use of [StreamSubscriptions](https://api.dartlang.org/apidocs/channels/stable/dartdoc-viewer/dart:async.StreamSubscription)
to later unsubscribe from the events.

```dart
StreamSubscription loginSubscription = eventBus.on(UserLoggedInEvent).listen((UserLoggedInEvent event) {
  print(event.user);	
});

loginSubscription.cancel();
```


### 4. Fire Events

Finally, we need to fire an event.

```dart
User myUser = new User('Mickey');
eventBus.fire(new UserLoggedInEvent(myUser));
```


## License

The MIT License (MIT)