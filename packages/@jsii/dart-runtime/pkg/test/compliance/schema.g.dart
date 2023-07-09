// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Suite _$SuiteFromJson(Map<String, dynamic> json) => Suite(
      name: json['name'] as String,
      description: json['description'] as String,
      bindings: (json['bindings'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, Binding.fromJson(e as Map<String, dynamic>)),
      ),
      testCases: (json['testCases'] as List<dynamic>)
          .map((e) => TestCase.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SuiteToJson(Suite instance) => <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'bindings': instance.bindings,
      'testCases': instance.testCases,
    };

TestCase _$TestCaseFromJson(Map<String, dynamic> json) => TestCase(
      name: json['name'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$TestCaseToJson(TestCase instance) => <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
    };

Binding _$BindingFromJson(Map<String, dynamic> json) => Binding(
      report: json['report'] as String,
    );

Map<String, dynamic> _$BindingToJson(Binding instance) => <String, dynamic>{
      'report': instance.report,
    };

BindingExclusion _$BindingExclusionFromJson(Map<String, dynamic> json) =>
    BindingExclusion(
      reason: json['reason'] as String,
    );

Map<String, dynamic> _$BindingExclusionToJson(BindingExclusion instance) =>
    <String, dynamic>{
      'reason': instance.reason,
    };

TestExclusion _$TestExclusionFromJson(Map<String, dynamic> json) =>
    TestExclusion(
      reason: json['reason'] as String,
    );

Map<String, dynamic> _$TestExclusionToJson(TestExclusion instance) =>
    <String, dynamic>{
      'reason': instance.reason,
    };

TestResult _$TestResultFromJson(Map<String, dynamic> json) => TestResult(
      status: $enumDecode(_$TestStatusEnumMap, json['status']),
      reason: json['reason'] as String?,
      url: json['url'] as String?,
    );

Map<String, dynamic> _$TestResultToJson(TestResult instance) =>
    <String, dynamic>{
      'status': _$TestStatusEnumMap[instance.status]!,
      'reason': instance.reason,
      'url': instance.url,
    };

const _$TestStatusEnumMap = {
  TestStatus.success: 'success',
  TestStatus.failure: 'failure',
  TestStatus.na: 'n/a',
};
