library all_tests;

import 'package:unittest/html_enhanced_config.dart';

import 'event_bus_test.dart' as eventBusTest;
import 'hierarchical_event_bus_test.dart' as hierarchicalEventBusTest;

main() {
  useHtmlEnhancedConfiguration();
  
  eventBusTest.main();
  hierarchicalEventBusTest.main();
}

