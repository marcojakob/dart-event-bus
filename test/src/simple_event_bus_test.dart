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
    eventBus = new SimpleEventBus();
  });
  
  test('on_MultipleEvents_HasMultipleStreamControllers', () {
    // when
    eventBus.on(stringEvent1);
    eventBus.on(stringEvent2);
    eventBus.on(intEvent1);
    eventBus.on(intEvent2);
    
    // then
    expect(eventBus.streamControllers, hasLength(4));
  });
  
  test('on_MultipleTimesForOneEvent_HasOneStreamController', () {
    // when
    eventBus.on(stringEvent1);
    eventBus.on(stringEvent1);
    
    // then
    expect(eventBus.streamControllers, hasLength(1));
  });
  
  test('on_AddMultipleListenersForOneEvent_BroadcastStreamAndNoError', () {
    // when
    eventBus.on(stringEvent1).listen((_) => null);
    eventBus.on(stringEvent1).listen((_) => null);
    
    // then
    expect(eventBus.streamControllers[stringEvent1].stream.isBroadcast, isTrue);
  });
  
  test('on_CancelSubscriptionForEvent_StreamControllerIsDeleted', () {
    // given
    StreamSubscription subscription = eventBus.on(stringEvent1).listen((_) => null);
    
    // when
    subscription.cancel();
    
    // then
    expect(eventBus.streamControllers[stringEvent1], isNull);
  });
  
  test('on_CancelSubscriptionAndAddNewListener_HasValidStreamController', () {
    // given
    StreamSubscription subscription = eventBus.on(stringEvent1).listen((_) => null);
    
    // when
    subscription.cancel();
    eventBus.on(stringEvent1).listen((_) => null);
    
    // then
    expect(eventBus.streamControllers[stringEvent1], isNotNull);
  });
  
  test('on_CancelOneSubscriptionForEventWithTwoListeners_StreamControllerIsNotDeleted', () {
    // given
    StreamSubscription subscription = eventBus.on(stringEvent1).listen((_) => null);
    eventBus.on(stringEvent1).listen((_) => null);
    
    // when
    subscription.cancel();
    
    // then
    expect(eventBus.streamControllers[stringEvent1], isNotNull);
  });
  
  test('on_CancelTwoSubscriptionForEventWithTwoListeners_StreamControllerIsDeleted', () {
    // given
    StreamSubscription subscription1 = eventBus.on(stringEvent1).listen((_) => null);
    StreamSubscription subscription2 = eventBus.on(stringEvent1).listen((_) => null);
    
    // when
    subscription1.cancel();
    subscription2.cancel();
    
    // then
    expect(eventBus.streamControllers[stringEvent1], isNull);
  });
  
  test('fire_OneListener_FiresEvent', () {
    // given
    var callbackArgument;
    Function callback = expectAsync1((arg) => callbackArgument = arg);
    eventBus.on(stringEvent1).listen(callback);
    
    // when
    eventBus.fire(stringEvent1, 'Hello Event');
    
    // then
    expect(callbackArgument, equals('Hello Event'));
  });
  
  test('fire_MultipleListeners_FiresEventOnAllListeners', () {
    // given
    var callbackArgument;
    Function callback1 = expectAsync1((arg) => callbackArgument = arg);
    Function callback2 = expectAsync1((_) => null);
    eventBus.on(stringEvent1).listen(callback1);
    eventBus.on(stringEvent1).listen(callback2);
    
    // when
    eventBus.fire(stringEvent1, 'Hello Event');
    
    // then
    expect(callbackArgument, equals('Hello Event'));
  });
  
  test('fire_TwoTimes_FiresTwoTimes', () {
    // given
    Function callback = expectAsync1((_) => null, count: 2);
    eventBus.on(stringEvent1).listen(callback);
    
    // when
    eventBus.fire(stringEvent1, 'Hello Event');
    eventBus.fire(stringEvent1, 'Hello Event2');
  });
  
  test('fire_AfterPause_EventFiresNot', () {
    // given
    Function callback = expectAsync1((_) => null, count: 0);
    StreamSubscription subscription = eventBus.on(stringEvent1).listen(callback);
    
    // when
    subscription.pause();
    eventBus.fire(stringEvent1, 'Hello Event');
    subscription.resume();
  });
  
  test('fire_TwoListenersOnePause_EventFiresNot', () {
    // given
    Function callback1 = expectAsync1((_) => null, count: 0);
    Function callback2 = expectAsync1((_) => null, count: 0);
    StreamSubscription subscription1 = eventBus.on(stringEvent1).listen(callback1);
    StreamSubscription subscription2 = eventBus.on(stringEvent1).listen(callback2);
    
    // when
    subscription1.pause();
    eventBus.fire(stringEvent1, 'Hello Event');
    subscription1.resume();
  });
  
  test('fire_WrongDataType_ThrowsError', () {
    expect(() => eventBus.fire(stringEvent1, 22), throwsArgumentError);
  });
});
}











