import 'package:aws_common/aws_common.dart';
import 'package:json_annotation/json_annotation.dart';

part 'report.g.dart';

const _serializable = JsonSerializable(
  createFactory: false,
  explicitToJson: true,
);

final class TestReport
    with AWSSerializable<Map<String, Object?>>, AWSDebuggable {
  const TestReport({
    required this.categories,
  });

  final List<TestCategory> categories;

  @override
  Map<String, Object?> toJson() => {
        for (final category in categories) category.name: category.toJson(),
      };

  @override
  String get runtimeTypeName => 'TestReport';
}

final class TestCategory
    with AWSSerializable<Map<String, Object?>>, AWSDebuggable {
  const TestCategory({
    required this.name,
    required this.results,
  });

  final String name;
  final List<TestResult> results;

  @override
  Map<String, Object?> toJson() => {
        for (final test in results) test.name: test.toJson(),
      };

  @override
  String get runtimeTypeName => 'TestCategory';
}

@JsonEnum(fieldRename: FieldRename.screamingSnake)
enum TestStatus { pass, fail }

@_serializable
final class TestResult
    with AWSSerializable<Map<String, Object?>>, AWSDebuggable {
  const TestResult({
    required this.name,
    required this.status,
    required this.kernelTrace,
  });

  /// The name of the test.
  @JsonKey(includeToJson: false)
  final String name;

  /// Whether the test passed or failed.
  final TestStatus status;

  /// The kernel messages captured during the test.
  final List<KernelMessage> kernelTrace;

  @override
  Map<String, Object?> toJson() => _$TestResultToJson(this);

  @override
  String get runtimeTypeName => 'TestResult';
}

@JsonEnum(fieldRename: FieldRename.pascal)
enum MessageDirection { fromKernel, toKernel }

@_serializable
final class KernelMessage
    with AWSSerializable<Map<String, Object?>>, AWSDebuggable {
  const KernelMessage({
    required this.direction,
    required this.message,
  });

  /// The direction the message was sent (Host -> Kernel / Kernel -> Host).
  final MessageDirection direction;

  /// The message, as a JSON object.
  final Map<String, Object?> message;

  @override
  Map<String, Object?> toJson() => _$KernelMessageToJson(this);

  @override
  String get runtimeTypeName => 'KernelMessage';
}
