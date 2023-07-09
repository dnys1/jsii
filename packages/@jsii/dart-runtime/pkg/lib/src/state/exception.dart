import 'package:amplify_core/amplify_core.dart';

final class KernelPreconditionException implements PreconditionException {
  const KernelPreconditionException(
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
}
