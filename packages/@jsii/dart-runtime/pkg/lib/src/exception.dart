import 'package:aws_common/aws_common.dart';

/// A recoverable error raised by the JSII runtime.
///
/// See also:
/// - [JsiiError], a nonrecoverable error.
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

/// A nonrecoverable error from the jsii runtime, usually the kernel.
final class JsiiError extends Error {
  JsiiError(this.error);

  final String error;

  @override
  String toString() => 'JsiiError: $error';
}
