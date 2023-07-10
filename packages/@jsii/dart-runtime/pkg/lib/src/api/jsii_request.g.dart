// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jsii_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsiiLoadRequest _$JsiiLoadRequestFromJson(Map<String, dynamic> json) =>
    JsiiLoadRequest(
      name: json['name'] as String,
      version: json['version'] as String,
      tarball: json['tarball'] as String,
    );

Map<String, dynamic> _$JsiiLoadRequestToJson(JsiiLoadRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'version': instance.version,
      'tarball': instance.tarball,
    };

JsiiNamingRequest _$JsiiNamingRequestFromJson(Map<String, dynamic> json) =>
    JsiiNamingRequest(
      assembly: json['assembly'] as String,
    );

Map<String, dynamic> _$JsiiNamingRequestToJson(JsiiNamingRequest instance) =>
    <String, dynamic>{
      'assembly': instance.assembly,
    };

JsiiStatsRequest _$JsiiStatsRequestFromJson(Map<String, dynamic> json) =>
    JsiiStatsRequest();

Map<String, dynamic> _$JsiiStatsRequestToJson(JsiiStatsRequest instance) =>
    <String, dynamic>{};

JsiiCreateRequest _$JsiiCreateRequestFromJson(Map<String, dynamic> json) =>
    JsiiCreateRequest(
      fqn: JsiiFqn.fromJson(json['fqn'] as String),
      args: (json['args'] as List<dynamic>?)
          ?.map(JsiiKernelObject.fromJson)
          .toList(),
      interfaces: (json['interfaces'] as List<dynamic>?)
          ?.map((e) => JsiiFqn.fromJson(e as String))
          .toList(),
      overrides: (json['overrides'] as List<dynamic>?)
          ?.map((e) => Override.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$JsiiCreateRequestToJson(JsiiCreateRequest instance) =>
    <String, dynamic>{
      'fqn': instance.fqn.toJson(),
      'args': instance.args?.map((e) => e.toJson()).toList(),
      'interfaces': instance.interfaces?.map((e) => e.toJson()).toList(),
      'overrides': instance.overrides?.map((e) => e.toJson()).toList(),
    };

_PropertyOverride _$PropertyOverrideFromJson(Map<String, dynamic> json) =>
    _PropertyOverride(
      property: json['property'] as String,
      cookie: json['cookie'] as String?,
    );

Map<String, dynamic> _$PropertyOverrideToJson(_PropertyOverride instance) =>
    <String, dynamic>{
      'cookie': instance.cookie,
      'property': instance.property,
    };

_MethodOverride _$MethodOverrideFromJson(Map<String, dynamic> json) =>
    _MethodOverride(
      method: json['method'] as String,
      cookie: json['cookie'] as String?,
    );

Map<String, dynamic> _$MethodOverrideToJson(_MethodOverride instance) =>
    <String, dynamic>{
      'cookie': instance.cookie,
      'method': instance.method,
    };

JsiiCallbackSuccessRequest _$JsiiCallbackSuccessRequestFromJson(
        Map<String, dynamic> json) =>
    JsiiCallbackSuccessRequest(
      cbid: json['cbid'] as String,
      result: JsiiKernelObject.fromJson(json['result']),
    );

Map<String, dynamic> _$JsiiCallbackSuccessRequestToJson(
        JsiiCallbackSuccessRequest instance) =>
    <String, dynamic>{
      'cbid': instance.cbid,
      'result': instance.result.toJson(),
    };

JsiiCallbackErrorRequest _$JsiiCallbackErrorRequestFromJson(
        Map<String, dynamic> json) =>
    JsiiCallbackErrorRequest(
      cbid: json['cbid'] as String,
      name: JsiiFqn.fromJson(json['name'] as String),
      error: json['error'] as String,
    );

Map<String, dynamic> _$JsiiCallbackErrorRequestToJson(
        JsiiCallbackErrorRequest instance) =>
    <String, dynamic>{
      'cbid': instance.cbid,
      'name': instance.name.toJson(),
      'error': instance.error,
    };

JsiiCallbacksRequest _$JsiiCallbacksRequestFromJson(
        Map<String, dynamic> json) =>
    JsiiCallbacksRequest();

Map<String, dynamic> _$JsiiCallbacksRequestToJson(
        JsiiCallbacksRequest instance) =>
    <String, dynamic>{};

JsiiDeleteRequest _$JsiiDeleteRequestFromJson(Map<String, dynamic> json) =>
    JsiiDeleteRequest(
      objRef: JsiiObjectRef.fromJson(json['objref'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$JsiiDeleteRequestToJson(JsiiDeleteRequest instance) =>
    <String, dynamic>{
      'objref': instance.objRef.toJson(),
    };

JsiiInvokeRequest _$JsiiInvokeRequestFromJson(Map<String, dynamic> json) =>
    JsiiInvokeRequest(
      objRef: JsiiObjectRef.fromJson(json['objref'] as Map<String, dynamic>),
      method: json['method'] as String,
      args: (json['args'] as List<dynamic>?)
          ?.map(JsiiKernelObject.fromJson)
          .toList(),
    );

Map<String, dynamic> _$JsiiInvokeRequestToJson(JsiiInvokeRequest instance) =>
    <String, dynamic>{
      'objref': instance.objRef.toJson(),
      'method': instance.method,
      'args': instance.args?.map((e) => e.toJson()).toList(),
    };

JsiiStaticInvokeRequest _$JsiiStaticInvokeRequestFromJson(
        Map<String, dynamic> json) =>
    JsiiStaticInvokeRequest(
      fqn: JsiiFqn.fromJson(json['fqn'] as String),
      method: json['method'] as String,
      args: (json['args'] as List<dynamic>?)
          ?.map(JsiiKernelObject.fromJson)
          .toList(),
    );

Map<String, dynamic> _$JsiiStaticInvokeRequestToJson(
        JsiiStaticInvokeRequest instance) =>
    <String, dynamic>{
      'fqn': instance.fqn.toJson(),
      'method': instance.method,
      'args': instance.args?.map((e) => e.toJson()).toList(),
    };

JsiiBeginAsyncRequest _$JsiiBeginAsyncRequestFromJson(
        Map<String, dynamic> json) =>
    JsiiBeginAsyncRequest(
      objRef: JsiiObjectRef.fromJson(json['objref'] as Map<String, dynamic>),
      method: json['method'] as String,
      args: (json['args'] as List<dynamic>?)
          ?.map(JsiiKernelObject.fromJson)
          .toList(),
    );

Map<String, dynamic> _$JsiiBeginAsyncRequestToJson(
        JsiiBeginAsyncRequest instance) =>
    <String, dynamic>{
      'objref': instance.objRef.toJson(),
      'method': instance.method,
      'args': instance.args?.map((e) => e.toJson()).toList(),
    };

JsiiEndAsyncRequest _$JsiiEndAsyncRequestFromJson(Map<String, dynamic> json) =>
    JsiiEndAsyncRequest(
      promiseId: json['promiseid'] as String,
    );

Map<String, dynamic> _$JsiiEndAsyncRequestToJson(
        JsiiEndAsyncRequest instance) =>
    <String, dynamic>{
      'promiseid': instance.promiseId,
    };

JsiiGetRequest _$JsiiGetRequestFromJson(Map<String, dynamic> json) =>
    JsiiGetRequest(
      objRef: JsiiObjectRef.fromJson(json['objref'] as Map<String, dynamic>),
      property: json['property'] as String,
    );

Map<String, dynamic> _$JsiiGetRequestToJson(JsiiGetRequest instance) =>
    <String, dynamic>{
      'objref': instance.objRef.toJson(),
      'property': instance.property,
    };

JsiiStaticGetRequest _$JsiiStaticGetRequestFromJson(
        Map<String, dynamic> json) =>
    JsiiStaticGetRequest(
      fqn: JsiiFqn.fromJson(json['fqn'] as String),
      property: json['property'] as String,
    );

Map<String, dynamic> _$JsiiStaticGetRequestToJson(
        JsiiStaticGetRequest instance) =>
    <String, dynamic>{
      'fqn': instance.fqn.toJson(),
      'property': instance.property,
    };

JsiiSetRequest _$JsiiSetRequestFromJson(Map<String, dynamic> json) =>
    JsiiSetRequest(
      objRef: JsiiObjectRef.fromJson(json['objref'] as Map<String, dynamic>),
      property: json['property'] as String,
      value: JsiiKernelObject.fromJson(json['value']),
    );

Map<String, dynamic> _$JsiiSetRequestToJson(JsiiSetRequest instance) =>
    <String, dynamic>{
      'objref': instance.objRef.toJson(),
      'property': instance.property,
      'value': instance.value.toJson(),
    };

JsiiStaticSetRequest _$JsiiStaticSetRequestFromJson(
        Map<String, dynamic> json) =>
    JsiiStaticSetRequest(
      fqn: JsiiFqn.fromJson(json['fqn'] as String),
      property: json['property'] as String,
      value: JsiiKernelObject.fromJson(json['value']),
    );

Map<String, dynamic> _$JsiiStaticSetRequestToJson(
        JsiiStaticSetRequest instance) =>
    <String, dynamic>{
      'fqn': instance.fqn.toJson(),
      'property': instance.property,
      'value': instance.value.toJson(),
    };

JsiiExitRequest _$JsiiExitRequestFromJson(Map<String, dynamic> json) =>
    JsiiExitRequest(
      json['code'] as int? ?? 0,
    );

Map<String, dynamic> _$JsiiExitRequestToJson(JsiiExitRequest instance) =>
    <String, dynamic>{
      'code': instance.code,
    };
