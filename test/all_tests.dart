library all_tests;

import 'package:unittest/unittest.dart';
import 'package:unittest/interactive_html_config.dart';

import 'src/simple_event_bus_test.dart' as simpleEventbus;

main() {
  useInteractiveHtmlConfiguration();
  
  simpleEventbus.main();
}

