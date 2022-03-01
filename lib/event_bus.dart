import 'dart:async';
import 'package:rxdart/subjects.dart';

/// Dispatches events to listeners using the Dart [Stream] API. The [EventBus]
/// enables decoupled applications. It allows objects to interact without
/// requiring to explicitly define listeners and keeping track of them.
///
/// Not all events should be broadcasted through the [EventBus] but only those of
/// general interest.
///
/// Events are normal Dart objects. By specifying a class, listeners can
/// filter events.
///
class EventBus {
  late PublishSubject _sequentialStreamController;
  late ReplaySubject _stickyStreamController;
  final List<Object> _stickyEvents = [];

  /// Controller for the event bus stream.
  PublishSubject get sequentialStreamController => _sequentialStreamController;
  ReplaySubject get stickyStreamController => _stickyStreamController;

  /// List of available sticky events
  List<Object> get stickyEvents => _stickyEvents;

  /// Creates an [EventBus].
  ///
  /// If [sync] is true, events are passed directly to the stream's listeners
  /// during a [fire] call. If false (the default), the event will be passed to
  /// the listeners at a later time, after the code creating the event has
  /// completed.
  EventBus({bool sync = false}) {
    _sequentialStreamController = PublishSubject(sync: sync);
    _stickyStreamController = ReplaySubject(sync: sync);
  }

  // TODO: Someone do something with this please. Do we need this anymore? Do people actually use it?
  // /// Instead of using the default [StreamController] you can use this constructor
  // /// to pass your own controller.
  // ///
  // /// An example would be to use an RxDart Subject as the controller.
  // EventBus.customController(StreamController controller) : _streamController = controller;

  /// Listens for events of Type [T] and its subtypes.
  ///
  /// The method is called like this: myEventBus.on<MyType>();
  ///
  /// If the method is called without a type parameter, the [Stream] contains every
  /// event of this [EventBus].
  ///
  /// The returned [Stream] is a broadcast stream so multiple subscriptions are
  /// allowed.
  ///
  /// Each listener is handled independently, and if they pause, only the pausing
  /// listener is affected. A paused listener will buffer events internally until
  /// unpaused or canceled. So it's usually better to just cancel and later
  /// subscribe again (avoids memory leak).
  ///
  Stream<T> on<T>({bool sticky = false}) {

    // Handle sticky streams
    if (sticky) {
      if (T == dynamic) {
        return _stickyStreamController.stream as Stream<T>;
      } else {
        return _stickyStreamController.stream.where((event) {
          return (event is T) && _stickyEvents.contains(event);
        }).cast<T>();
      }
    }

    // Handle sequential streams
    if (T == dynamic) {
      return _sequentialStreamController.stream as Stream<T>;
    } else {
      return _sequentialStreamController.stream.where((event) => event is T).cast<T>();
    }

  }

  /// Fires a new event on the event bus with the specified [event].
  ///
  void fire(event, {bool sticky = false}) {
    if (sticky) {
      _addStickyEvent(event);
    } else {
      sequentialStreamController.add(event);
    }
  }

  /// Sticky functions
  ///
  void _addStickyEvent(event) {

    // Add the event to the list of events
    _stickyEvents.add(event);

    // Call any sticky listeners
    _stickyStreamController.add(event);

  }

  void removeStickyEvent(event) {
    _stickyEvents.remove(event);
  }

  void fireAllStickyEvents<T>() {
    for (final event in _stickyEvents) {

      // Try and call only events of a type
      if (event is T) {
        _stickyStreamController.add(event);
      } else {
        _stickyStreamController.add(event);
      }

    }
  }

  void removeAllStickyEvents<T>() {

    // Remove all non-typed events
    if (T == dynamic) {
      _stickyEvents.clear();
    } else {
      _stickyEvents.removeWhere((event) => event is T);
    }

  }

  /// Destroy this [EventBus]. This is generally only in a testing context.
  ///
  void destroy() {
    _sequentialStreamController.close();
    _stickyStreamController.close();
  }
}
