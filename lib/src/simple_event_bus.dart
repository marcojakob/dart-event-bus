part of event_bus;

/**
 * Basic implementation of [EventBus] that provides a broadcast [StreamController]
 * for each [EventType].
 */
class SimpleEventBus implements EventBus {
  bool sync;
  
  /**
   * Constructor.
   * 
   * If [sync] is true, events are passed directly to the stream's listeners
   * during an add, addError or close call. If [sync] is false, the event
   * will be passed to the listeners at a later time, after the code creating
   * the event has returned.
   */
  SimpleEventBus({this.sync: false});
  
  /// Map containing a stream controller for each [EventType]
  Map<EventType, StreamController> streamControllers = 
      new Map<EventType, StreamController>();
  
  Stream/*<T>*/ on(EventType/*<T>*/ eventType) {
    return streamControllers.putIfAbsent(eventType, () {
      return new StreamController.broadcast(sync: sync);
      }
    ).stream;
  }
  
  void fire(EventType/*<T>*/ eventType, /*<T>*/ data) {
    if (!eventType.isTypeT(data)) {
      throw new ArgumentError('Provided data is not of same type as generic type of EventType.');
    }
    
    var controller = streamControllers[eventType];
    if (controller != null) {
      controller.add(data);
    }
  }
}