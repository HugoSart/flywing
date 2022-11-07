class InjectionException extends Error {
  final String? msg;

  InjectionException([this.msg]);

  @override
  String toString() {
    return msg ?? '';
  }

}
