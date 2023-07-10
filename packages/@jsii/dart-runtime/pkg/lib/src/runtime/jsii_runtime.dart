import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:amplify_core/amplify_core.dart';
import 'package:async/async.dart';
import 'package:jsii_runtime/src/api/jsii_kernel.dart';
import 'package:jsii_runtime/src/api/jsii_kernel_object.dart';
import 'package:jsii_runtime/src/api/jsii_request.dart';
import 'package:jsii_runtime/src/api/jsii_response.dart';
import 'package:jsii_runtime/src/exception.dart';
import 'package:jsii_runtime/src/jsii_client.dart';
import 'package:jsii_runtime/src/runtime/runtime_loader.dart';
import 'package:jsii_runtime/src/version.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:stack_trace/stack_trace.dart';

part 'kernel_event.dart';
part 'kernel_state.dart';
part 'runtime_exception.dart';

final class JsiiRuntime extends StateMachine<KernelEvent, KernelState,
    KernelEvent, KernelState, JsiiClient> {
  JsiiRuntime(JsiiClient manager) : super(manager, token);

  static const token = StateMachineToken<KernelEvent, KernelState, KernelEvent,
      KernelState, JsiiClient, JsiiRuntime>();

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
        emit(KernelState.awaitingResponse(request));
      case KernelResponseEvent _:
        await _processResponse(event.response);
        emit(KernelState.awaitingRequest(event.response));
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
    return KernelState.failed(JsiiException.from(error), st);
  }

  @override
  String get runtimeTypeName => 'JsiiRuntime';

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

  /// Loads the JSII runtime bundled via the embedded tarball.
  Future<String> _loadBundledRuntime() async {
    logger.debug('Loading bundled JSII runtime...');
    final bundledRuntime = manager.getOrCreate<RuntimeLoader>();
    final extractDir = await bundledRuntime.load();
    final jsiiEntrypoint = p.join(extractDir.path, _jsiiEntrypoint);
    _addTearDown(bundledRuntime.close);
    logger.verbose('Bundled JSII runtime loaded from $jsiiEntrypoint');
    return jsiiEntrypoint;
  }

  static final _whitespace = RegExp(r'\s+');

  // From: https://github.com/aws/jsii/blob/a6b937812d939a5faebbc2ff55d9c323fce51894/packages/%40jsii/java-runtime/project/src/main/java/software/amazon/jsii/JsiiRuntime.java#L338
  Future<void> _spawn(KernelInitEvent init) async {
    final KernelInitEvent(:runtime, :nodeExecutable) = init;
    final (command, args) = switch (runtime) {
      final customRuntime? => () {
          logger.debug('Using custom JSII runtime: $customRuntime');
          return (customRuntime, const <String>[]);
        }(),
      _ => (nodeExecutable, [await _loadBundledRuntime()]),
    };

    // Whether to spawn the Node process in a shell. This is necessary if the
    // runtime path or node executable path contain whitespace.
    final useShellProcess =
        (runtime != null && runtime.contains(_whitespace)) ||
            nodeExecutable.contains(_whitespace);

    logger
      ..debug('Spawning JSII runtime process...')
      ..verbose(
        'Starting child process with args: $command ${args.join()} '
        '(shell: $useShellProcess)',
      );
    _kernel = await Process.start(
      command,
      args,
      runInShell: useShellProcess,
      environment: {
        'JSII_AGENT': 'Dart/${Platform.version}/$packageVersion',
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
              _raiseError(resp);
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
    logger.debug('Kernel initialized');
    unawaited(_listenForResponses());
  }

  /// Listens for responses from the JSII runtime.
  Future<void> _listenForResponses() async {
    await for (final response in _stdout) {
      unawaited(_processResponse(response));
    }
  }

  static final _shaSuffix = RegExp(r'\+[a-z0-9]+$');

  /// Asserts that the JSII runtime version is compatible with this client.
  ///
  /// The JSII runtime version is compatible if the major and minor versions
  /// match exactly, and the patch version is greater than or equal to the
  /// expected patch version.
  // TODO(dnys1): What logic is actually needed here?
  static void _assertVersionCompatible(
    String expectedVersion,
    String actualVersion,
  ) {
    expectedVersion = expectedVersion.replaceAll(_shaSuffix, '');
    actualVersion = actualVersion.replaceAll(_shaSuffix, '');
    if (expectedVersion != actualVersion) {
      throw JsiiError(
        'Expected JSII runtime version $expectedVersion, but found '
        '$actualVersion',
      );
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
          pendingRequest: switch (currentState) {
            KernelAwaitingResponse(:final request) => request,
            _ => null,
          },
        ),
      );

  /// A queue of responses from the JSII runtime.
  late final StreamQueue<JsiiResponse> _responseQueue = StreamQueue(_stdout);

  /// Processes a response from the JSII runtime.
  Future<void> _processResponse(JsiiResponse response) async {
    switch (response) {
      case JsiiErrorResponse _:
        _raiseError(response);
      case JsiiCallbackRequest(:final callback):
        final completion = await _handleCallback(callback);
        return resolve(KernelEvent.request(completion));
      default:
        dispatch(KernelEvent.response(response)).ignore();
    }
  }

  /// Parses and raises an error response from the JSII runtime.
  Never _raiseError(JsiiErrorResponse resp) {
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
          result: JsiiKernelObject(result),
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
