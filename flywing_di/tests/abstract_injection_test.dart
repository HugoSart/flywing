import '../bin/annotations/autowired.dart';
import '../bin/annotations/component.dart';
import '../bin/annotations/configuration.dart';
import '../bin/flywing_application.dart';

abstract class AbstractService {
  // empty
}

@Component()
class Service extends AbstractService {

  Service() {
    print('on construct service');
  }

}

@Configuration()
class Entry {

  // Autowired
  final AbstractService service;

  @Autowired()
  Entry(this.service) {
    print('on construct entry');
  }

}

void main() {
  FlywingApplication.run();
}
