import 'package:aws_common/aws_common.dart';
import 'package:json_annotation/json_annotation.dart';

part 'schema.g.dart';

const _serializable = JsonSerializable();

@_serializable
final class Suite with AWSSerializable<Map<String, Object?>>, AWSDebuggable {
  const Suite({
    required this.name,
    required this.description,
    required this.bindings,
    required this.testCases,
  });

  factory Suite.fromJson(Map<String, Object?> json) => _$SuiteFromJson(json);

  final String name;
  final String description;

  /// Language bindings the suite applies to. The key is the language.
  final Map<Language, Binding> bindings;

  /// A list of test cases the suite enforces.
  final List<TestCase> testCases;

  @override
  Map<String, Object?> toJson() => _$SuiteToJson(this);

  @override
  String get runtimeTypeName => 'Suite';
}

@_serializable
final class TestCase with AWSSerializable<Map<String, Object?>>, AWSDebuggable {
  const TestCase({
    required this.name,
    required this.description,
  });

  factory TestCase.fromJson(Map<String, Object?> json) =>
      _$TestCaseFromJson(json);

  final String name;
  final String description;

  @override
  Map<String, Object?> toJson() => _$TestCaseToJson(this);

  @override
  String get runtimeTypeName => 'TestCase';
}

@_serializable
final class Binding with AWSSerializable<Map<String, Object?>>, AWSDebuggable {
  const Binding({
    required this.report,
  });

  factory Binding.fromJson(Map<String, Object?> json) =>
      _$BindingFromJson(json);

  /// Location of the language specific report.
  final String report;

  @override
  Map<String, Object?> toJson() => _$BindingToJson(this);

  @override
  String get runtimeTypeName => 'Binding';
}

/// Exclusion of a specific language binding.
@_serializable
final class BindingExclusion
    with AWSSerializable<Map<String, Object?>>, AWSDebuggable {
  const BindingExclusion({
    required this.reason,
  });

  factory BindingExclusion.fromJson(Map<String, Object?> json) =>
      _$BindingExclusionFromJson(json);

  /// The reason for the exclusion.
  final String reason;

  @override
  Map<String, Object?> toJson() => _$BindingExclusionToJson(this);

  @override
  String get runtimeTypeName => 'BindingExclusion';
}

/// Exclusion of a specific test from a specific binding.
@_serializable
final class TestExclusion
    with AWSSerializable<Map<String, Object?>>, AWSDebuggable {
  const TestExclusion({
    required this.reason,
  });

  factory TestExclusion.fromJson(Map<String, Object?> json) =>
      _$TestExclusionFromJson(json);

  /// The reason for the exclusion.
  final String reason;

  @override
  Map<String, Object?> toJson() => _$TestExclusionToJson(this);

  @override
  String get runtimeTypeName => 'TestExclusion';
}

enum TestStatus {
  success,
  failure,
  @JsonValue('n/a')
  na;
}

/// An inidividual test result.
@_serializable
final class TestResult
    with AWSSerializable<Map<String, Object?>>, AWSDebuggable {
  const TestResult({
    required this.status,
    this.reason,
    this.url,
  });

  factory TestResult.fromJson(Map<String, Object?> json) =>
      _$TestResultFromJson(json);

  /// The status of execution.
  final TestStatus status;

  /// The status reason (displayed as a tooltip if defined).
  final String? reason;

  /// An optional URL of this status.
  final String? url;

  @override
  Map<String, Object?> toJson() => _$TestResultToJson(this);

  @override
  String get runtimeTypeName => 'TestResult';
}

/// Language specific compliance report.
typedef Report = Map<Language, TestResult>;

typedef Language = String;
