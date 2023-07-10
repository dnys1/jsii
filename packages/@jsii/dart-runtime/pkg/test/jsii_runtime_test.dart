import 'package:jsii_runtime/src/api/jsii_kernel.dart';
import 'package:jsii_runtime/src/jsii_client.dart';
import 'package:test/test.dart';

void main() {
  group('JsiiRuntime', () {
    test('with no customizations', () async {
      final client = await JsiiClient.start();
      addTearDown(client.close);
      await expectLater(
        client.createObject(fqn: JsiiFqn.object),
        completes,
      );
    });

    test('with custom Node', () async {
      final client = await JsiiClient.start(
        nodeExecutable: 'node --max_old_space_size=1024',
      );
      addTearDown(client.close);
      await expectLater(
        client.createObject(fqn: JsiiFqn.object),
        completes,
      );
    });

    test('with custom runtime', () async {
      final client = await JsiiClient.start(
        runtime: 'node ./test-runtime/bin/jsii-runtime.js',
      );
      addTearDown(client.close);
      await expectLater(
        client.createObject(fqn: JsiiFqn.object),
        completes,
      );
    });
  });
}
