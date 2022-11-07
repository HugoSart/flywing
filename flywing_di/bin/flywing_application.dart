import 'scanner/component_initializer.dart';
import 'scanner/component_provider.dart';
import 'scanner/component_scanner.dart';

class FlywingApplication {

  static void run() {
    final mirrors = ComponentScanner.scan();
    mirrors.forEach(ComponentProvider.registerSingleton);
    ComponentInitializer.initialize();
  }

}
