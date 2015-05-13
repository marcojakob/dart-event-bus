import 'dart:html';

import 'dart:async';
import 'events.dart';
import 'package:logging/logging.dart';

int counterA = 1;
int counterB = 1;

final _log = new Logger('event_bus_example');

void main() {
  // Init logging.
  initLogging();

  // Log all events.
  eventBus.on().listen((event) => _log.finest('event fired:  ${event.runtimeType}'));


  // Initialize the listener boxes.
  Listener listener1 = new Listener(querySelector('#listener-1'));
  Listener listener2 = new Listener(querySelector('#listener-2'));

  // Init Event fields.
  LabelElement fireLabelA = querySelector('#fire-label-a');
  LabelElement fireLabelB = querySelector('#fire-label-b');
  ButtonElement fireButtonA = querySelector("#fire-button-a");
  ButtonElement fireButtonB = querySelector("#fire-button-b");

  fireButtonA.onClick.listen((_) {
    // -------------------------------------------------
    // Fire Event A
    // -------------------------------------------------
    eventBus.fire(new MyEventA('Received Event A [$counterA]'));
    fireLabelA.text = '--> fired [$counterA]';
    counterA++;
  });
  fireButtonB.onClick.listen((_) {
    // -------------------------------------------------
    // Fire Event B
    // -------------------------------------------------
    eventBus.fire(new MyEventB('Received Event B [$counterB]'));
    fireLabelB.text = '--> fired [$counterB]';
    counterB++;
  });
}

initLogging() {
  // Print output to console.
  Logger.root.onRecord.listen((LogRecord r) {
    print('${r.time}\t${r.loggerName}\t[${r.level.name}]:\t${r.message}');
  });

  // Root logger level.
  Logger.root.level = Level.FINEST;
}

class Listener {
  Element element;

  TextAreaElement output;

  StreamSubscription<String> subscription;

  Listener(this.element) {
    output = element.querySelector('textarea');
    // Init buttons.
    element.querySelector('.listen-a').onClick.listen((_) => listenForEventA());
    element.querySelector('.listen-b').onClick.listen((_) => listenForEventB());
    element.querySelector('.pause').onClick.listen((_) => pause());
    element.querySelector('.resume').onClick.listen((_) => resume());
    element.querySelector('.cancel').onClick.listen((_) => cancel());
  }

  void listenForEventA() {
    if (subscription != null) {
      appendOuput('Already listening for an event.');
    } else {
      // -------------------------------------------------
      // Listen for Event A
      // -------------------------------------------------
      subscription = eventBus.on(MyEventA).listen((event) {
        appendOuput(event.text);
      });
      appendOuput('---');
      appendOuput('Listening for Event A');
      appendOuput('---');
    }
  }

  void listenForEventB() {
    if (subscription != null) {
      appendOuput('Already listening for an event.');
    } else {
      // -------------------------------------------------
      // Listen for Event B
      // -------------------------------------------------
      subscription = eventBus.on(MyEventB).listen((MyEventB event) {
        appendOuput(event.text);
      });
      appendOuput('---');
      appendOuput('Listening for Event B');
      appendOuput('---');
    }
  }

  void pause() {
    if (subscription != null) {
      subscription.pause();
      appendOuput('Subscription paused.');
    } else {
      appendOuput('No subscription, cannot pause!');
    }
  }

  void resume() {
    if (subscription != null) {
      subscription.resume();
      appendOuput('Subscription resumed.');
    } else {
      appendOuput('No subscription, cannot resume!');
    }
  }

  void cancel() {
    if (subscription != null) {
      subscription.cancel();
      subscription = null;
      appendOuput('Subscription canceled.');
    } else {
      appendOuput('No subscription, cannot cancel!');
    }
  }

  void appendOuput(String text) {
    output.value += '$text\n';
    output.scrollTop = output.scrollHeight;
  }
}
