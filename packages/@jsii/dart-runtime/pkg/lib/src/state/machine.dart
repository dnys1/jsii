import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:amplify_core/amplify_core.dart';
import 'package:async/async.dart';
import 'package:jsii_runtime/src/bundled_runtime.dart';
import 'package:jsii_runtime/src/exception.dart';
import 'package:jsii_runtime/src/jsii_kernel.dart';
import 'package:jsii_runtime/src/jsii_request.dart';
import 'package:jsii_runtime/src/jsii_response.dart';
import 'package:jsii_runtime/src/jsii_runtime.dart';
import 'package:jsii_runtime/src/state/event.dart';
import 'package:jsii_runtime/src/state/state.dart';
import 'package:jsii_runtime/src/version.dart';
import 'package:path/path.dart' as p;
import 'package:stack_trace/stack_trace.dart';

final class KernelStateMachine extends StateMachine<KernelEvent, KernelState,
    KernelEvent, KernelState, JsiiRuntime> {
  KernelStateMachine(JsiiRuntime manager) : super(manager, token);

  static const token = StateMachineToken<KernelEvent, KernelState, KernelEvent,
      KernelState, JsiiRuntime, KernelStateMachine>();

  @override
  KernelState get initialState => const KernelState.uninitialized();

  @override
  Future<void> resolve(KernelEvent event) async {
    switch (event) {
      case KernelInitEvent _:
        await _spawn(event);
        emit(const KernelState.awaitingRequest());
      case KernelRequestEvent(:final request):
        await _send(request);
        emit(const KernelState.awaitingResponse());
      case KernelResponseEvent _:
        await _processResponse(event.response);
        emit(const KernelState.awaitingRequest());
      case KernelTerminateEvent _:
        await close();
        emit(
          KernelState.terminated(
            Exception('Kernel terminated normally'),
            StackTrace.empty,
          ),
        );
    }
  }

  @override
  KernelState? resolveError(Object error, StackTrace st) {
    throw UnimplementedError();
  }

  @override
  String get runtimeTypeName => 'KernelStateMachine';

  final List<Future<void> Function()> _tearDowns = [];
  void _addTearDown(Future<void> Function() tearDown) {
    _tearDowns.add(tearDown);
  }

  /// The underlying JSII runtime process.
  ///
  /// Initialized in [_spawn] as part of the [KernelInitEvent] flow.
  late final Process _kernel;

  /// The relative path to the JSII runtime entrypoint.
  static final _jsiiEntrypoint = p.join('bin', 'jsii-runtime.js');

  Future<void> _spawn(KernelInitEvent init) async {
    final bundledRuntime = manager.getOrCreate<BundledRuntime>();
    final extractDir = await bundledRuntime.load();
    final jsiiEntrypoint = p.join(extractDir.path, _jsiiEntrypoint);
    _addTearDown(bundledRuntime.close);
    _kernel = await Process.start(
      init.nodeExecutable ?? 'node',
      [jsiiEntrypoint],
      runInShell: true,
      environment: {
        'JSII_AGENT': 'Dart/$packageVersion',
        if (init.jsiiDebug case final jsiiDebug?) 'JSII_DEBUG': jsiiDebug,
      },
    );
    await _init();
  }

  /// Initializes the kernel by waiting for the first response.
  Future<void> _init() async {
    final completer = Completer<void>();
    final timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timer.tick > 10) {
        return completer.completeError(
          TimeoutException('Timed out waiting for kernel to initialize'),
        );
      }
      logger.debug('Waiting for kernel to initialize...');
    });
    unawaited(
      Future(() async {
        try {
          final resp = await _responseQueue.next;
          switch (resp) {
            case JsiiHelloResponse _:
              return;
            case JsiiErrorResponse _:
              _handleError(resp);
            default:
              throw StateError('Unexpected initial response: $resp');
          }
        } on Object catch (e, st) {
          return completer.completeError(e, st);
        } finally {
          timer.cancel();
        }
      }),
    );
    await completer.future;
    unawaited(_listenForResponses());
  }

  /// Listens for responses from the JSII runtime.
  Future<void> _listenForResponses() async {
    await for (final _ in _stdout) {
      throw UnimplementedError();
    }
  }

  /// The input stream to the JSII runtime.
  IOSink get _stdin => _kernel.stdin;

  /// The output stream from the JSII runtime.
  late final Stream<JsiiResponse> _stdout = _kernel.stdout
      .asBroadcastStream()
      .transform(utf8.decoder)
      .transform(const LineSplitter())
      .map(
        (line) => JsiiResponse.fromKernel(
          line,
          pendingRequest: _pendingRequest,
        ),
      );

  /// A queue of responses from the JSII runtime.
  late final StreamQueue<JsiiResponse> _responseQueue = StreamQueue(_stdout);

  /// The active request in the JSII runtime, pending a response.
  JsiiRequest? _pendingRequest;

  /// Processes a response from the JSII runtime.
  Future<void> _processResponse(JsiiResponse response) async {
    switch (response) {
      case JsiiErrorResponse _:
        _handleError(response);
      case JsiiCallbackRequest(:final callback):
        final completion = await _handleCallback(callback);
        return resolve(KernelEvent.request(completion));
      default:
        throw UnimplementedError();
    }
  }

  /// Parses an error response from the JSII runtime.
  Never _handleError(JsiiErrorResponse resp) {
    final JsiiErrorResponse(:name, :error, :stack) = resp;
    final jsiiStack = switch (stack) {
      null => StackTrace.empty,
      _ => StackTrace.fromString(stack),
    };
    Error.throwWithStackTrace(
      switch (name) {
        JsiiKernelTypes.fault => JsiiFaultException(error),
        JsiiKernelTypes.runtimeError => JsiiRuntimeException(error),
        _ => JsiiException.from(error),
      },
      Chain([
        Trace.from(jsiiStack),
        Trace.current(),
      ]),
    );
  }

  /// Handles a callback request from the JSII runtime.
  Future<JsiiCallbackCompletion> _handleCallback(Callback callback) async {
    final result = await Result.capture((() async => null)());
    switch (result) {
      case ValueResult(value: final result):
        return JsiiCallbackSuccessRequest(
          cbid: callback.cbid,
          result: JsonObject(result),
        );
      case ErrorResult(:final error):
        final name = switch (error) {
          JsiiFaultException _ => JsiiKernelTypes.fault,
          JsiiRuntimeException _ || _ => JsiiKernelTypes.runtimeError,
        };
        return JsiiCallbackErrorRequest(
          cbid: callback.cbid,
          name: name,
          error: error.toString(),
        );
      default:
        throw StateError('Unexpected result: $result');
    }
  }

  /// Sends a request to the JSII runtime.
  Future<void> _send(JsiiRequest request) async {
    _stdin.writeln(request);
    await _stdin.flush();
  }

  @override
  Future<void> close() async {
    await _send(const JsiiRequest.exit());
    await _kernel.exitCode;
    await Future.wait(_tearDowns.map((tearDown) => tearDown()));
  }
}
