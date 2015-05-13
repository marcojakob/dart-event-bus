library event_bus.hierarchical;

import 'dart:async';

@MirrorsUsed(symbols: '*') // Do not keep any names.
import 'dart:mirrors';

import 'event_bus.dart';
export 'event_bus.dart';

/**
 * A [HierarchicalEventBus] that filters events by event class **including**
 * its subclasses.
 *
 * Note: This currently only works with classes **extending** other classes
 * and not with **implementing** an interface. We might have to wait for
 * https://code.google.com/p/dart/issues/detail?id=20756 to enable interfaces.
 */
class HierarchicalEventBus extends EventBus {

  /**
   * Creates a [HierarchicalEventBus].
   *
   * If [sync] is true, events are passed directly to the stream's listeners
   * during an [fire] call. If false (the default), the event will be passed to
   * the listeners at a later time, after the code creating the event has
   * completed.
   */
  HierarchicalEventBus({bool sync: false}) : super(sync: sync);

  /**
   * Listens for events of [eventType] and of all subclasses of [eventType].
   *
   * The returned [Stream] is a broadcast stream so multiple subscriptions are
   * allowed.
   *
   * Each listener is handled independently, and if they pause, only the pausing
   * listener is affected. A paused listener will buffer events internally until
   * unpaused or canceled. So it's usually better to just cancel and later
   * subscribe again (avoids memory leak).
   */
  Stream on([Type eventType]) {
    if (eventType == null) {
      return streamController.stream;
    } else {
      return streamController.stream.where((event) =>
          reflect(event).type.isSubclassOf(reflectClass(eventType)));
    }
  }
}