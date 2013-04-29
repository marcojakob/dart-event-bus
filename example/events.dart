/**
 * This is an example of how to set up events used by the event bus.
 */
library events;

import 'package:event_bus/event_bus.dart';
export 'package:event_bus/event_bus.dart';

final EventType<String> textUpdate1 = new EventType<String>();
final EventType<String> textUpdate2 = new EventType<String>();