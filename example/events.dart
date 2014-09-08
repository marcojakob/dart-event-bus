/**
 * This is an example of how to set up the [EventBus] and its events.
 */
library events;

import 'package:event_bus/event_bus.dart';

/// The global [EventBus] object.
EventBus eventBus = new EventBus();

/// Event A.
class MyEventA {
  String text;
  
  MyEventA(this.text);
}

/// Event B.
class MyEventB {
  String text;
  
  MyEventB(this.text);
}

