part of event_bus;

/**
 * Caches a broadcast stream to provide the same [Stream] to multiple
 * substribers. This is necessary because [#stream.asBroadcastStream()] can 
 * only be called once.
 */
class BroadcastStreamController<T> extends StreamController<T> {
  Stream<T> _broadcastCache;
  
  @override
  Stream<T> get stream {
    if(_broadcastCache == null) {
      _broadcastCache = super.stream.asBroadcastStream();
    }
    return _broadcastCache;
  }
}