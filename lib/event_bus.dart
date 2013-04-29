library event_bus;

import 'dart:async';
import 'package:meta/meta.dart';

part 'src/simple_event_bus.dart';
part 'src/stream_controller.dart';

/**
 * Dispatches events to listeners using the Dart [Stream] API. The [EventBus] 
 * enables decoupled applications. It allows objects to interact without
 * requiring to explicitly define listeners and keeping track of them.
 * 
 * Usually there is just one [EventBus] per application, but more than one 
 * may be set up to group a specific set of events.
 * 
 * Not all events should be broadcasted through the [EventBus] but only those of
 * general interest.
 * 
 * **Note:** Make sure that listeners on the stream handle the same type <T> as the 
 * generic type argument of [eventType]. Currently, this can't be expressed in 
 * Dart - see [Issue 254](https://code.google.com/p/dart/issues/detail?id=254)
 */
abstract class EventBus {
  
  /**
   * Creates [SimpleEventBus], the default implementation of [EventBus].
   */
  factory EventBus() {
    return new SimpleEventBus();
  }
  
  /**
   * Returns the [Stream] to listen for events of type [eventType]. 
   * 
   * The returned [Stream] is a broadcast stream so multiple subscriptions are
   * allowed.
   */
  Stream/*<T>*/ on(EventType/*<T>*/ eventType);
  
  /** 
   * Fires a new event on the event bus with the specified [data].
   */
  void fire(EventType/*<T>*/ eventType, /*<T>*/ data);
}

/**
 * Type class used to publish events with an [EventBus].
 * [T] is the type of data that is provided when an event is fired.
 */
class EventType<T> {
  
  /**
   * Returns true if the provided data is of type [T]. 
   * 
   * This method is needed to provide type safety to the [EventBus] as long as
   * Dart does not support generic types for methods.
   */
  bool isTypeT(data) => data is T;
}