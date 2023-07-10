import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:amplify_core/amplify_core.dart';
import 'package:async/async.dart';
import 'package:jsii_runtime/src/version.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:tar/tar.dart';

/// Prepares the JSII runtime for spawning.
///
/// If a local JSII runtime is not found, this will download and extract it.
final class RuntimeLoader implements Closeable {
  RuntimeLoader(this._dependencyManager);

  final DependencyManager _dependencyManager;
  final AsyncMemoizer<Directory> _memoizer = AsyncMemoizer();

  AWSHttpClient get _client => _dependencyManager.getOrCreate();

  /// The URI of the gziped tarball containing the JSII runtime for the given
  /// [version].
  @visibleForTesting
  static Uri downloadUri([String version = packageVersion]) => Uri.parse(
        'https://registry.npmjs.org/@jsii/runtime/-/runtime-$version.tgz',
      );

  /// Downloads the JSII runtime for the given [version] and returns the stream
  /// for the gziped tarball.
  @visibleForTesting
  Future<Stream<List<int>>> download([String version = packageVersion]) async {
    final uri = downloadUri(version);
    final request = AWSHttpRequest.get(uri);
    final response = await _client.send(request).response;
    if (response.statusCode != 200) {
      String? body;
      try {
        body = await response.decodeBody();
      } on Object {
        // OK
      }
      throw AWSHttpException(request, body);
    }
    return response.body;
  }

  /// Extracts the JSII runtime from the given [tarball] into the given
  /// [directory].
  @visibleForTesting
  Future<void> extract(Stream<List<int>> tarball, Directory directory) async {
    tarball = tarball.transform(gzip.decoder);
    await TarReader.forEach(tarball, (entry) async {
      final path = entry.name;
      final contents = await utf8.decodeStream(entry.contents);
      final file = File(p.join(directory.path, path));
      await file.create(recursive: true);
      await file.writeAsString(contents);
    });
  }

  /// Loads the JSII runtime into a temporary directory and returns the
  /// directory.
  Future<Directory> load() => _memoizer.runOnce(() async {
        final tempDir =
            await Directory.systemTemp.createTemp('jsii-runtime-dart');

        final tarball = await download();
        await extract(tarball, tempDir);

        return tempDir;
      });

  @override
  Future<void> close() async {
    if (!_memoizer.hasRun) {
      return;
    }
    final tempDir = await _memoizer.future;
    await tempDir.delete(recursive: true);
  }
}
