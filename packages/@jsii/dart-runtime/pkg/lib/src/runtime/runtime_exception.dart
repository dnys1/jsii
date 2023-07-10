part of 'jsii_runtime.dart';

final class RuntimePreconditionException
    with AWSSerializable<Map<String, Object?>>, AWSDebuggable
    implements PreconditionException {
  const RuntimePreconditionException(
    this.precondition, {
    this.shouldEmit = true,
    this.shouldLog = true,
  });

  @override
  final String precondition;

  @override
  final bool shouldEmit;

  @override
  final bool shouldLog;

  @override
  String get runtimeTypeName => 'RuntimePreconditionException';

  @override
  Map<String, Object?> toJson() => {
        'precondition': precondition,
        'shouldEmit': shouldEmit,
        'shouldLog': shouldLog,
      };
}
