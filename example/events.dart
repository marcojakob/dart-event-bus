/**
 * This is an example of how to set up events used by the event bus.
 * Once created, the event bus may be injected into other classes or made
 * globally available.
 * 
 * For an example application that uses these events see [app.dart].
 */
library events;

import 'package:event_bus/event_bus.dart';
export 'package:event_bus/event_bus.dart';

final EventType<String> textUpdate1 = new EventType<String>();
final EventType<String> textUpdate2 = new EventType<String>();