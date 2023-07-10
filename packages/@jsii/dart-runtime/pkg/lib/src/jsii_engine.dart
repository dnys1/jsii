import 'dart:async';

import 'package:jsii_runtime/src/api/jsii_kernel_object.dart';
import 'package:jsii_runtime/src/api/jsii_response.dart';
import 'package:jsii_runtime/src/jsii_callback_handler.dart';
import 'package:jsii_runtime/src/jsii_client.dart';
import 'package:jsii_runtime/src/jsii_module.dart';

typedef WeakMap<Key extends Object, Value> = Map<WeakReference<Key>, Value>;

final class JsiiEngine implements JsiiCallbackHandler {
  JsiiEngine(this._client);

  final JsiiClient _client;

  /// jsii object cache.
  final Map<String, JsiiObject> _objects = {};

  /// A map that associates value instances with the [JsiiObjectRef] that
  /// represents them across the jsii process boundary.
  ///
  /// This is a weak hash map so that [JsiiObjectRef] instances can be garbage
  /// collected after all instances they are assigned to are themselves
  /// collected.
  final WeakMap<JsiiObject, JsiiObjectRef> _objectRefs = {};

  /// The modules loaded in the jsii process.
  final Map<String, JsiiModule> _loadedModules = {};

  JsiiObject _expectObject(JsiiObjectRef objRef) {
    return _objects[objRef] ?? (throw StateError('Unknown object reference'));
  }

  Future<JsiiModule> loadModule(JsiiModule module) async {
    if (_loadedModules[module.name] case final module?) {
      return module;
    }

    for (final dependency in module.dependencies) {
      await loadModule(dependency);
    }

    return _loadedModules[module.name] = await _client.loadModule(module);
  }

  T createNativeProxy<T extends JsiiObject>(JsiiObjectRef ref) {
    final object = _objects[ref.byRef];
    return switch (object) {
      T _ => object,
      null => throw ArgumentError.value(ref, 'ref', 'Unknown object reference'),
      _ => throw ArgumentError.value(
          object,
          'object',
          'Object reference does not match requested type ($ref)',
        ),
    };
  }

  @override
  JsiiKernelObject handleCallback(Callback callback) {
    return switch (callback) {
      InvokeCallback(
        :final cbid,
        :final objRef,
        :final method,
        :final cookie,
      ) =>
        _handleInvokeCallback(
          callbackId: cbid,
          objRef: objRef,
          method: method,
          cookie: cookie,
        ),
      GetCallback(
        :final cbid,
        :final objRef,
        :final property,
        :final cookie,
      ) =>
        _handleGetCallback(
          callbackId: cbid,
          objRef: objRef,
          property: property,
          cookie: cookie,
        ),
      SetCallback(
        :final cbid,
        :final objRef,
        :final property,
        :final value,
        :final cookie,
      ) =>
        _handleSetCallback(
          callbackId: cbid,
          objRef: objRef,
          property: property,
          value: value,
          cookie: cookie,
        ),
    };
  }

  JsiiKernelObject _handleInvokeCallback({
    required String callbackId,
    required JsiiObjectRef objRef,
    required String method,
    required String? cookie,
  }) {
    final object = _expectObject(objRef);
    final value = object.descriptor.invokeMethod(method);
    return JsiiKernelObject(value);
  }

  JsiiKernelObject _handleGetCallback({
    required String callbackId,
    required JsiiObjectRef objRef,
    required String property,
    required String? cookie,
  }) {
    final object = _expectObject(objRef);
    final value = object.descriptor.getProperty(property);
    return JsiiKernelObject(value);
  }

  JsiiKernelObject _handleSetCallback({
    required String callbackId,
    required JsiiObjectRef objRef,
    required String property,
    required Object? value,
    required String? cookie,
  }) {
    final object = _expectObject(objRef);
    object.descriptor.setProperty(property, value);
    return JsiiKernelObject(null);
  }
}
