part of 'jsii_runtime.dart';

enum KernelEventType {
  init,
  request,
  response,
  terminate,
}

sealed class KernelEvent
    extends StateMachineEvent<KernelEventType, KernelStateType> {
  const KernelEvent(this.type);

  const factory KernelEvent.init({
    required String? runtime,
    required String? nodeExecutable,
    required String? jsiiDebug,
    required bool traceEnabled,
  }) = KernelInitEvent;

  const factory KernelEvent.request(JsiiRequest request) = KernelRequestEvent;

  const factory KernelEvent.response(JsiiResponse response) =
      KernelResponseEvent;

  const factory KernelEvent.terminate() = KernelTerminateEvent;

  @override
  @mustCallSuper
  PreconditionException? checkPrecondition(KernelState currentState) {
    switch (currentState) {
      case KernelTerminated _:
        return const RuntimePreconditionException(
          'Cannot transition from terminated state',
        );
      default:
        return null;
    }
  }

  @override
  final KernelEventType type;
}

final class KernelInitEvent extends KernelEvent {
  const KernelInitEvent({
    required this.runtime,
    required String? nodeExecutable,
    required this.jsiiDebug,
    required this.traceEnabled,
  })  : nodeExecutable = nodeExecutable ?? 'node',
        super(KernelEventType.init);

  final String? runtime;
  final String nodeExecutable;
  final String? jsiiDebug;
  final bool traceEnabled;

  @override
  PreconditionException? checkPrecondition(KernelState currentState) {
    if (super.checkPrecondition(currentState) case final exception?) {
      return exception;
    }
    return switch (currentState) {
      KernelUninitialized _ => null,
      _ => const RuntimePreconditionException(
          'The kernel has already been initialized',
          shouldEmit: false,
        ),
    };
  }

  @override
  List<Object?> get props => [
        runtime,
        nodeExecutable,
        jsiiDebug,
        traceEnabled,
      ];

  @override
  String get runtimeTypeName => 'KernelInit';
}

final class KernelRequestEvent extends KernelEvent {
  const KernelRequestEvent(this.request) : super(KernelEventType.request);

  final JsiiRequest request;

  @override
  PreconditionException? checkPrecondition(KernelState currentState) {
    if (super.checkPrecondition(currentState) case final exception?) {
      return exception;
    }
    return switch (currentState) {
      KernelAwaitingRequest _ => null,
      _ => const RuntimePreconditionException(
          'The kernel cannot accept requests at this time',
        ),
    };
  }

  @override
  List<Object?> get props => [request];

  @override
  String get runtimeTypeName => 'KernelRequest';
}

final class KernelResponseEvent extends KernelEvent {
  const KernelResponseEvent(this.response) : super(KernelEventType.response);

  final JsiiResponse response;

  @override
  List<Object?> get props => [response];

  @override
  String get runtimeTypeName => 'KernelResponse';
}

final class KernelTerminateEvent extends KernelEvent {
  const KernelTerminateEvent() : super(KernelEventType.terminate);

  @override
  PreconditionException? checkPrecondition(KernelState currentState) {
    return switch (currentState) {
      KernelTerminated _ => const RuntimePreconditionException(
          'The kernel has already been terminated',
          shouldEmit: false,
        ),
      _ => super.checkPrecondition(currentState),
    };
  }

  @override
  List<Object?> get props => const [];

  @override
  String get runtimeTypeName => 'KernelTerminate';
}
