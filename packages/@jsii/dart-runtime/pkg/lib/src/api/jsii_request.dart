import 'dart:convert';

import 'package:amplify_core/amplify_core.dart';
import 'package:jsii_runtime/src/api/jsii_kernel.dart';
import 'package:jsii_runtime/src/api/jsii_kernel_object.dart';
import 'package:json_annotation/json_annotation.dart';

part 'jsii_request.g.dart';

const _serializable = JsonSerializable(
  explicitToJson: true,
);

/// A request to the JSII kernel.
///
/// See: https://aws.github.io/jsii/specification/3-kernel-api/
sealed class JsiiRequest extends StateMachineEvent<Never, Never>
    with AWSSerializable<Map<String, Object?>> {
  const JsiiRequest(this.api);

  /// Requests the loading of a new assembly into the kernel.
  ///
  /// Before any jsii type can be used, the assembly that provides it must be
  /// loaded into the kernel. Similarly, all dependencies of a given jsii module
  /// must have been loaded into the kernel before the module itself can be
  /// loaded (the `@jsii/kernel` does not perform any kind of dependency
  /// resolution).
  ///
  /// See: https://aws.github.io/jsii/specification/3-kernel-api/#loading-jsii-assemblies-into-the-kernel
  const factory JsiiRequest.load({
    required String name,
    required String version,
    required String tarball,
  }) = JsiiLoadRequest;

  /// Requests the naming information for a given assembly.
  ///
  /// See: https://aws.github.io/jsii/specification/3-kernel-api/#obtaining-naming-information-for-loaded-assemblies
  const factory JsiiRequest.naming({
    required String assembly,
  }) = JsiiNamingRequest;

  /// Requests statistics about the current kernel.
  ///
  /// See: https://aws.github.io/jsii/specification/3-kernel-api/#obtaining-statistics-about-the-kernel-usage
  const factory JsiiRequest.stats() = JsiiStatsRequest;

  /// Creates a new instance of a jsii class.
  ///
  /// See: https://aws.github.io/jsii/specification/3-kernel-api/#creating-objects
  const factory JsiiRequest.create({
    required JsiiFqn fqn,
    List<JsiiKernelObject>? args,
    List<JsiiFqn>? interfaces,
    List<Override>? overrides,
  }) = JsiiCreateRequest;

  /// Deletes an object reference.
  ///
  /// > **WARNING**: The existing host runtime libraries do not implement this
  ///   behavior!
  ///
  /// Once the host app no longer needs a particular object, it can be discarded.
  /// This can happen for example when the host reference to an object is
  /// garbage collected or freed. In order to allow the JavaScript process to
  /// also reclaim the associated memory footprint, the delete API must be used.
  ///
  /// > **WARNING**: Failure to use the del API will result in memory leakage
  ///   as the JavaScript process accumulates garbage in its Kernel instance.
  ///   This can eventually result in a `JavaScript heap out of memory` error,
  ///   and the abnormal termination of the Node process, and consequently of
  ///   the host app.
  ///
  /// > **NOTE**: There is currently no provision for the node process to inform
  ///   the host app about object references it dropped. This mechanism is
  ///   necessary in order to support garbage collection of resources that
  ///   involve host-implemented code (in such cases, the host app must hold on
  ///   to any instance it passed to JavaScript until it is no longer reachable
  ///   from there).
  ///
  /// See: https://aws.github.io/jsii/specification/3-kernel-api/#destroying-objects
  const factory JsiiRequest.delete({
    required JsiiObjectRef objRef,
  }) = JsiiDeleteRequest;

  /// Reports a successful callback execution.
  ///
  /// See: https://aws.github.io/jsii/specification/3-kernel-api/#a-note-about-callbacks
  const factory JsiiRequest.callbackSuccess({
    required String cbid,
    required JsiiKernelObject result,
  }) = JsiiCallbackSuccessRequest;

  /// Reports an error that occurred during the execution of a callback.
  ///
  /// See: https://aws.github.io/jsii/specification/3-kernel-api/#a-note-about-callbacks
  const factory JsiiRequest.callbackError({
    required String cbid,
    required JsiiFqn name,
    required String error,
  }) = JsiiCallbackErrorRequest;

  /// Requests a list of all callbacks that are currently pending.
  ///
  /// See: https://aws.github.io/jsii/specification/3-kernel-api/#a-note-about-callbacks
  const factory JsiiRequest.callbacks() = JsiiCallbacksRequest;

  /// Invokes a method on a jsii object.
  ///
  /// See: https://aws.github.io/jsii/specification/3-kernel-api/#invoking-methods-and-static-methods
  const factory JsiiRequest.invoke({
    required JsiiObjectRef objRef,
    required String method,
    List<JsiiKernelObject>? args,
  }) = JsiiInvokeRequest;

  /// Invokes a static method on a jsii class.
  ///
  /// See: https://aws.github.io/jsii/specification/3-kernel-api/#invoking-methods-and-static-methods
  const factory JsiiRequest.staticInvoke({
    required JsiiFqn fqn,
    required String method,
    List<JsiiKernelObject>? args,
  }) = JsiiStaticInvokeRequest;

  /// Begins an asynchronous method invocation on a jsii object.
  ///
  /// > **NOTE**: All begin calls must be matched with an end call. Failure to
  ///   do so may result in unhandled promise rejections that might cause the
  ///   application to terminate in certain environments.
  ///
  /// The [JsiiRequest.invoke] call can only be used to invoke synchronous
  /// methods. In order to invoke asynchronous methods, the [JsiiRequest.beginAsync]
  /// and [JsiiRequest.endAsync] calls must be used instead. Once the host app
  /// has entered an asynchronous workflow (after it makes the first `begin`
  /// call), and until it has completed all asynchronous operations (after all
  /// begin class are matched with an end call), no synchronous operation
  /// (including synchronous callbacks) may be initiated.
  ///
  /// See: https://aws.github.io/jsii/specification/3-kernel-api/#asynchronous-method-invocation
  const factory JsiiRequest.beginAsync({
    required JsiiObjectRef objRef,
    required String method,
    List<JsiiKernelObject>? args,
  }) = JsiiBeginAsyncRequest;

  /// Ends an asynchronous method invocation on a jsii object.
  ///
  /// See: https://aws.github.io/jsii/specification/3-kernel-api/#asynchronous-method-invocation
  const factory JsiiRequest.endAsync({
    required String promiseId,
  }) = JsiiEndAsyncRequest;

  /// Gets the value of a property on a jsii object.
  ///
  /// See: https://aws.github.io/jsii/specification/3-kernel-api/#invoking-getters-and-static-getters
  const factory JsiiRequest.get({
    required JsiiObjectRef objRef,
    required String property,
  }) = JsiiGetRequest;

  /// Gets the value of a static property on a jsii class.
  ///
  /// Use this when operating on static properties, or in order to obtain the
  /// value of enum constants.
  ///
  /// See: https://aws.github.io/jsii/specification/3-kernel-api/#invoking-getters-and-static-getters
  const factory JsiiRequest.staticGet({
    required JsiiFqn fqn,
    required String property,
  }) = JsiiStaticGetRequest;

  /// Sets the value of a property on a jsii object.
  ///
  /// See: https://aws.github.io/jsii/specification/3-kernel-api/#invoking-setters-and-static-setters
  const factory JsiiRequest.set({
    required JsiiObjectRef objRef,
    required String property,
    required JsiiKernelObject value,
  }) = JsiiSetRequest;

  /// Sets the value of a static property on a jsii class.
  ///
  /// See: https://aws.github.io/jsii/specification/3-kernel-api/#invoking-setters-and-static-setters
  const factory JsiiRequest.staticSet({
    required JsiiFqn fqn,
    required String property,
    required JsiiKernelObject value,
  }) = JsiiStaticSetRequest;

  /// Requests the kernel to exit.
  const factory JsiiRequest.exit([int code]) = JsiiExitRequest;

  /// The name of the API being invoked.
  ///
  /// This is used by the kernel to determine which handler to invoke and serves
  /// as the discriminator for the request.
  final String api;

  @override
  Never get type => throw UnimplementedError();

  @override
  String toString() => jsonEncode(toJson());
}

@_serializable
final class JsiiLoadRequest extends JsiiRequest {
  const JsiiLoadRequest({
    required this.name,
    required this.version,
    required this.tarball,
  }) : super('load');

  factory JsiiLoadRequest.fromJson(Map<String, Object?> json) =>
      _$JsiiLoadRequestFromJson(json);

  /// The name of the assembly being loaded
  final String name;

  /// The version of the assembly being loaded
  final String version;

  /// The local path to the npm package for the assembly
  final String tarball;

  @override
  List<Object?> get props => [name, version, tarball];

  @override
  String get runtimeTypeName => 'JsiiLoadRequest';

  @override
  Map<String, Object?> toJson() => _$JsiiLoadRequestToJson(this);
}

@_serializable
final class JsiiNamingRequest extends JsiiRequest {
  const JsiiNamingRequest({
    required this.assembly,
  }) : super('naming');

  factory JsiiNamingRequest.fromJson(Map<String, Object?> json) =>
      _$JsiiNamingRequestFromJson(json);

  /// The name of the assembly for which naming is requested
  final String assembly;

  @override
  List<Object?> get props => [assembly];

  @override
  String get runtimeTypeName => 'JsiiNamingRequest';

  @override
  Map<String, Object?> toJson() => _$JsiiNamingRequestToJson(this);
}

@_serializable
final class JsiiStatsRequest extends JsiiRequest {
  const JsiiStatsRequest() : super('stats');

  factory JsiiStatsRequest.fromJson(Map<String, Object?> json) =>
      _$JsiiStatsRequestFromJson(json);

  @override
  List<Object?> get props => const [];

  @override
  String get runtimeTypeName => 'JsiiStatsRequest';

  @override
  Map<String, Object?> toJson() => _$JsiiStatsRequestToJson(this);
}

@_serializable
final class JsiiCreateRequest extends JsiiRequest {
  const JsiiCreateRequest({
    required this.fqn,
    this.args,
    this.interfaces,
    this.overrides,
  }) : super('create');

  factory JsiiCreateRequest.fromJson(Map<String, Object?> json) =>
      _$JsiiCreateRequestFromJson(json);

  /// The fully qualified name of the class to instantiate.
  final JsiiFqn fqn;

  /// The arguments to pass to the constructor.
  ///
  /// **Note**: The `Object` type ([JsiiFqn.object]) accepts no arguments.
  final List<JsiiKernelObject>? args;

  /// Additional interfaces implemented in the host app.
  ///
  /// Sometimes, the _host_ app will extend a jsii class and implement new jsii
  /// interfaces that were not present on the original type. Such interfaces
  /// must be declared by providing their jsii fully qualified name as an entry
  /// in the interfaces list.
  ///
  /// Providing interfaces in this list that are implicitly present from another
  /// delcaration (either because they are already implemented by the class
  /// denoted by the [fqn] field, or because another entry in the interfaces list
  /// extends it) is valid, but not necessary. The @jsii/kernel is responsible
  /// for correctly handling redundant declarations.
  ///
  /// > **WARNING**: While declared interfaces may contain redundant declarations
  ///   of members already declared by other interfaces or by the type denoted
  ///   by [fqn], undefined behavior results if any such declaration is not
  ///   identical to the others (e.g: property `foo` declared with type `boolean`
  ///   on one of the interfaces, and with type `string` on another).
  ///
  /// See: https://aws.github.io/jsii/specification/3-kernel-api/#additional-interfaces
  final List<JsiiFqn>? interfaces;

  /// Any methods or property overridden in the host app.
  ///
  /// For any method that is implemented or overridden from the _host_ app, the
  /// create call must specify an [Override] entry. This will inform the Kernel
  /// that calls to these methods must be relayed to the _host_ app for execution,
  /// instead of executing the original library's version.
  ///
  /// See: https://aws.github.io/jsii/specification/3-kernel-api/#overrides
  final List<Override>? overrides;

  @override
  List<Object?> get props => [fqn, args, interfaces, overrides];

  @override
  String get runtimeTypeName => 'JsiiCreateRequest';

  @override
  Map<String, Object?> toJson() => _$JsiiCreateRequestToJson(this);
}

sealed class Override
    with AWSSerializable<Map<String, Object?>>, AWSEquatable<Override> {
  const Override({this.cookie});

  factory Override.fromJson(Map<String, Object?> json) {
    return switch (json) {
      {'method': final String method} => _MethodOverride(
          method: method,
          cookie: json['cookie'] as String?,
        ),
      {'property': final String property} => _PropertyOverride(
          property: property,
          cookie: json['cookie'] as String?,
        ),
      _ => throw ArgumentError.value(json, 'json', 'Invalid override'),
    };
  }

  const factory Override.property({
    required String property,
    required String? cookie,
  }) = _PropertyOverride;

  const factory Override.method({
    required String method,
    required String? cookie,
  }) = _MethodOverride;

  /// An arbitrary override cookie string.
  ///
  /// If provided, this string will be recorded on the JavaScript proxying
  /// implementation, and will be provided to the **host** app with any callback
  /// request. This information can be used, for example, to improve the
  /// performance of implementation lookups in the host app, where the necessary
  /// reflection calls would otherwise be prohibitively expensive.
  ///
  /// See: https://aws.github.io/jsii/specification/3-kernel-api/#overrides
  final String? cookie;
}

@_serializable
final class _PropertyOverride extends Override {
  const _PropertyOverride({
    required this.property,
    super.cookie,
  });

  /// The name of the overridden property
  final String property;

  @override
  List<Object?> get props => [property, cookie];

  @override
  Map<String, Object?> toJson() => _$PropertyOverrideToJson(this);
}

@_serializable
final class _MethodOverride extends Override {
  const _MethodOverride({
    required this.method,
    super.cookie,
  });

  /// The name of the overridden method
  final String method;

  @override
  List<Object?> get props => [method, cookie];

  @override
  Map<String, Object?> toJson() => _$MethodOverrideToJson(this);
}

sealed class JsiiCallbackCompletion extends JsiiRequest {
  const JsiiCallbackCompletion({
    required this.cbid,
  }) : super('complete');

  /// The callback ID for which the completion is being reported.
  final String cbid;
}

@_serializable
final class JsiiCallbackSuccessRequest extends JsiiCallbackCompletion {
  const JsiiCallbackSuccessRequest({
    required super.cbid,
    required this.result,
  });

  factory JsiiCallbackSuccessRequest.fromJson(Map<String, Object?> json) =>
      _$JsiiCallbackSuccessRequestFromJson(json);

  /// The result of the execution (`null` if void).
  final JsiiKernelObject result;

  @override
  List<Object?> get props => [cbid, result];

  @override
  String get runtimeTypeName => 'JsiiCallbackSuccessRequest';

  @override
  Map<String, Object?> toJson() => _$JsiiCallbackSuccessRequestToJson(this);
}

@_serializable
final class JsiiCallbackErrorRequest extends JsiiCallbackCompletion {
  const JsiiCallbackErrorRequest({
    required super.cbid,
    required this.name,
    required this.error,
  });

  factory JsiiCallbackErrorRequest.fromJson(Map<String, Object?> json) =>
      _$JsiiCallbackErrorRequestFromJson(json);

  /// The fully qualified name of the error that occurred during the callback.
  final JsiiFqn name;

  /// The error that occurred during the callback.
  final String error;

  @override
  List<Object?> get props => [cbid, name, error];

  @override
  String get runtimeTypeName => 'JsiiCallbackErrorRequest';

  @override
  Map<String, Object?> toJson() => _$JsiiCallbackErrorRequestToJson(this);
}

@_serializable
final class JsiiCallbacksRequest extends JsiiRequest {
  const JsiiCallbacksRequest() : super('callbacks');

  factory JsiiCallbacksRequest.fromJson(Map<String, Object?> json) =>
      _$JsiiCallbacksRequestFromJson(json);

  @override
  List<Object?> get props => const [];

  @override
  String get runtimeTypeName => 'JsiiCallbacksRequest';

  @override
  Map<String, Object?> toJson() => _$JsiiCallbacksRequestToJson(this);
}

@_serializable
final class JsiiDeleteRequest extends JsiiRequest {
  const JsiiDeleteRequest({
    required this.objRef,
  }) : super('del');

  factory JsiiDeleteRequest.fromJson(Map<String, Object?> json) =>
      _$JsiiDeleteRequestFromJson(json);

  /// The object to delete.
  @JsonKey(name: 'objref')
  final JsiiObjectRef objRef;

  @override
  List<Object?> get props => [objRef];

  @override
  String get runtimeTypeName => 'JsiiDeleteRequest';

  @override
  Map<String, Object?> toJson() => _$JsiiDeleteRequestToJson(this);
}

@_serializable
final class JsiiInvokeRequest extends JsiiRequest {
  const JsiiInvokeRequest({
    required this.objRef,
    required this.method,
    this.args,
  }) : super('invoke');

  factory JsiiInvokeRequest.fromJson(Map<String, Object?> json) =>
      _$JsiiInvokeRequestFromJson(json);

  /// The object on which the method must be invoked.
  @JsonKey(name: 'objref')
  final JsiiObjectRef objRef;

  /// The name of the method to invoke.
  final String method;

  /// The arguments to pass to the method.
  final List<JsiiKernelObject>? args;

  @override
  List<Object?> get props => [objRef, method, args];

  @override
  String get runtimeTypeName => 'JsiiInvokeRequest';

  @override
  Map<String, Object?> toJson() => _$JsiiInvokeRequestToJson(this);
}

@_serializable
final class JsiiStaticInvokeRequest extends JsiiRequest {
  const JsiiStaticInvokeRequest({
    required this.fqn,
    required this.method,
    this.args,
  }) : super('sinvoke');

  factory JsiiStaticInvokeRequest.fromJson(Map<String, Object?> json) =>
      _$JsiiStaticInvokeRequestFromJson(json);

  /// The fully qualified name of the class on which the method must be invoked.
  final JsiiFqn fqn;

  /// The name of the method to invoke.
  final String method;

  /// The arguments to pass to the method.
  final List<JsiiKernelObject>? args;

  @override
  List<Object?> get props => [fqn, method, args];

  @override
  String get runtimeTypeName => 'JsiiStaticInvokeRequest';

  @override
  Map<String, Object?> toJson() => _$JsiiStaticInvokeRequestToJson(this);
}

@_serializable
final class JsiiBeginAsyncRequest extends JsiiRequest {
  const JsiiBeginAsyncRequest({
    required this.objRef,
    required this.method,
    this.args,
  }) : super('begin');

  factory JsiiBeginAsyncRequest.fromJson(Map<String, Object?> json) =>
      _$JsiiBeginAsyncRequestFromJson(json);

  /// The object on which the method must be invoked.
  @JsonKey(name: 'objref')
  final JsiiObjectRef objRef;

  /// The name of the method to invoke.
  final String method;

  /// The arguments to pass to the method.
  final List<JsiiKernelObject>? args;

  @override
  List<Object?> get props => [objRef, method, args];

  @override
  String get runtimeTypeName => 'JsiiBeginAsyncRequest';

  @override
  Map<String, Object?> toJson() => _$JsiiBeginAsyncRequestToJson(this);
}

@_serializable
final class JsiiEndAsyncRequest extends JsiiRequest {
  const JsiiEndAsyncRequest({
    required this.promiseId,
  }) : super('end');

  factory JsiiEndAsyncRequest.fromJson(Map<String, Object?> json) =>
      _$JsiiEndAsyncRequestFromJson(json);

  /// The `promiseid` that was returned from the corresponding `begin` call.
  @JsonKey(name: 'promiseid')
  final String promiseId;

  @override
  List<Object?> get props => [promiseId];

  @override
  String get runtimeTypeName => 'JsiiEndAsyncRequest';

  @override
  Map<String, Object?> toJson() => _$JsiiEndAsyncRequestToJson(this);
}

@_serializable
final class JsiiGetRequest extends JsiiRequest {
  const JsiiGetRequest({
    required this.objRef,
    required this.property,
  }) : super('get');

  factory JsiiGetRequest.fromJson(Map<String, Object?> json) =>
      _$JsiiGetRequestFromJson(json);

  /// The object on which the property must be retrieved.
  @JsonKey(name: 'objref')
  final JsiiObjectRef objRef;

  /// The name of the property to retrieve.
  final String property;

  @override
  List<Object?> get props => [objRef, property];

  @override
  String get runtimeTypeName => 'JsiiGetRequest';

  @override
  Map<String, Object?> toJson() => _$JsiiGetRequestToJson(this);
}

@_serializable
final class JsiiStaticGetRequest extends JsiiRequest {
  const JsiiStaticGetRequest({
    required this.fqn,
    required this.property,
  }) : super('sget');

  factory JsiiStaticGetRequest.fromJson(Map<String, Object?> json) =>
      _$JsiiStaticGetRequestFromJson(json);

  /// The fully qualified name of the class on which the property must be
  /// retrieved.
  final JsiiFqn fqn;

  /// The name of the property to retrieve.
  final String property;

  @override
  List<Object?> get props => [fqn, property];

  @override
  String get runtimeTypeName => 'JsiiStaticGetRequest';

  @override
  Map<String, Object?> toJson() => _$JsiiStaticGetRequestToJson(this);
}

@_serializable
final class JsiiSetRequest extends JsiiRequest {
  const JsiiSetRequest({
    required this.objRef,
    required this.property,
    required this.value,
  }) : super('set');

  factory JsiiSetRequest.fromJson(Map<String, Object?> json) =>
      _$JsiiSetRequestFromJson(json);

  /// The object on which the property must be set.
  @JsonKey(name: 'objref')
  final JsiiObjectRef objRef;

  /// The name of the property to set.
  final String property;

  /// The value to set.
  final JsiiKernelObject value;

  @override
  List<Object?> get props => [objRef, property, value];

  @override
  String get runtimeTypeName => 'JsiiSetRequest';

  @override
  Map<String, Object?> toJson() => _$JsiiSetRequestToJson(this);
}

@_serializable
final class JsiiStaticSetRequest extends JsiiRequest {
  const JsiiStaticSetRequest({
    required this.fqn,
    required this.property,
    required this.value,
  }) : super('sset');

  factory JsiiStaticSetRequest.fromJson(Map<String, Object?> json) =>
      _$JsiiStaticSetRequestFromJson(json);

  /// The fully qualified name of the class on which the property must be set.
  final JsiiFqn fqn;

  /// The name of the property to set.
  final String property;

  /// The value to set.
  final JsiiKernelObject value;

  @override
  List<Object?> get props => [fqn, property, value];

  @override
  String get runtimeTypeName => 'JsiiStaticSetRequest';

  @override
  Map<String, Object?> toJson() => _$JsiiStaticSetRequestToJson(this);
}

@_serializable
final class JsiiExitRequest extends JsiiRequest {
  const JsiiExitRequest([this.code = 0]) : super('exit');

  factory JsiiExitRequest.fromJson(Map<String, Object?> json) =>
      _$JsiiExitRequestFromJson(json);

  /// The exit code to use when exiting the kernel.
  final int code;

  @override
  List<Object?> get props => [code];

  @override
  String get runtimeTypeName => 'JsiiExitRequest';

  @override
  Map<String, Object?> toJson() => {'exit': code};
}
