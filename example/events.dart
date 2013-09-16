/**
 * This is an example of how to set up events used by the event bus.
 */
library events;

import 'package:event_bus/event_bus.dart';
export 'package:event_bus/event_bus.dart';

EventBus _eventBus;

/// The global [EventBus] object.
EventBus get eventBus => _eventBus;

/// Initializes the global [EventBus] object. Should only be called once!
void init(EventBus eventBus) {
  _eventBus = eventBus;
}

final EventType<String> textUpdateA = new EventType<String>('textUpdateA');
final EventType<String> textUpdateB = new EventType<String>('textUpdateB');