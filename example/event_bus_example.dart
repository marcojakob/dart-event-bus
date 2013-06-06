import 'dart:html';

import 'dart:async';
import 'events.dart' as events;

int counterA = 1;
int counterB = 1;

void main() {
  // Initialize the global event bus.
  events.init(new events.EventBus());
  
  // Initialize the listener boxes.
  Listener listener1 = new Listener(query('#listener-1'));
  Listener listener2 = new Listener(query('#listener-2'));
  
  // Init Event fields.
  LabelElement fireLabelA = query('#fire-label-a');
  LabelElement fireLabelB = query('#fire-label-b');
  ButtonElement fireButtonA = query("#fire-button-a");
  ButtonElement fireButtonB = query("#fire-button-b");
  
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

class Listener {
  Element element;
  
  TextAreaElement output;
  
  StreamSubscription<String> subscription;
  
  Listener(this.element) {
    output = element.query('textarea');
    // Init buttons.
    element.query('.listen-a').onClick.listen((_) => listenForEventA());
    element.query('.listen-b').onClick.listen((_) => listenForEventB());
    element.query('.pause').onClick.listen((_) => pause());
    element.query('.resume').onClick.listen((_) => resume());
    element.query('.cancel').onClick.listen((_) => cancel());
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
