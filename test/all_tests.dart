library all_tests;

import 'package:unittest/unittest.dart';
import 'package:unittest/interactive_html_config.dart';

import 'event_bus_test.dart' as eventBus;
import 'src/simple_event_bus_test.dart' as simpleEventbus;
import 'src/stream_controller_test.dart' as streamController;


main() {
  useInteractiveHtmlConfiguration();
  
  eventBus.main();
  simpleEventbus.main();
  streamController.main();
}

