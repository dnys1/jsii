@internal
library;

import 'package:meta/meta.dart';

abstract class JsiiModule {
  const JsiiModule({
    required this.name,
    required this.version,
    required this.tarball,
  });

  final String name;
  final String version;
  final String tarball;

  List<JsiiModule> get dependencies => const [];
}
