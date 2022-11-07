import 'component_provider.dart';
import 'component_scanner.dart';

class ComponentInitializer {

  static void initialize() {

    // Initialize all components that are needed eagerly
    ComponentProvider.components().forEach((type, provider) {

      // Pre-initialize configuration components
      if (ComponentScanner.isConfiguration(type)) {
        provider.provide();
      }

    });

  }

}
