# Changelog

## Version 0.3.0 (2014-09-08)

* BREAKING CHANGE: Changed and simplified the EventBus API. We can now dispatch
  any Dart object as an event. Before, we had to create an EventType for every
  type of event we wanted to fire. Now we can use any class as an event. 
  Listeners can (optionally) filter events by that class.
* Added a way to create a **hierarchical event bus** that filters events by 
  class and their subclasses. This currently only works with classes 
  **extending** other classes and not with **implementing** an interface. 
  We might have to wait for 
  https://code.google.com/p/dart/issues/detail?id=20756 to enable interfaces.
* BREAKING CHANGE: Default to async mode instead of sync. This now matches the 
  of the Dart streams.
* BREAKING CHANGE: Removed LoggingEventBus. Reason is that logging can easily
  be implemented with a event listener that listens for all events and logs
  them.


## Version 0.2.5 (2014-09-03)

* Update example.
* Update readme with new links.
* Update dependencies.


## Version 0.2.4 (2013-11-11)

* Update to dart libraries 0.9.0.


## Version 0.2.3 (2013-09-16)

* Fix issue #8: Add logging of events that flow through event bus


## Version 0.2.2 (2013-09-16)

* Change default of SimpleEventBus to sync (same as factory in EventBus)


## Version 0.2.1 (2013-07-01)

* Fix issue #6: Fire should accept null as data


## Version 0.2.0 (2013-06-06)

* Update to new Dart SDK v0.5.13.1_r23552.
* Using Darts new Stream.broadcast() factory.
* Provide option for synchronous broadcasting of events.
* Update unit tests and example.
* Create demo page.
  
  
## Version 0.1.3 (2013-05-19)

* Removed all occurrences of @override


## Version 0.1.2 (2013-05-17)

* Change in README: contained wrong license (Apache instead of MIT).
* Remove import 'package:meta/meta.dart' in event_bus.dart as it is not needed 
  and may cause an error if used as pub package.


## Version 0.1.1 (2013-04-29)

* Minor change in README to fix image links.


## Version 0.1.0 (2013-04-29)

* Initial Version.