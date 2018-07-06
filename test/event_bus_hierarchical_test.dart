import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:test/test.dart';

class EventA extends SuperEvent {
  String text;

  EventA(this.text);
}

class EventB extends SuperEvent {
  String text;

  EventB(this.text);
}

class SuperEvent {}

main() {
  group('[EventBus] (hierarchical)', () {
    test('Listen on same class', () {
      // given
      EventBus eventBus = new EventBus();
      Future f = eventBus.on<EventA>().toList();

      // when
      eventBus.fire(new EventA('a1'));
      eventBus.fire(new EventB('b1'));
      eventBus.destroy();

      // then
      return f.then((events) {
        expect(events.length, 1);
      });
    });

    test('Listen on superclass', () {
      // given
      EventBus eventBus = new EventBus();
      Future f = eventBus.on<SuperEvent>().toList();

      // when
      eventBus.fire(new EventA('a1'));
      eventBus.fire(new EventB('b1'));
      eventBus.destroy();

      // then
      return f.then((events) {
        expect(events.length, 2);
      });
    });
  });
}
