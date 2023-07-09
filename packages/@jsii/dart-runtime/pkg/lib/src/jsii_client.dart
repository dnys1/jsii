import 'package:jsii_runtime/src/jsii_module.dart';
import 'package:jsii_runtime/src/jsii_request.dart';
import 'package:jsii_runtime/src/jsii_runtime.dart';

final class JsiiClient {
  JsiiClient(this._runtime);

  final JsiiRuntime _runtime;

  /// Loads a JavaScript module into the remote sandbox.
  Future<void> loadModule(JsiiModule module) async {
    final request = JsiiRequest.load(
      tarball: 'tarball', // TODO
      name: module.name,
      version: module.version,
    );
  }
}
