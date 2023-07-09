import 'dart:async';
import 'dart:io';

import 'package:amplify_core/amplify_core.dart';
import 'package:jsii_runtime/src/bundled_runtime.dart';
import 'package:jsii_runtime/src/jsii_request.dart';
import 'package:jsii_runtime/src/jsii_response.dart';
import 'package:jsii_runtime/src/state/event.dart';
import 'package:jsii_runtime/src/state/machine.dart';
import 'package:jsii_runtime/src/state/state.dart';
import 'package:meta/meta.dart';

final _builders = <Token, DependencyBuilder>{
  const Token<BundledRuntime>(): (_) => BundledRuntime(),
};

class JsiiRuntime
    extends StateMachineManager<KernelEvent, KernelState, JsiiRuntime> {
  JsiiRuntime._(this._dependencyManager)
      : super(
          {KernelStateMachine.token: KernelStateMachine.new},
          _dependencyManager,
        );

  static final _traceEnabled = switch (_jsiiDebug?.toLowerCase()) {
    null || '' || 'false' || '0' => false,
    _ => true,
  };

  static final _jsiiDebug = Platform.environment['JSII_DEBUG'];

  final DependencyManager _dependencyManager;

  /// Spawns a new JSII runtime process.
  static Future<JsiiRuntime> spawn({
    @visibleForTesting String? runtime,
    @visibleForTesting String? nodeExecutable,
  }) async {
    runtime ??= Platform.environment['JSII_RUNTIME'];
    nodeExecutable ??= Platform.environment['JSII_NODE'];
    final jsiiRuntime = JsiiRuntime._(
      DependencyManager(_builders),
    );
    await jsiiRuntime.acceptAndComplete(
      KernelEvent.init(
        runtime: runtime,
        nodeExecutable: nodeExecutable,
        jsiiDebug: _jsiiDebug,
        traceEnabled: _traceEnabled,
      ),
    );
    return jsiiRuntime;
  }

  @override
  StateMachineToken mapEventToMachine(KernelEvent event) =>
      KernelStateMachine.token;

  /// Sends a request to the JSII runtime.
  Future<JsiiResponse> send(JsiiRequest request) async {
    final state = await acceptAndComplete<KernelReceivedResponse>(
      KernelEvent.request(request),
    );
    return state.response;
  }

  /// Terminates the JSII runtime.
  @override
  Future<void> close() async {
    await acceptAndComplete(const KernelEvent.terminate());
    _dependencyManager.close();
  }
}
