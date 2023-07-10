import 'dart:io';

import 'package:amplify_core/amplify_core.dart';
import 'package:jsii_runtime/src/api/jsii_kernel.dart';
import 'package:jsii_runtime/src/api/jsii_kernel_object.dart';
import 'package:jsii_runtime/src/api/jsii_request.dart';
import 'package:jsii_runtime/src/api/jsii_response.dart';
import 'package:jsii_runtime/src/jsii_module.dart';
import 'package:jsii_runtime/src/runtime/jsii_runtime.dart';
import 'package:jsii_runtime/src/runtime/runtime_loader.dart';
import 'package:meta/meta.dart';

final _builders = <Token, DependencyBuilder>{
  const Token<AWSHttpClient>(): (_) => AWSHttpClient(),
  const Token<RuntimeLoader>(): RuntimeLoader.new,
};

class JsiiClient
    extends StateMachineManager<KernelEvent, KernelState, JsiiClient> {
  JsiiClient._(this._dependencyManager)
      : super(
          {JsiiRuntime.token: JsiiRuntime.new},
          _dependencyManager,
        );

  static final _traceEnabled = switch (_jsiiDebug?.toLowerCase()) {
    null || '' || 'false' || '0' => false,
    _ => true,
  };

  static final _jsiiDebug = Platform.environment['JSII_DEBUG'];

  final DependencyManager _dependencyManager;

  /// Spawns a new JSII runtime process and returns a [JsiiClient] that can be
  /// used to communicate with it.
  static Future<JsiiClient> start({
    @visibleForTesting String? runtime,
    @visibleForTesting String? nodeExecutable,
  }) async {
    runtime ??= Platform.environment['JSII_RUNTIME'];
    nodeExecutable ??= Platform.environment['JSII_NODE'];
    final client = JsiiClient._(
      DependencyManager(_builders),
    );
    await client.acceptAndComplete(
      KernelEvent.init(
        runtime: runtime,
        nodeExecutable: nodeExecutable,
        jsiiDebug: _jsiiDebug,
        traceEnabled: _traceEnabled,
      ),
    );
    return client;
  }

  @override
  StateMachineToken mapEventToMachine(KernelEvent event) => JsiiRuntime.token;

  /// Loads a JavaScript module into the remote sandbox.
  Future<JsiiModule> loadModule(JsiiModule module) async {
    final JsiiModule(:name, :version, :tarball) = module;
    final request = JsiiRequest.load(
      name: name,
      version: version,
      tarball: tarball,
    );
    await send<JsiiLoadResponse>(request);
    return module; // TODO(dnys1): More info from response?
  }

  Future<JsiiObjectRef> createObject({
    required JsiiFqn fqn,
    List<Object?>? args,
    List<JsiiFqn>? interfaces,
    List<Override>? overrides,
  }) async {
    final request = JsiiRequest.create(
      fqn: fqn,
      args: args?.map(JsiiKernelObject.new).toList(),
      interfaces: interfaces,
      overrides: overrides,
    );
    final response = await send<JsiiCreateResponse>(request);
    return response.objRef;
  }

  Future<void> deleteObject(JsiiObjectRef object) async {
    final request = JsiiRequest.delete(objRef: object);
    await send<JsiiDeleteResponse>(request);
  }

  Future<Object?> getPropertyValue(
    JsiiObjectRef object,
    String property,
  ) async {
    final request = JsiiRequest.get(
      objRef: object,
      property: property,
    );
    final response = await send<JsiiGetResponse>(request);
    return response.result.value;
  }

  Future<void> setPropertyValue(
    JsiiObjectRef object,
    String property,
    Object? value,
  ) async {
    final request = JsiiRequest.set(
      objRef: object,
      property: property,
      value: JsiiKernelObject(value),
    );
    await send<JsiiSetResponse>(request);
  }

  Future<Object?> getStaticPropertyValue(JsiiFqn fqn, String property) async {
    final request = JsiiRequest.staticGet(
      fqn: fqn,
      property: property,
    );
    final response = await send<JsiiGetResponse>(request);
    return response.result.value;
  }

  Future<void> setStaticPropertyValue(
    JsiiFqn fqn,
    String property,
    Object? value,
  ) async {
    final request = JsiiRequest.staticSet(
      fqn: fqn,
      property: property,
      value: JsiiKernelObject(value),
    );
    await send<JsiiSetResponse>(request);
  }

  Future<Object?> callStaticMethod(
    JsiiFqn fqn,
    String method, {
    List<Object?>? args,
  }) async {
    final request = JsiiRequest.staticInvoke(
      fqn: fqn,
      method: method,
      args: args?.map(JsiiKernelObject.new).toList(),
    );
    final response = await send<JsiiInvokeResponse>(request);
    return response.result.value;
  }

  Future<Object?> callMethod(
    JsiiObjectRef objRef,
    String method, {
    List<Object?>? args,
  }) async {
    final request = JsiiRequest.invoke(
      objRef: objRef,
      method: method,
      args: args?.map(JsiiKernelObject.new).toList(),
    );
    final response = await send<JsiiInvokeResponse>(request);
    return response.result.value;
  }

  Future<Object?> callAsyncMethod(
    JsiiObjectRef objRef,
    String method, {
    List<Object?>? args,
  }) async {
    final request = JsiiRequest.beginAsync(
      objRef: objRef,
      method: method,
      args: args?.map(JsiiKernelObject.new).toList(),
    );
    final response = await send<JsiiBeginResponse>(request);
    final promiseId = response.promiseId;
    final result = await send<JsiiEndResponse>(
      JsiiRequest.endAsync(
        promiseId: promiseId,
      ),
    );
    return result.result.value;
  }

  Future<List<Callback>> listPendingCallbacks() async {
    final response = await send<JsiiCallbacksResponse>(
      const JsiiRequest.callbacks(),
    );
    return response.callbacks;
  }

  Future<void> completeCallbackSuccess(
    Callback callback,
    Object? result,
  ) async {
    final request = JsiiRequest.callbackSuccess(
      cbid: callback.cbid,
      result: JsiiKernelObject(result),
    );
    // await send<Jsii>(request);
  }

  Future<Map<String, Map<String, Object?>>> listModuleNames(
    String moduleName,
  ) async {
    final response = await send<JsiiNamingResponse>(
      JsiiRequest.naming(assembly: moduleName),
    );
    // TODO(dnys1): Pull Dart naming out of the response?
    return response.naming;
  }

  /// Sends a request to the JSII runtime.
  @protected
  Future<Response> send<Response extends JsiiResponse>(
    JsiiRequest request,
  ) async {
    final KernelAwaitingRequest(lastResponse: response) =
        await acceptAndComplete(KernelEvent.request(request));
    return switch (response) {
      Response _ => response,
      _ => throw StateError('Received unexpected response type: $response'),
    };
  }

  /// Terminates the JSII runtime.
  @override
  Future<void> close() async {
    await acceptAndComplete(const KernelEvent.terminate());
    _dependencyManager.close();
  }
}
