import 'dart:async';
import 'dart:html';

import 'package:logging/logging.dart';

import 'events.dart';

int counterA = 1;
int counterB = 1;

final _log = Logger('event_bus_example');

void main() {
  // Init logging.
  initLogging();

  // Log all events.
  eventBus
      .on()
      .listen((event) => _log.finest('event fired:  ${event.runtimeType}'));

  // Initialize the listener boxes.
  Listener(querySelector('#listener-1')!);
  Listener(querySelector('#listener-2')!);

  // Init Event fields.
  LabelElement fireLabelA = querySelector('#fire-label-a') as LabelElement;
  LabelElement fireLabelB = querySelector('#fire-label-b') as LabelElement;
  ButtonElement fireButtonA = querySelector("#fire-button-a") as ButtonElement;
  ButtonElement fireButtonB = querySelector("#fire-button-b") as ButtonElement;

  fireButtonA.onClick.listen((_) {
    // -------------------------------------------------
    // Fire Event A
    // -------------------------------------------------
    eventBus.fire(MyEventA('Received Event A [$counterA]'));
    fireLabelA.text = '--> fired [$counterA]';
    counterA++;
  });
  fireButtonB.onClick.listen((_) {
    // -------------------------------------------------
    // Fire Event B
    // -------------------------------------------------
    eventBus.fire(MyEventB('Received Event B [$counterB]'));
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

  late final TextAreaElement output;

  StreamSubscription? subscription;

  Listener(this.element) {
    output = element.querySelector('textarea') as TextAreaElement;
    // Init buttons.
    element.querySelector('.listen-a')!.onClick.listen((_) => listenForEventA());
    element.querySelector('.listen-b')!.onClick.listen((_) => listenForEventB());
    element.querySelector('.pause')!.onClick.listen((_) => pause());
    element.querySelector('.resume')!.onClick.listen((_) => resume());
    element.querySelector('.cancel')!.onClick.listen((_) => cancel());
  }

  void listenForEventA() {
    if (subscription != null) {
      appendOuput('Already listening for an event.');
    } else {
      // -------------------------------------------------
      // Listen for Event A
      // -------------------------------------------------
      subscription = eventBus.on<MyEventA>().listen((event) {
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
      subscription = eventBus.on<MyEventB>().listen((MyEventB event) {
        appendOuput(event.text);
      });
      appendOuput('---');
      appendOuput('Listening for Event B');
      appendOuput('---');
    }
  }

  void pause() {
    if (subscription != null) {
      subscription!.pause();
      appendOuput('Subscription paused.');
    } else {
      appendOuput('No subscription, cannot pause!');
    }
  }

  void resume() {
    if (subscription != null) {
      subscription!.resume();
      appendOuput('Subscription resumed.');
    } else {
      appendOuput('No subscription, cannot resume!');
    }
  }

  void cancel() {
    if (subscription != null) {
      subscription!.cancel();
      subscription = null;
      appendOuput('Subscription canceled.');
    } else {
      appendOuput('No subscription, cannot cancel!');
    }
  }

  void appendOuput(String text) {
    output.value = output.value! + '$text\n';
    output.scrollTop = output.scrollHeight;
  }
}
