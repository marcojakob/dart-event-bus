part of event_bus;

/**
 * Basic implementation of [EventBus] that provides a [BroadcastStreamController]
 * for each [EventType].
 */
class SimpleEventBus implements EventBus {
  
  /// Map containing a stream controller for each [EventType]
  Map<EventType, BroadcastStreamController> streamControllers = 
      new Map<EventType, BroadcastStreamController>();
  
  @override
  Stream/*<T>*/ on(EventType/*<T>*/ eventType) {
    return streamControllers.putIfAbsent(eventType, () => _createStreamController(eventType))
        .stream;
  }
  
  @override
  void fire(EventType/*<T>*/ eventType, /*<T>*/ data) {
    if (!eventType.isTypeT(data)) {
      throw new ArgumentError('Provided data is not of same type as generic type of EventType.');
    }
    
    var controller = streamControllers.putIfAbsent(eventType, () => _createStreamController(eventType));
    
    // Only add data events when the stream is running. Otherwise, if no one was
    // listening, the events would be cached which could lead to a memory leak.
    if (controller.hasListener && !controller.isClosed && !controller.isPaused) {
      controller.add(data);
    }
  }
  
  /**
   * Creates a BroadcastStreamController that removes itself from the map when
   * it is cancelled.
   */
  BroadcastStreamController/*<T>*/ _createStreamController(EventType/*<T>*/ eventType) {
    return new BroadcastStreamController(
        // Remove from map when tha last stream is canceled.
        onCancel: () => streamControllers.remove(eventType));
  }
}