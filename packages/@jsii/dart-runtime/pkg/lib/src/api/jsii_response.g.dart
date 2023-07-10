// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jsii_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsiiHelloResponse _$JsiiHelloResponseFromJson(Map<String, dynamic> json) =>
    JsiiHelloResponse(
      json['version'] as String,
    );

Map<String, dynamic> _$JsiiHelloResponseToJson(JsiiHelloResponse instance) =>
    <String, dynamic>{
      'version': instance.version,
    };

JsiiLoadResponse _$JsiiLoadResponseFromJson(Map<String, dynamic> json) =>
    JsiiLoadResponse(
      assembly: json['assembly'] as String,
      types: json['types'] as num,
    );

Map<String, dynamic> _$JsiiLoadResponseToJson(JsiiLoadResponse instance) =>
    <String, dynamic>{
      'assembly': instance.assembly,
      'types': instance.types,
    };

JsiiNamingResponse _$JsiiNamingResponseFromJson(Map<String, dynamic> json) =>
    JsiiNamingResponse(
      (json['naming'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, e as Map<String, dynamic>),
      ),
    );

Map<String, dynamic> _$JsiiNamingResponseToJson(JsiiNamingResponse instance) =>
    <String, dynamic>{
      'naming': instance.naming,
    };

JsiiStatsResponse _$JsiiStatsResponseFromJson(Map<String, dynamic> json) =>
    JsiiStatsResponse(
      json['objectCount'] as num,
    );

Map<String, dynamic> _$JsiiStatsResponseToJson(JsiiStatsResponse instance) =>
    <String, dynamic>{
      'objectCount': instance.objectCount,
    };

JsiiCreateResponse _$JsiiCreateResponseFromJson(Map<String, dynamic> json) =>
    JsiiCreateResponse(
      JsiiObjectRef.fromJson(json['objRef'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$JsiiCreateResponseToJson(JsiiCreateResponse instance) =>
    <String, dynamic>{
      'objRef': instance.objRef.toJson(),
    };

JsiiErrorResponse _$JsiiErrorResponseFromJson(Map<String, dynamic> json) =>
    JsiiErrorResponse(
      name: json['name'] == null
          ? null
          : JsiiFqn.fromJson(json['name'] as String),
      error: json['error'] as String,
      stack: json['stack'] as String?,
    );

Map<String, dynamic> _$JsiiErrorResponseToJson(JsiiErrorResponse instance) =>
    <String, dynamic>{
      'name': instance.name?.toJson(),
      'error': instance.error,
      'stack': instance.stack,
    };

JsiiCallbackRequest _$JsiiCallbackRequestFromJson(Map<String, dynamic> json) =>
    JsiiCallbackRequest(
      Callback.fromJson(json['callback'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$JsiiCallbackRequestToJson(
        JsiiCallbackRequest instance) =>
    <String, dynamic>{
      'callback': instance.callback.toJson(),
    };

InvokeCallback _$InvokeCallbackFromJson(Map<String, dynamic> json) =>
    InvokeCallback(
      cbid: json['cbid'] as String,
      objRef: JsiiObjectRef.fromJson(json['objRef'] as Map<String, dynamic>),
      method: json['method'] as String,
      cookie: json['cookie'] as String?,
    );

Map<String, dynamic> _$InvokeCallbackToJson(InvokeCallback instance) =>
    <String, dynamic>{
      'cbid': instance.cbid,
      'objRef': instance.objRef.toJson(),
      'cookie': instance.cookie,
      'method': instance.method,
    };

GetCallback _$GetCallbackFromJson(Map<String, dynamic> json) => GetCallback(
      cbid: json['cbid'] as String,
      objRef: JsiiObjectRef.fromJson(json['objRef'] as Map<String, dynamic>),
      property: json['property'] as String,
      cookie: json['cookie'] as String?,
    );

Map<String, dynamic> _$GetCallbackToJson(GetCallback instance) =>
    <String, dynamic>{
      'cbid': instance.cbid,
      'objRef': instance.objRef.toJson(),
      'cookie': instance.cookie,
      'property': instance.property,
    };

SetCallback _$SetCallbackFromJson(Map<String, dynamic> json) => SetCallback(
      cbid: json['cbid'] as String,
      objRef: JsiiObjectRef.fromJson(json['objRef'] as Map<String, dynamic>),
      property: json['property'] as String,
      value: JsiiKernelObject.fromJson(json['value']),
      cookie: json['cookie'] as String?,
    );

Map<String, dynamic> _$SetCallbackToJson(SetCallback instance) =>
    <String, dynamic>{
      'cbid': instance.cbid,
      'objRef': instance.objRef.toJson(),
      'cookie': instance.cookie,
      'property': instance.property,
      'value': instance.value.toJson(),
    };

JsiiCallbacksResponse _$JsiiCallbacksResponseFromJson(
        Map<String, dynamic> json) =>
    JsiiCallbacksResponse(
      (json['callbacks'] as List<dynamic>)
          .map((e) => Callback.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$JsiiCallbacksResponseToJson(
        JsiiCallbacksResponse instance) =>
    <String, dynamic>{
      'callbacks': instance.callbacks.map((e) => e.toJson()).toList(),
    };

JsiiDeleteResponse _$JsiiDeleteResponseFromJson(Map<String, dynamic> json) =>
    JsiiDeleteResponse();

Map<String, dynamic> _$JsiiDeleteResponseToJson(JsiiDeleteResponse instance) =>
    <String, dynamic>{};

JsiiInvokeResponse _$JsiiInvokeResponseFromJson(Map<String, dynamic> json) =>
    JsiiInvokeResponse(
      JsiiKernelObject.fromJson(json['result']),
    );

Map<String, dynamic> _$JsiiInvokeResponseToJson(JsiiInvokeResponse instance) =>
    <String, dynamic>{
      'result': instance.result.toJson(),
    };

JsiiBeginResponse _$JsiiBeginResponseFromJson(Map<String, dynamic> json) =>
    JsiiBeginResponse(
      json['promiseid'] as String,
    );

Map<String, dynamic> _$JsiiBeginResponseToJson(JsiiBeginResponse instance) =>
    <String, dynamic>{
      'promiseid': instance.promiseId,
    };

JsiiEndResponse _$JsiiEndResponseFromJson(Map<String, dynamic> json) =>
    JsiiEndResponse(
      JsiiKernelObject.fromJson(json['result']),
    );

Map<String, dynamic> _$JsiiEndResponseToJson(JsiiEndResponse instance) =>
    <String, dynamic>{
      'result': instance.result.toJson(),
    };

JsiiGetResponse _$JsiiGetResponseFromJson(Map<String, dynamic> json) =>
    JsiiGetResponse(
      JsiiKernelObject.fromJson(json['result']),
    );

Map<String, dynamic> _$JsiiGetResponseToJson(JsiiGetResponse instance) =>
    <String, dynamic>{
      'result': instance.result.toJson(),
    };

JsiiSetResponse _$JsiiSetResponseFromJson(Map<String, dynamic> json) =>
    JsiiSetResponse();

Map<String, dynamic> _$JsiiSetResponseToJson(JsiiSetResponse instance) =>
    <String, dynamic>{};

JsiiOkayResponse _$JsiiOkayResponseFromJson(Map<String, dynamic> json) =>
    JsiiOkayResponse(
      JsiiKernelObject.fromJson(json['ok']),
    );

Map<String, dynamic> _$JsiiOkayResponseToJson(JsiiOkayResponse instance) =>
    <String, dynamic>{
      'ok': instance.ok.toJson(),
    };
