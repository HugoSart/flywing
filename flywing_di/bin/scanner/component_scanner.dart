import 'dart:mirrors';

import '../annotations/component.dart';
import '../annotations/configuration.dart';

class ComponentScanner {

  static List<ClassMirror> scan() {
    final MirrorSystem mirrorSystem = currentMirrorSystem();
    final List<ClassMirror> mirrors = [];
    mirrorSystem.libraries.forEach((lk, l) {
      l.declarations.forEach((dk, d) {
        if (d is ClassMirror) {
          final ClassMirror mirror = d;
          if (isComponent(mirror)) {
            mirrors.add(mirror);
          }
        }
      });
    });
    return mirrors;
  }

  static bool isComponent(final ClassMirror mirror) {
    return mirror.metadata.any((m) => m.type.isSubclassOf(reflectClass(Component)));
  }

  static bool isConfiguration(final ClassMirror mirror) {
    return mirror.metadata.any((m) => m.type.isSubclassOf(reflectClass(Configuration)));
  }

}
