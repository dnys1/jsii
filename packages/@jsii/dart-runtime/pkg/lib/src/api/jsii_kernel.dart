/// Common kernel types of the JSII runtime.
library jsii_kernel;

import 'package:aws_common/aws_common.dart';

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
