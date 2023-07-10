import 'package:aws_common/aws_common.dart';
import 'package:jsii_runtime/src/api/jsii_kernel.dart';
import 'package:jsii_runtime/src/api/jsii_object_descriptor.dart';
import 'package:json_annotation/json_annotation.dart';

part 'jsii_enum.dart';
part 'jsii_kernel_object.g.dart';

const _serializable = JsonSerializable(
  createFactory: false,
  explicitToJson: true,
);

sealed class JsiiKernelObject with AWSSerializable<Object?> {
  factory JsiiKernelObject(Object? value) {
    return switch (value) {
      String _ || num _ || bool _ || null => JsiiPrimitive(value),
      DateTime _ => JsonDate(value),
      JsiiEnum _ => value,
      JsiiEnumMixin _ => JsiiEnum(value),
      Map<String, Object?> _ => JsiiMap(
          value.map((key, value) => MapEntry(key, JsiiKernelObject(value))),
        ),
      JsiiObjectRef _ => value,
      JsiiObject _ => value,
      _ => throw ArgumentError.value(value, 'value', 'Invalid kernel object'),
    };
  }

  const JsiiKernelObject._();

  factory JsiiKernelObject.fromJson(Object? json) {
    return switch (json) {
      String _ || num _ || bool _ || null => JsiiPrimitive(json),
      {r'$jsii.date': final String date} => JsonDate(DateTime.parse(date)),
      {r'$jsii.enum': final String qualifiedEnum} =>
        JsiiEnum.fromJson(qualifiedEnum),
      {r'$jsii.map': final Map<String, Object?> values} => JsiiMap(
          values.map(
            (key, value) => MapEntry(key, JsiiKernelObject.fromJson(value)),
          ),
        ),
      {r'$jsii.byref': final String objRef?} => JsiiObjectRef(
          objRef,
          interfaces: (json[r'$jsii.interfaces'] as List<String>?)
              ?.map(JsiiFqn.parse)
              .toList(),
        ),
      {
        r'$jsii.struct': {
          'fqn': final String fqn,
          'data': final Map<String, Object?> data
        }
      } =>
        JsiiObject.fromJson(JsiiFqn.parse(fqn), data),
      _ => throw ArgumentError.value(json, 'json', 'Invalid kernel object'),
    };
  }

  Object? get value;
}

final class JsiiPrimitive extends JsiiKernelObject {
  const JsiiPrimitive(this.value) : super._();

  @override
  final Object? value;

  @override
  Object? toJson() => value;
}

final class JsonDate extends JsiiKernelObject {
  const JsonDate(this.value) : super._();

  @override
  final DateTime value;

  @override
  Map<String, Object?> toJson() => {
        r'$jsii.date': value.toIso8601String(),
      };
}

final class JsiiEnum extends JsiiKernelObject {
  const JsiiEnum(this.value) : super._();

  factory JsiiEnum.fromJson(String qualifiedName) {
    throw UnimplementedError(qualifiedName);
  }

  @override
  final JsiiEnumMixin value;

  @override
  Map<String, Object?> toJson() => {
        r'$jsii.enum': '${value.fqn}/${value.entryName}',
      };
}

final class JsiiMap extends JsiiKernelObject {
  const JsiiMap(this.value) : super._();

  @override
  final Map<String, Object?> value;

  @override
  Map<String, Object?> toJson() => value;
}

@_serializable
class JsiiObjectRef implements JsiiKernelObject {
  const JsiiObjectRef(this.byRef, {this.interfaces});

  factory JsiiObjectRef.fromJson(Map<String, Object?> json) {
    if (json case {r'$jsii.byref': final String byRef}) {
      return JsiiObjectRef(byRef);
    }
    throw ArgumentError.value(json, 'json', 'Invalid object reference');
  }

  /// A handle that uniquely identifies an instance.
  @JsonKey(name: r'$jsii.byref')
  final String byRef;

  @JsonKey(name: r'$jsii.interfaces')
  final List<JsiiFqn>? interfaces;

  /// The object instance's base class' jsii fully qualified name.
  JsiiFqn get fqn => JsiiFqn.parse((byRef.split('@')..removeLast()).join());

  /// The object's opaque numeric identifier.
  int get id => int.parse(byRef.split('@').last);

  @override
  Object? get value => this;

  @override
  Map<String, Object?> toJson() => _$JsiiObjectRefToJson(this);
}

abstract base class JsiiObject extends JsiiKernelObject {
  factory JsiiObject.fromJson(JsiiFqn fqn, Map<String, Object?> data) {
    throw UnimplementedError('$fqn $data');
  }

  JsiiObjectDescriptor get descriptor;

  @override
  Object? get value => this;
}
