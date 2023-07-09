import 'package:aws_common/aws_common.dart';

abstract base class JsiiException
    with AWSSerializable<Map<String, Object?>>, AWSDebuggable
    implements Exception {
  const JsiiException(this.error);

  factory JsiiException.from(Object error) {
    return switch (error) {
      JsiiException _ => error,
      _ => UnknownJsiiException(error.toString()),
    };
  }

  final String error;

  @override
  Map<String, Object?> toJson() => {
        'error': error,
      };

  @override
  String get runtimeTypeName => 'JsiiException';
}

final class JsiiFaultException extends JsiiException {
  const JsiiFaultException(super.error);

  @override
  String get runtimeTypeName => 'JsiiFaultException';
}

final class JsiiRuntimeException extends JsiiException {
  const JsiiRuntimeException(super.error);

  @override
  String get runtimeTypeName => 'JsiiRuntimeException';
}

final class UnknownJsiiException extends JsiiException {
  const UnknownJsiiException(super.error);

  @override
  String get runtimeTypeName => 'UnknownJsiiException';
}
