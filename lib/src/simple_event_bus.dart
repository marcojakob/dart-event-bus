part of event_bus;

/**
 * Basic implementation of [EventBus] that provides a [BroadcastStreamController]
 * for each [EventType].
 */
class SimpleEventBus implements EventBus {
  
  /// Map containing a stream controller for each [EventType]
  Map<EventType, BroadcastStreamController> map = 
      new Map<EventType, BroadcastStreamController>();
  
  Stream/*<T>*/ on(EventType/*<T>*/ eventType) {
    return map.putIfAbsent(eventType, () => new BroadcastStreamController/*<T>*/())
        .stream;
  }
  
  void fire(EventType/*<T>*/ eventType, /*<T>*/ data) {
    if (!eventType.isTypeT(data)) {
      throw new ArgumentError('Provided data is not of same type as generic type of EventType.');
    }
    
    var controller = map.putIfAbsent(eventType, () => new BroadcastStreamController/*<T>*/());
    
    // Only add data events when the stream is running. Otherwise, if no one was
    // listening, the events would be cached which could lead to a memory leak.
    if (controller.hasListener && !controller.isClosed && !controller.isPaused) {
      controller.add(data);
    }
  }
}