import 'dart:html';

import 'dart:async';
import 'events.dart' as events;
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';

int counterA = 1;
int counterB = 1;

void main() {
  // Init logging.
  initLogging();
  
  // Initialize the global event bus.
  events.init(new events.LoggingEventBus());
  
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
    events.eventBus.fire(events.textUpdateA, 'Received Event A [$counterA]');
    fireLabelA.text = '--> fired [$counterA]';
    counterA++;
    fireButtonA.text = 'Fire Event A [$counterA]';
  });
  fireButtonB.onClick.listen((_) {
    // -------------------------------------------------
    // Fire Event B
    // -------------------------------------------------
    events.eventBus.fire(events.textUpdateB, 'Received Event B [$counterB]');
    fireLabelB.text = '--> fired [$counterB]';
    counterB++;
    fireButtonB.text = 'Fire Event B [$counterB]';
  });
}

initLogging() {
  DateFormat dateFormat = new DateFormat('yyyy.mm.dd HH:mm:ss.SSS');
  
  // Print output to console.
  Logger.root.onRecord.listen((LogRecord r) {
    print('${dateFormat.format(r.time)}\t${r.loggerName}\t[${r.level.name}]:\t${r.message}');
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
      subscription = events.eventBus.on(events.textUpdateA).listen((String text) {
        appendOuput(text);
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
      subscription = events.eventBus.on(events.textUpdateB).listen((String text) {
        appendOuput(text);
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
    output.appendText('$text\n');
    output.scrollTop = output.scrollHeight;
  }
}
