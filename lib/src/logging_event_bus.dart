part of event_bus;

final _logger = new Logger("event_bus");

/**
 * A [SimpleEventBus] that adds logging. 
 */
class LoggingEventBus extends SimpleEventBus {
  
  void fire(EventType/*<T>*/ eventType, /*<T>*/ data) {
    super.fire(eventType, data);
    _logger.finest('event fired:  ${eventType.name}');
  }
}