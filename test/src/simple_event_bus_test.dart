library simple_event_bus_test;

import 'dart:async';
import 'package:unittest/unittest.dart';

import 'package:event_bus/event_bus.dart';

final EventType<String> stringEvent1 = new EventType<String>();
final EventType<String> stringEvent2 = new EventType<String>();

final EventType<int> intEvent1 = new EventType<int>();
final EventType<int> intEvent2 = new EventType<int>();

main() {
  
group('[SimpleEventBus]', () {

  SimpleEventBus eventBus;  
  
  setUp(() {
    eventBus = new SimpleEventBus(sync: false);
  });
  
  test('on_ListenersForMultipleEvents_HasMultipleStreamControllers', () {
    // when
    eventBus.on(stringEvent1);
    eventBus.on(stringEvent2);
    eventBus.on(intEvent1);
    eventBus.on(intEvent2);
    
    // then
    expect(eventBus.streamControllers, hasLength(4));
  });
  
  test('on_MultipleListenersForOneEvent_HasOneStreamController', () {
    // when
    eventBus.on(stringEvent1);
    eventBus.on(stringEvent1);
    
    // then
    expect(eventBus.streamControllers, hasLength(1));
  });
  
  test('on_AddMultipleListenersForOneEvent_IsBroadcastStreamAndNoError', () {
    // when
    eventBus.on(stringEvent1).listen((_) => null);
    eventBus.on(stringEvent1).listen((_) => null);
    
    // then
    expect(eventBus.streamControllers[stringEvent1].stream.isBroadcast, isTrue);
  });
  
  test('on_CancelSubscriptionForEvent_StreamControllerStillAcceptsEvents', () {
    // given
    StreamSubscription subscription = eventBus.on(stringEvent1).listen((_) => null);
    
    // when
    subscription.cancel();
    eventBus.fire(stringEvent1, 'aaaaa');
    
    // then
    expect(eventBus.streamControllers[stringEvent1], isNotNull);
    expect(eventBus.streamControllers[stringEvent1].hasListener, isFalse);
    expect(eventBus.streamControllers[stringEvent1].isClosed, isFalse);
  });
  
  test('on_CancelSubscriptionAndAddNewListener_ReceivesEvents', () {
    // then
    Function callback = expectAsync1((arg) => expect(arg, equals('aaaaa')));
    
    // given
    StreamSubscription subscription = eventBus.on(stringEvent1).listen((_) => null);
    
    // when
    subscription.cancel();
    eventBus.on(stringEvent1).listen(callback);
    eventBus.fire(stringEvent1, 'aaaaa');
  });
  
  test('on_CancelOneSubscriptionForEventWithTwoListeners_OtherListenerReceivesEvents', () {
    // then
    Function callback = expectAsync1((arg) => expect(arg, equals('aaaaa')));
    
    // given
    StreamSubscription subscription1 = eventBus.on(stringEvent1).listen((_) => null);
    StreamSubscription subscription2 = eventBus.on(stringEvent1).listen(callback);
    
    // when
    subscription1.cancel();
    eventBus.fire(stringEvent1, 'aaaaa');
  });
  
  test('fire_OneListener_ReceivesEvent', () {
    // then
    Function callback = expectAsync1((arg) =>expect(arg, equals('Hello Event')));
    
    // given
    eventBus.on(stringEvent1).listen(callback);
    
    // when
    eventBus.fire(stringEvent1, 'Hello Event');
  });
  
  test('fire_MultipleListeners_AllListenersReceiveTheEvent', () {
    // then
    Function callback1 = expectAsync1((arg) => expect(arg, equals('Hello Event')));
    Function callback2 = expectAsync1((arg) => expect(arg, equals('Hello Event')));
    
    // given
    eventBus.on(stringEvent1).listen(callback1);
    eventBus.on(stringEvent1).listen(callback2);
    
    // when
    eventBus.fire(stringEvent1, 'Hello Event');
  });
  
  test('fire_TwoTimes_ListenerReceivesTwoEvents', () {
    // then
    Function callback = expectAsync1((_) => null, count: 2);
    
    // given
    eventBus.on(stringEvent1).listen(callback);
    
    // when
    eventBus.fire(stringEvent1, 'Hello Event');
    eventBus.fire(stringEvent1, 'Hello Event2');
  });
  
  test('fire_WhenSubscriptionPaused_ListenerDoesNotReceiveEvent', () {
    // then
    Function callback = expectAsync1((_) => null, count: 0);
    
    // given
    StreamSubscription subscription = eventBus.on(stringEvent1).listen(callback);
    
    // when
    subscription.pause();
    eventBus.fire(stringEvent1, 'Hello Event');
  });
  
  test('fire_WhenSubscriptionPausedAndResumed_ListenerReceivesCachedEvent', () {
    // then
    Function callback = expectAsync1((arg) => expect(arg, equals('Hello Event')));
    
    // given
    StreamSubscription subscription = eventBus.on(stringEvent1).listen(callback);
    
    // when
    subscription.pause();
    eventBus.fire(stringEvent1, 'Hello Event');
    subscription.resume();
  });
  
  test('fire_TwoListenersOnePaused_OtherListenerReceivesEvents', () {
    // then
    Function callback1 = expectAsync1((_) => null, count: 0);
    Function callback2 = expectAsync1((arg) => expect(arg, equals('Hello Event')));
    
    // given
    StreamSubscription subscription1 = eventBus.on(stringEvent1).listen(callback1);
    StreamSubscription subscription2 = eventBus.on(stringEvent1).listen(callback2);
    
    // when
    subscription1.pause();
    eventBus.fire(stringEvent1, 'Hello Event');
  });
  
  test('fire_WrongDataType_ThrowsError', () {
    expect(() => eventBus.fire(stringEvent1, 22), throwsArgumentError);
  });
  
  test('fire_NullAsData_NoError', () {
    try {
      eventBus.fire(stringEvent1, null);
    } catch (e) {
      fail('Should not throw error: $e');
    }
  });
});
}











