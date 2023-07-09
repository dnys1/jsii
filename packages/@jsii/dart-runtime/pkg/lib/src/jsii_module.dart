import 'package:meta/meta.dart';

abstract class JsiiModule {
  const JsiiModule({
    required this.name,
    required this.version,
    required this.resourceName,
  });

  final String name;
  final String version;
  final String resourceName;

  @protected
  List<JsiiModule> get dependencies => const [];
}
