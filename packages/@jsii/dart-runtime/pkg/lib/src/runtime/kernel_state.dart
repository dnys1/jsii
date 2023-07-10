part of 'jsii_runtime.dart';

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

  const factory KernelState.awaitingRequest([JsiiResponse? lastResponse]) =
      KernelAwaitingRequest;

  const factory KernelState.awaitingResponse(JsiiRequest request) =
      KernelAwaitingResponse;

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
  const KernelAwaitingRequest([this.lastResponse])
      : super(KernelStateType.awaitingRequest);

  final JsiiResponse? lastResponse;

  @override
  List<Object?> get props => [lastResponse];

  @override
  String get runtimeTypeName => 'KernelAwaitingRequest';
}

final class KernelAwaitingResponse extends KernelState {
  const KernelAwaitingResponse(this.request)
      : super(KernelStateType.awaitingResponse);

  /// The request that is currently being processed.
  final JsiiRequest request;

  @override
  List<Object?> get props => [request];

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
