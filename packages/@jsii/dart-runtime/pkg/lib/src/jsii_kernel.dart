/// Common kernel types of the JSII runtime.
library jsii_kernel;

import 'package:aws_common/aws_common.dart';
import 'package:json_annotation/json_annotation.dart';

part 'jsii_kernel.g.dart';

const _serializable = JsonSerializable(
  createFactory: false,
  explicitToJson: true,
);

final class JsiiFqn with AWSEquatable<JsiiFqn>, AWSSerializable<String> {
  const JsiiFqn({
    required this.fqn,
    required this.namespace,
    required this.type,
  });

  factory JsiiFqn.parse(String fqn) {
    return switch (fqn.split('.')) {
      [final String unqualified] => UnqualifiedJsiiFqn(
          fqn: fqn,
          type: unqualified,
        ),
      [final String namespace, final String type] => QualifiedJsiiFqn(
          fqn: fqn,
          namespace: namespace,
          type: type,
        ),
      _ => throw ArgumentError.value(fqn, 'fqn', 'Invalid FQN'),
    };
  }

  factory JsiiFqn.fromJson(String json) => JsiiFqn.parse(json);

  /// The FQN of the unqualifed `Object` type.
  static const JsiiFqn object = UnqualifiedJsiiFqn(
    fqn: 'Object',
    type: 'Object',
  );

  /// The fully qualified name of the type.
  final String fqn;

  /// The namespace of the type.
  ///
  /// If the type is not namespaced (unqualified), this will be `null`.
  final String? namespace;

  /// The name of the type.
  final String type;

  @override
  List<Object?> get props => [fqn];

  @override
  String toJson() => fqn;

  @override
  String toString() => fqn;
}

final class QualifiedJsiiFqn extends JsiiFqn {
  const QualifiedJsiiFqn({
    required super.fqn,
    required String super.namespace,
    required super.type,
  });
}

final class UnqualifiedJsiiFqn extends JsiiFqn {
  const UnqualifiedJsiiFqn({
    required super.fqn,
    required super.type,
  }) : super(namespace: null);
}

final class JsiiKernelTypes {
  const JsiiKernelTypes._();

  static const JsiiFqn fault = JsiiFqn(
    fqn: '@jsii/kernel.Fault',
    namespace: '@jsii/kernel',
    type: 'Fault',
  );
  static const JsiiFqn runtimeError = JsiiFqn(
    fqn: '@jsii/kernel.RuntimeError',
    namespace: '@jsii/kernel',
    type: 'RuntimeError',
  );
}

abstract mixin class ObjectReference
    implements AWSSerializable<Map<String, Object?>> {
  const factory ObjectReference(String byRef) = _ObjectReference;

  factory ObjectReference.fromJson(Map<String, Object?> json) {
    if (json case {r'$jsii.byref': final String byRef}) {
      return ObjectReference(byRef);
    }
    throw ArgumentError.value(json, 'json', 'Invalid object reference');
  }

  /// A handle that uniquely identifies an instance.
  String get byRef;

  /// The object instance's base class' jsii fully qualified name.
  JsiiFqn get fqn => JsiiFqn.parse((byRef.split('@')..removeLast()).join());

  /// The object's opaque numeric identifier.
  int get id => int.parse(byRef.split('@').last);
}

@_serializable
final class _ObjectReference with ObjectReference {
  const _ObjectReference(this.byRef);

  @override
  @JsonKey(name: r'$jsii.byref')
  final String byRef;

  @override
  Map<String, Object?> toJson() => _$ObjectReferenceToJson(this);
}

final class JsonObject with AWSSerializable<Object?> {
  const JsonObject(this.value);

  const JsonObject.fromJson(this.value);

  final Object? value;

  @override
  Object? toJson() => value;

  @override
  String toString() => value.toString();
}
