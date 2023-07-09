// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$TestResultToJson(TestResult instance) =>
    <String, dynamic>{
      'status': _$TestStatusEnumMap[instance.status]!,
      'kernelTrace': instance.kernelTrace.map((e) => e.toJson()).toList(),
      'runtimeTypeName': instance.runtimeTypeName,
    };

const _$TestStatusEnumMap = {
  TestStatus.pass: 'PASS',
  TestStatus.fail: 'FAIL',
};

Map<String, dynamic> _$KernelMessageToJson(KernelMessage instance) =>
    <String, dynamic>{
      'direction': _$MessageDirectionEnumMap[instance.direction]!,
      'message': instance.message,
      'runtimeTypeName': instance.runtimeTypeName,
    };

const _$MessageDirectionEnumMap = {
  MessageDirection.fromKernel: 'FromKernel',
  MessageDirection.toKernel: 'ToKernel',
};
