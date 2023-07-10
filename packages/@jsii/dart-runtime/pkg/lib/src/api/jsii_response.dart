import 'dart:convert';

import 'package:amplify_core/amplify_core.dart';
import 'package:jsii_runtime/src/api/jsii_kernel.dart';
import 'package:jsii_runtime/src/api/jsii_kernel_object.dart';
import 'package:jsii_runtime/src/api/jsii_request.dart';
import 'package:json_annotation/json_annotation.dart';

part 'jsii_response.g.dart';

const _serializable = JsonSerializable(
  explicitToJson: true,
);

sealed class JsiiResponse extends StateMachineState<Never>
    with AWSSerializable<Map<String, Object?>>, AWSDebuggable {
  const JsiiResponse();

  /// Parses a kernel response from a JSON string.
  factory JsiiResponse.fromKernel(
    String kernel, {
    required JsiiRequest? pendingRequest,
  }) =>
      JsiiResponse.fromJson(
        jsonDecode(kernel.trim()) as Map<String, Object?>,
        pendingRequest: pendingRequest,
      );

  /// Parses a kernel response from a JSON map.
  factory JsiiResponse.fromJson(
    Map<String, Object?> json, {
    required JsiiRequest? pendingRequest,
  }) {
    return switch (json) {
      {'hello': final String version} => JsiiHelloResponse(version),
      {'assembly': final String assembly, 'types': final num types} =>
        JsiiLoadResponse(
          assembly: assembly,
          types: types,
        ),
      {'byref': final String byRef} => JsiiCreateResponse(
          JsiiObjectRef(
            byRef,
            interfaces: (json[r'$jsii.interfaces'] as List<String>?)
                ?.map(JsiiFqn.parse)
                .toList(),
          ),
        ),
      const {} => switch (pendingRequest) {
          JsiiDeleteRequest _ => const JsiiDeleteResponse(),
          JsiiSetRequest _ || JsiiStaticSetRequest _ => const JsiiSetResponse(),
          _ => throw StateError(
              'Unexpected response for request: $pendingRequest',
            ),
        },
      {'result': final Object? result} => switch (pendingRequest) {
          JsiiGetRequest _ ||
          JsiiStaticGetRequest _ =>
            JsiiGetResponse(JsiiKernelObject.fromJson(result)),
          JsiiInvokeRequest _ ||
          JsiiStaticInvokeRequest _ =>
            JsiiInvokeResponse(JsiiKernelObject.fromJson(result)),
          JsiiEndAsyncRequest _ =>
            JsiiEndResponse(JsiiKernelObject.fromJson(result)),
          _ => throw StateError(
              'Unexpected response for request: $pendingRequest '
              '(result: $result)',
            ),
        },
      {'callbacks': final List<Map<String, Object?>> callbacks} =>
        JsiiCallbacksResponse(
          callbacks.map(Callback.fromJson).toList(),
        ),
      {
        'name': final String? name,
        'error': final String error,
        'stack': final String? stack
      } =>
        JsiiErrorResponse(
          name: name == null ? null : JsiiFqn.parse(name),
          error: error,
          stack: stack,
        ),
      {'naming': final Map<String, Map<String, Object?>> naming} =>
        JsiiNamingResponse(naming),
      {'objectCount': final num objectCount} => JsiiStatsResponse(objectCount),
      {'callback': final Map<String, Object?> callback} => JsiiCallbackRequest(
          Callback.fromJson(callback),
        ),
      {'promiseid': final String promiseId} => JsiiBeginResponse(promiseId),
      {'ok': final Object? value} => JsiiOkayResponse(
          JsiiKernelObject.fromJson(value),
        ),
      _ => throw ArgumentError.value(json, 'json', 'Invalid response'),
    };
  }

  @override
  Never get type => throw UnimplementedError();
}

/// Upon initialization, the `@jsii/kernel` process introduces itself to the
/// host application by emitting a single JSON message.
@_serializable
final class JsiiHelloResponse extends JsiiResponse {
  const JsiiHelloResponse(this.version);

  factory JsiiHelloResponse.fromJson(Map<String, Object?> json) =>
      _$JsiiHelloResponseFromJson(json);

  /// The version of the JSII kernel.
  final String version;

  @override
  String get runtimeTypeName => 'JsiiHelloResponse';

  @override
  List<Object?> get props => [version];

  @override
  Map<String, Object?> toJson() => _$JsiiHelloResponseToJson(this);
}

@_serializable
final class JsiiLoadResponse extends JsiiResponse {
  const JsiiLoadResponse({
    required this.assembly,
    required this.types,
  });

  factory JsiiLoadResponse.fromJson(Map<String, Object?> json) =>
      _$JsiiLoadResponseFromJson(json);

  /// The name of the assembly that was just loaded
  final String assembly;

  /// The number of types the assembly declared
  final num types;

  @override
  List<Object?> get props => [assembly, types];

  @override
  String get runtimeTypeName => 'JsiiLoadResponse';

  @override
  Map<String, Object?> toJson() => _$JsiiLoadResponseToJson(this);
}

@_serializable
final class JsiiNamingResponse extends JsiiResponse {
  const JsiiNamingResponse(this.naming);

  factory JsiiNamingResponse.fromJson(Map<String, Object?> json) =>
      _$JsiiNamingResponseFromJson(json);

  final Map<String, Map<String, Object?>> naming;

  @override
  List<Object?> get props => [naming];

  @override
  String get runtimeTypeName => 'JsiiNamingResponse';

  @override
  Map<String, Object?> toJson() => _$JsiiNamingResponseToJson(this);
}

@_serializable
final class JsiiStatsResponse extends JsiiResponse {
  const JsiiStatsResponse(this.objectCount);

  factory JsiiStatsResponse.fromJson(Map<String, Object?> json) =>
      _$JsiiStatsResponseFromJson(json);

  /// The number of object reference currently tracked by the Kernel
  final num objectCount;

  @override
  List<Object?> get props => [objectCount];

  @override
  String get runtimeTypeName => 'JsiiStatsResponse';

  @override
  Map<String, Object?> toJson() => _$JsiiStatsResponseToJson(this);
}

@_serializable
final class JsiiCreateResponse extends JsiiResponse {
  const JsiiCreateResponse(this.objRef);

  factory JsiiCreateResponse.fromJson(Map<String, Object?> json) =>
      _$JsiiCreateResponseFromJson(json);

  final JsiiObjectRef objRef;

  @override
  List<Object?> get props => [objRef];

  @override
  String get runtimeTypeName => 'JsiiCreateResponse';

  @override
  Map<String, Object?> toJson() => objRef.toJson();
}

@_serializable
final class JsiiErrorResponse extends JsiiResponse {
  const JsiiErrorResponse({
    this.name,
    required this.error,
    this.stack,
  });

  factory JsiiErrorResponse.fromJson(Map<String, Object?> json) =>
      _$JsiiErrorResponseFromJson(json);

  /// The fully qualified name of the error type.
  ///
  /// If the error is not a JSII kernel type, this will be `null`.
  final JsiiFqn? name;

  /// A simple message describing what happened.
  final String error;

  /// A stack trace, if available.
  final String? stack;

  @override
  String get runtimeTypeName => 'JsiiErrorResponse';

  @override
  List<Object?> get props => [name, error, stack];

  @override
  Map<String, Object?> toJson() => _$JsiiErrorResponseToJson(this);
}

@_serializable
final class JsiiCallbackRequest extends JsiiResponse {
  const JsiiCallbackRequest(this.callback);

  factory JsiiCallbackRequest.fromJson(Map<String, Object?> json) =>
      _$JsiiCallbackRequestFromJson(json);

  final Callback callback;

  @override
  List<Object?> get props => [callback];

  @override
  String get runtimeTypeName => 'JsiiCallbackRequest';

  @override
  Map<String, Object?> toJson() => _$JsiiCallbackRequestToJson(this);
}

sealed class Callback
    with
        AWSEquatable<Callback>,
        AWSSerializable<Map<String, Object?>>,
        AWSDebuggable {
  const Callback({
    required this.cbid,
    required this.objRef,
    this.cookie,
  });

  factory Callback.fromJson(Map<String, Object?> json) {
    return switch (json) {
      {'method': final String method} => InvokeCallback(
          cbid: json['cbid'] as String,
          objRef: JsiiObjectRef.fromJson(json['objref'] as Map<String, Object>),
          method: method,
          cookie: json['cookie'] as String?,
        ),
      {'property': final String property, 'value': final Object? value} =>
        SetCallback(
          cbid: json['cbid'] as String,
          objRef: JsiiObjectRef.fromJson(json['objref'] as Map<String, Object>),
          property: property,
          value: JsiiKernelObject.fromJson(value),
          cookie: json['cookie'] as String?,
        ),
      {'property': final String property} => GetCallback(
          cbid: json['cbid'] as String,
          objRef: JsiiObjectRef.fromJson(json['objref'] as Map<String, Object>),
          property: property,
          cookie: json['cookie'] as String?,
        ),
      _ => throw ArgumentError.value(json, 'json', 'Invalid callback'),
    };
  }

  /// A unique identifier for this callback request
  final String cbid;

  /// The object on which the callback must be executed
  final JsiiObjectRef objRef;

  /// An arbitrary cookie string that was provided by the **host** app when the
  /// callback was requested.
  ///
  /// See: https://aws.github.io/jsii/specification/3-kernel-api/#overrides
  final String? cookie;
}

@_serializable
final class InvokeCallback extends Callback {
  const InvokeCallback({
    required super.cbid,
    required super.objRef,
    required this.method,
    super.cookie,
  });

  /// The name of the host method to invoke.
  final String method;

  @override
  List<Object?> get props => [cbid, objRef, method, cookie];

  @override
  String get runtimeTypeName => 'InvokeCallback';

  @override
  Map<String, Object?> toJson() => _$InvokeCallbackToJson(this);
}

@_serializable
final class GetCallback extends Callback {
  const GetCallback({
    required super.cbid,
    required super.objRef,
    required this.property,
    super.cookie,
  });

  /// The name of the host property to get.
  final String property;

  @override
  List<Object?> get props => [cbid, objRef, property, cookie];

  @override
  String get runtimeTypeName => 'GetCallback';

  @override
  Map<String, Object?> toJson() => _$GetCallbackToJson(this);
}

@_serializable
final class SetCallback extends Callback {
  const SetCallback({
    required super.cbid,
    required super.objRef,
    required this.property,
    required this.value,
    super.cookie,
  });

  /// The name of the host property to set.
  final String property;

  /// The value to set.
  final JsiiKernelObject value;

  @override
  List<Object?> get props => [cbid, objRef, property, value, cookie];

  @override
  String get runtimeTypeName => 'SetCallback';

  @override
  Map<String, Object?> toJson() => _$SetCallbackToJson(this);
}

@_serializable
final class JsiiCallbacksResponse extends JsiiResponse {
  const JsiiCallbacksResponse(this.callbacks);

  factory JsiiCallbacksResponse.fromJson(Map<String, Object?> json) =>
      _$JsiiCallbacksResponseFromJson(json);

  final List<Callback> callbacks;

  @override
  List<Object?> get props => [callbacks];

  @override
  String get runtimeTypeName => 'JsiiCallbacksResponse';

  @override
  Map<String, Object?> toJson() => _$JsiiCallbacksResponseToJson(this);
}

@_serializable
final class JsiiDeleteResponse extends JsiiResponse {
  const JsiiDeleteResponse();

  factory JsiiDeleteResponse.fromJson(Map<String, Object?> json) =>
      _$JsiiDeleteResponseFromJson(json);

  @override
  List<Object?> get props => const [];

  @override
  String get runtimeTypeName => 'JsiiDeleteResponse';

  @override
  Map<String, Object?> toJson() => _$JsiiDeleteResponseToJson(this);
}

@_serializable
final class JsiiInvokeResponse extends JsiiResponse {
  const JsiiInvokeResponse(this.result);

  factory JsiiInvokeResponse.fromJson(Map<String, Object?> json) =>
      _$JsiiInvokeResponseFromJson(json);

  /// The result of the method invocation.
  final JsiiKernelObject result;

  @override
  List<Object?> get props => [result];

  @override
  String get runtimeTypeName => 'JsiiInvokeResponse';

  @override
  Map<String, Object?> toJson() => _$JsiiInvokeResponseToJson(this);
}

@_serializable
final class JsiiBeginResponse extends JsiiResponse {
  const JsiiBeginResponse(this.promiseId);

  factory JsiiBeginResponse.fromJson(Map<String, Object?> json) =>
      _$JsiiBeginResponseFromJson(json);

  /// An opaque string that uniquely idenfies the promised result of this
  /// invocation.
  @JsonKey(name: 'promiseid')
  final String promiseId;

  @override
  List<Object?> get props => [promiseId];

  @override
  String get runtimeTypeName => 'JsiiBeginResponse';

  @override
  Map<String, Object?> toJson() => _$JsiiBeginResponseToJson(this);
}

@_serializable
final class JsiiEndResponse extends JsiiResponse {
  const JsiiEndResponse(this.result);

  factory JsiiEndResponse.fromJson(Map<String, Object?> json) =>
      _$JsiiEndResponseFromJson(json);

  /// The result of the method invocation.
  final JsiiKernelObject result;

  @override
  List<Object?> get props => [result];

  @override
  String get runtimeTypeName => 'JsiiEndResponse';

  @override
  Map<String, Object?> toJson() => _$JsiiEndResponseToJson(this);
}

@_serializable
final class JsiiGetResponse extends JsiiResponse {
  const JsiiGetResponse(this.result);

  factory JsiiGetResponse.fromJson(Map<String, Object?> json) =>
      _$JsiiGetResponseFromJson(json);

  /// The result of the property get operation.
  final JsiiKernelObject result;

  @override
  List<Object?> get props => [result];

  @override
  String get runtimeTypeName => 'JsiiGetResponse';

  @override
  Map<String, Object?> toJson() => _$JsiiGetResponseToJson(this);
}

@_serializable
final class JsiiSetResponse extends JsiiResponse {
  const JsiiSetResponse();

  factory JsiiSetResponse.fromJson(Map<String, Object?> json) =>
      _$JsiiSetResponseFromJson(json);

  @override
  List<Object?> get props => const [];

  @override
  String get runtimeTypeName => 'JsiiSetResponse';

  @override
  Map<String, Object?> toJson() => _$JsiiSetResponseToJson(this);
}

@_serializable
final class JsiiOkayResponse extends JsiiResponse {
  const JsiiOkayResponse(this.ok);

  factory JsiiOkayResponse.fromJson(Map<String, Object?> json) =>
      _$JsiiOkayResponseFromJson(json);

  final JsiiKernelObject ok;

  @override
  List<Object?> get props => [ok];

  @override
  String get runtimeTypeName => 'JsiiOkayResponse';

  @override
  Map<String, Object?> toJson() => _$JsiiOkayResponseToJson(this);
}
