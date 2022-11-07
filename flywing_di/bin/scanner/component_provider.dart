import 'dart:mirrors';

import '../exceptions/injection_exception.dart';
import 'component_scanner.dart';

class ComponentProvider {

  static final Map<ClassMirror, Provider> _map = {};

  static void registerSingleton(final ClassMirror mirror) {

    // Pre-checks
    if (!ComponentScanner.isComponent(mirror)) {
      throw InjectionException('Attempt to inject \'${mirror.reflectedType}\' but it\'s not a component.');
    } else if (_map.containsKey(mirror)) {
      return;
    }

    // Register
    print('Registering component: $mirror');
    _map[mirror] = _SingletonProvider(() {
      print('Providing $mirror');

      // List all constructors
      final constructors = List.from(
          mirror.declarations.values.where((declare) {
            return declare is MethodMirror && declare.isConstructor;
          })
      );

      // Check if there is only one constructor
      if (constructors.length > 1) {
        throw InjectionException('Components must only have one constructor');
      } else if (constructors.isEmpty) {
        return mirror.newInstance(Symbol.empty, []);
      } else {
        final constructor = constructors.first;
        if (constructor is MethodMirror) {
          final parameters = constructor.parameters;
          final List<dynamic> args = parameters.map((param) {

            // Get existing provider or pre-register component
            final paramMirror = reflectClass(param.type.reflectedType);
            var provider = providerOf(paramMirror);
            if (provider == null) {
              registerSingleton(paramMirror);
              provider = providerOf(mirror);
            }

            // Check if still null
            if (provider == null) {
              if (param.hasDefaultValue) {
                return param.defaultValue;
              }
              throw InjectionException('Component of type \'${param.type.reflectedType}\' not found.');
            }

            // Get value
            return provider.provide();

          }).toList();
          return mirror.newInstance(constructor.constructorName, args).reflectee;
        }
      }

    });

  }

  static Provider? providerOf(final ClassMirror mirror) {
    if (_map.containsKey(mirror)) {
      return _map[mirror];
    } else {
      final w = _map.keys.where((key) => key.isSubclassOf(mirror));
      if (w.isEmpty) return null;
      return _map[w.first];
    }
  }

  static Map<ClassMirror, Provider> components() {
    return _map;
  }

}

abstract class Provider {
  dynamic provide();
}

class _SingletonProvider extends Provider {
  static dynamic _instance;
  final Function _provider;

  _SingletonProvider(this._provider);

  @override
  dynamic provide() {
    return _instance ??= _provider.call();
  }

}
