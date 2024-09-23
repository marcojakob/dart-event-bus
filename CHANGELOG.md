# Changelog

## Version 2.0.2 (2024-09-23)

- Update environment dependency to support up to Dart v3.

## Version 2.0.0 (2021-03-04)

- Migrate to null safety.

## Version 1.1.1 (2020-01-21)

- Fix homepage URL.


## Version 1.1.0 (2019-03-27)

- Add constructor for custom controllers like RxDart Subject (see #21).
- Remove `new` keyword.

## Version 1.0.3 (2019-02-14)

- Cleanup and update dependencies.

## Version 1.0.0 (2018-07-06)

- Migrate to Dart 2.
- BREAKING CHANGE: The `on` method now has a generic type. The type must be passed as a type argument instead of a method parameter. Change `myEventBus.on(MyEventType)` to `myEventBus.on<MyEventType>()`.
- BREAKING CHANGE: Every `EventBus` is now hierarchical so that listeners will also receive events of subtypes of the specified type. This is exactly the way that `HierarchicalEventBus` worked. So `HierarchicalEventBus` has been removed. Use the normal `EventBus` instead.

## Version 0.4.1 (2015-05-13)

- Fix Issue #13: Improve on() stream when no type is specified

## Version 0.4.0 (2015-05-03)

- BREAKING CHANGE: Moved the `HierarchicalEventBus` to a separate library to
  be able to remove `dart:mirrors` from the normal `EventBus`.  
  Users of the hierarchical event bus must import `event_bus_hierarchical.dart`
  and replace the use of the factory constructor `EventBus.hierarchical()` with
  the `HierarchicalEventBus` constructor.

## Version 0.3.0 (2014-09-08)

- BREAKING CHANGE: Changed and simplified the EventBus API. We can now dispatch
  any Dart object as an event. Before, we had to create an EventType for every
  type of event we wanted to fire. Now we can use any class as an event.
  Listeners can (optionally) filter events by that class.
- Added a way to create a **hierarchical event bus** that filters events by
  class and their subclasses. This currently only works with classes
  **extending** other classes and not with **implementing** an interface.
  We might have to wait for
  https://code.google.com/p/dart/issues/detail?id=20756 to enable interfaces.
- BREAKING CHANGE: The EventBus constructor defaults to **async instead of
  sync**!!. This matches the constructor of the Dart Streams and an async event
  bus might also be the more common use case.
- BREAKING CHANGE: Removed LoggingEventBus. Reason is that logging can easily
  be implemented with a event listener that listens for all events and logs
  them.

## Version 0.2.5 (2014-09-03)

- Update example.
- Update readme with new links.
- Update dependencies.

## Version 0.2.4 (2013-11-11)

- Update to dart libraries 0.9.0.

## Version 0.2.3 (2013-09-16)

- Fix issue #8: Add logging of events that flow through event bus

## Version 0.2.2 (2013-09-16)

- Change default of SimpleEventBus to sync (same as factory in EventBus)

## Version 0.2.1 (2013-07-01)

- Fix issue #6: Fire should accept null as data

## Version 0.2.0 (2013-06-06)

- Update to new Dart SDK v0.5.13.1_r23552.
- Using Darts new Stream.broadcast() factory.
- Provide option for synchronous broadcasting of events.
- Update unit tests and example.
- Create demo page.

## Version 0.1.3 (2013-05-19)

- Removed all occurrences of @override

## Version 0.1.2 (2013-05-17)

- Change in README: contained wrong license (Apache instead of MIT).
- Remove import 'package:meta/meta.dart' in event_bus.dart as it is not needed
  and may cause an error if used as pub package.

## Version 0.1.1 (2013-04-29)

- Minor change in README to fix image links.

## Version 0.1.0 (2013-04-29)

- Initial Version.
