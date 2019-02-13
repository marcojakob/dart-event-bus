import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:test/test.dart';

class EventA {
  String text;

  EventA(this.text);
}

class EventB {
  String text;

  EventB(this.text);
}

class EventWithMap {
  Map myMap;

  EventWithMap(this.myMap);
}

main() {
  group('[EventBus]', () {
    test('Fire one event', () {
      // given
      EventBus eventBus = new EventBus();
      Future f = eventBus.on<EventA>().toList();

      // when
      eventBus.fire(new EventA('a1'));
      eventBus.destroy();

      // then
      return f.then((events) {
        expect(events.length, 1);
      });
    });

    test('Fire two events of same type', () {
      // given
      EventBus eventBus = new EventBus();
      Future f = eventBus.on<EventA>().toList();

      // when
      eventBus.fire(new EventA('a1'));
      eventBus.fire(new EventA('a2'));
      eventBus.destroy();

      // then
      return f.then((events) {
        expect(events.length, 2);
      });
    });

    test('Fire events of different type', () {
      // given
      EventBus eventBus = new EventBus();
      Future f1 = eventBus.on<EventA>().toList();
      Future f2 = eventBus.on<EventB>().toList();

      // when
      eventBus.fire(new EventA('a1'));
      eventBus.fire(new EventB('b1'));
      eventBus.destroy();

      // then
      return Future.wait([
        f1.then((events) {
          expect(events.length, 1);
        }),
        f2.then((events) {
          expect(events.length, 1);
        })
      ]);
    });

    test('Fire events of different type, receive all types', () {
      // given
      EventBus eventBus = new EventBus();
      Future f = eventBus.on().toList();

      // when
      eventBus.fire(new EventA('a1'));
      eventBus.fire(new EventB('b1'));
      eventBus.fire(new EventB('b2'));
      eventBus.destroy();

      // then
      return f.then((events) {
        expect(events.length, 3);
      });
    });

    test('Fire event with a map type', () {
      // given
      EventBus eventBus = new EventBus();
      Future f = eventBus.on<EventWithMap>().toList();

      // when
      eventBus.fire(new EventWithMap({'a': 'test'}));
      eventBus.destroy();

      // then
      return f.then((events) {
        expect(events.length, 1);
      });
    });
  });
}
