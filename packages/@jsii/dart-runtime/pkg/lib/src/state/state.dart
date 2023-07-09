import 'package:amplify_core/amplify_core.dart';
import 'package:jsii_runtime/src/exception.dart';
import 'package:jsii_runtime/src/jsii_response.dart';

enum KernelStateType {
  uninitialized,
  awaitingRequest,
  awaitingResponse,
  failed,
  terminated,
}

sealed class KernelState extends StateMachineState<KernelStateType> {
  const KernelState(this.type);

  const factory KernelState.uninitialized() = KernelUninitialized;

  const factory KernelState.awaitingRequest() = KernelAwaitingRequest;

  const factory KernelState.awaitingResponse() = KernelAwaitingResponse;

  const factory KernelState.failed(
    JsiiException exception,
    StackTrace stackTrace,
  ) = KernelFailed;

  const factory KernelState.terminated(
    Exception exception,
    StackTrace stackTrace,
  ) = KernelTerminated;

  @override
  final KernelStateType type;
}

final class KernelUninitialized extends KernelState {
  const KernelUninitialized() : super(KernelStateType.uninitialized);

  @override
  List<Object?> get props => const [];

  @override
  String get runtimeTypeName => 'KernelUninitialized';
}

final class KernelAwaitingRequest extends KernelState {
  const KernelAwaitingRequest() : super(KernelStateType.awaitingRequest);

  @override
  List<Object?> get props => const [];

  @override
  String get runtimeTypeName => 'KernelAwaitingRequest';
}

final class KernelReceivedResponse extends KernelAwaitingRequest {
  const KernelReceivedResponse(this.response);

  final JsiiResponse response;

  @override
  List<Object?> get props => [response];
}

final class KernelAwaitingResponse extends KernelState {
  const KernelAwaitingResponse() : super(KernelStateType.awaitingResponse);

  @override
  List<Object?> get props => const [];

  @override
  String get runtimeTypeName => 'KernelAwaitingResponse';
}

final class KernelFailed extends KernelState with ErrorState<KernelStateType> {
  const KernelFailed(this.exception, this.stackTrace)
      : super(KernelStateType.failed);

  @override
  final JsiiException exception;

  @override
  final StackTrace stackTrace;

  @override
  List<Object?> get props => [exception, stackTrace];

  @override
  String get runtimeTypeName => 'KernelFailed';
}

final class KernelTerminated extends KernelState
    with ErrorState<KernelStateType> {
  const KernelTerminated(this.exception, this.stackTrace)
      : super(KernelStateType.terminated);

  @override
  final Exception exception;

  @override
  final StackTrace stackTrace;

  @override
  List<Object?> get props => [exception, stackTrace];

  @override
  String get runtimeTypeName => 'KernelTerminated';
}
