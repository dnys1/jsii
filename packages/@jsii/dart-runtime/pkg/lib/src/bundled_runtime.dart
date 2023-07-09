import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:aws_common/aws_common.dart';
import 'package:jsii_runtime/src/tarball.dart';
import 'package:path/path.dart' as p;
import 'package:tar/tar.dart';

final class BundledRuntime implements Closeable {
  final _extractMemo = AsyncMemoizer<Directory>();

  /// Extracts the bundled runtime to a temporary directory and returns the
  /// directory.
  ///
  /// This method is idempotent.
  Future<Directory> load() => _extractMemo.runOnce(() async {
        final tempDir =
            await Directory.systemTemp.createTemp('jsii-runtime-dart');

        await TarReader.forEach(Stream.value(tarball), (entry) async {
          final path = entry.name;
          final contents = await utf8.decodeStream(entry.contents);
          final file = File(p.join(tempDir.path, path));
          await file.create(recursive: true);
          await file.writeAsString(contents);
        });

        return tempDir;
      });

  @override
  Future<void> close() async {
    if (!_extractMemo.hasRun) {
      return;
    }
    final tempDir = await _extractMemo.future;
    await tempDir.delete(recursive: true);
  }
}
