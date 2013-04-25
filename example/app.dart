import 'dart:html';

import 'dart:async';
import 'events.dart';

void main() {
  // Create new EventBus.
  EventBus eventBus = new EventBus();
  // Pass the EventBus to the class.
  App app = new App(eventBus);
}

class App {
  int counter1 = 1;
  int counter2 = 1;
  
  /// The injected EventBus.
  EventBus eventBus;
  
  App(this.eventBus) {
    
    InputElement output1 = query("#output_field_1");
    InputElement output2 = query("#output_field_2");
    InputElement output3 = query("#output_field_3");
    InputElement output4 = query("#output_field_4");
    InputElement input1 = query("#input_field1");
    InputElement input2 = query("#input_field2");
    
    
    // -------------------------------------------------
    // Add Event Listeners to the EventBus.
    // -------------------------------------------------
    StreamSubscription<String> subscription1 = eventBus.on(textUpdate1).listen((String text) {
      output1.value = text;
    });
    StreamSubscription<String> subscription2 = eventBus.on(textUpdate1).listen((String text) {
      output2.value = text;
    });
    StreamSubscription<String> subscription3 = eventBus.on(textUpdate2).listen((String text) {
      output3.value = text;
    });
    StreamSubscription<String> subscription4 = eventBus.on(textUpdate2).listen((String text) {
      output4.value = text;
    });
    
    
    // -------------------------------------------------
    // Fire Events whenever a Button is Clicked
    // -------------------------------------------------
    query("#fire_event_button1").onClick.listen((_) {
      eventBus.fire(textUpdate1, input1.value);
      input1.value = '${counter1++}';
    });
    query("#fire_event_button2").onClick.listen((_) {
      eventBus.fire(textUpdate2, input2.value);
      input2.value = '${counter2++}';
    });
    
    
    // -------------------------------------------------
    // Change Stream Subscriptions
    // -------------------------------------------------
    query("#pause_button1").onClick.listen((_) => subscription1.pause());
    query("#resume_button1").onClick.listen((_) => subscription1.resume());
    query("#cancel_button1").onClick.listen((_) => subscription1.cancel());
    query("#pause_button2").onClick.listen((_) => subscription2.pause());
    query("#resume_button2").onClick.listen((_) => subscription2.resume());
    query("#cancel_button2").onClick.listen((_) => subscription2.cancel());
    query("#pause_button3").onClick.listen((_) => subscription3.pause());
    query("#resume_button3").onClick.listen((_) => subscription3.resume());
    query("#cancel_button3").onClick.listen((_) => subscription3.cancel());
    query("#pause_button4").onClick.listen((_) => subscription4.pause());
    query("#resume_button4").onClick.listen((_) => subscription4.resume());
    query("#cancel_button4").onClick.listen((_) => subscription4.cancel());
  }
}
