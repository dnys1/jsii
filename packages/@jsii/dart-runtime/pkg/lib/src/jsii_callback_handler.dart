import 'dart:async';

import 'package:jsii_runtime/src/api/jsii_kernel_object.dart';
import 'package:jsii_runtime/src/api/jsii_response.dart';

abstract interface class JsiiCallbackHandler {
  /// Handles a callback from the JSII kernel to a Dart function.
  FutureOr<JsiiKernelObject> handleCallback(Callback callback);
}
