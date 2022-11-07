import '../bin/annotations/autowired.dart';
import '../bin/annotations/component.dart';
import '../bin/annotations/configuration.dart';
import '../bin/flywing_application.dart';
import 'abstract_injection_test.dart';

abstract class AbstractService {
  // empty
}

@Component()
class Service1 extends AbstractService {

  Service1() {
    print('on construct service1');
  }

}

@Component()
class Service2 extends AbstractService {

  Service2() {
    print('on construct service2');
  }

}

@Configuration()
class Entry {

  // Autowired
  final List<AbstractService> services;

  @Autowired()
  Entry(this.services) {
    print('on construct entry');
  }

}

void main() {
  FlywingApplication.run();
}
