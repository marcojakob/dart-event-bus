library all_tests;

import 'package:unittest/html_enhanced_config.dart';

import 'src/simple_event_bus_test.dart' as simpleEventbus;

main() {
  useHtmlEnhancedConfiguration();
  
  simpleEventbus.main();
}

