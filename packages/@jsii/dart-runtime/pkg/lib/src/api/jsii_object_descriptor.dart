import 'package:jsii_runtime/src/api/jsii_kernel.dart';
import 'package:jsii_runtime/src/api/jsii_kernel_object.dart';

abstract base class JsiiObjectDescriptor<T extends JsiiObject> {
  JsiiObjectDescriptor(this.fqn, this.create);

  final JsiiFqn fqn;
  final T Function(JsiiObjectRef ref) create;

  Object? getProperty(String property);
  void setProperty(String property, Object? value);
  Object? invokeMethod(String method, [List<Object?> args = const []]);
}
