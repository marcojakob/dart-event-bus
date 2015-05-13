library event_bus;

import 'dart:async';

/**
 * Dispatches events to listeners using the Dart [Stream] API. The [EventBus]
 * enables decoupled applications. It allows objects to interact without
 * requiring to explicitly define listeners and keeping track of them.
 *
 * Not all events should be broadcasted through the [EventBus] but only those of
 * general interest.
 *
 * Events are normal Dart objects. By specifying a class, listeners can
 * filter events. Such a filter will return
 * specifying a class.
 */
class EventBus {

  StreamController _streamController;

  /// Controller for the event bus stream.
  StreamController get streamController => _streamController;

  /**
   * Creates an [EventBus].
   *
   * If [sync] is true, events are passed directly to the stream's listeners
   * during an [fire] call. If false (the default), the event will be passed to
   * the listeners at a later time, after the code creating the event has
   * completed.
   */
  EventBus({bool sync: false}) {
    _streamController = new StreamController.broadcast(sync: sync);
  }

  /**
   * Listens for events of [eventType].
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
      return streamController.stream.where((event) => event.runtimeType == eventType);
    }
  }

  /**
   * Fires a new event on the event bus with the specified [event].
   */
  void fire(event) {
    streamController.add(event);
  }

  /**
   * Destroy this [EventBus]. This is generally only in a testing context.
   */
  void destroy() {
    _streamController.close();
  }
}