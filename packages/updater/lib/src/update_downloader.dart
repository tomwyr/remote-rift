import 'dart:async';
import 'dart:io';

import 'package:http/http.dart';
import 'package:path/path.dart';

import 'models.dart';

class UpdateDownloader({
  final int _downloadAttempts = 3,
  final int _maxArchiveBytes = 1024 * 1024 * 1024,
  final Duration _requestTimeout = const Duration(seconds: 30),
  Client? client,
}) {
  this : assert(_downloadAttempts > 0, 'Download attempts must be positive.');

  final Client _client = client ?? Client();

  Future<String> download({required UpdateArtifact artifact}) {
    _validateArtifact(artifact);

    return _withStagedFile(artifact, (download) async {
      for (var attempt = 0; attempt < _downloadAttempts; attempt++) {
        try {
          final response = await _fetch(artifact);
          await _save(response, artifact, download);
          return download.path;
        } catch (error, stackTrace) {
          _handleAttemptFailure(error, stackTrace, attempt);
        }
      }
      return download.path;
    });
  }

  void _validateArtifact(UpdateArtifact artifact) {
    if (artifact.downloadUrl.scheme != 'https' || artifact.size < 0) {
      throw UpdateDownloadError.invalidArtifact;
    }
    if (artifact.size > _maxArchiveBytes) {
      throw UpdateDownloadError.archiveTooLarge;
    }
  }

  Future<T> _withStagedFile<T>(
    UpdateArtifact artifact,
    Future<T> Function(File download) action,
  ) async {
    final staging = await Directory.systemTemp.createTemp('updater-update-');
    final download = File(join(staging.path, artifact.name));
    try {
      return await action(download);
    } catch (_) {
      if (await staging.exists()) {
        await staging.delete(recursive: true);
      }
      rethrow;
    }
  }

  Future<StreamedResponse> _fetch(UpdateArtifact artifact) async {
    final request = Request('GET', artifact.downloadUrl);
    final response = await _client.send(request).timeout(_requestTimeout);
    if (response.statusCode != HttpStatus.ok) {
      throw UpdateDownloadError.downloadFailed;
    }
    return response;
  }

  Future<void> _save(
    StreamedResponse response,
    UpdateArtifact artifact,
    File output,
  ) async {
    final length = response.contentLength;
    if (length != null && (length != artifact.size || length > _maxArchiveBytes)) {
      throw UpdateDownloadError.invalidResponse;
    }

    final sink = output.openWrite();
    var received = 0;
    try {
      await for (final chunk in response.stream.timeout(_requestTimeout)) {
        received += chunk.length;
        if (received > _maxArchiveBytes || received > artifact.size) {
          throw UpdateDownloadError.archiveTooLarge;
        }
        sink.add(chunk);
      }
      if (received != artifact.size) {
        throw UpdateDownloadError.invalidResponse;
      }
    } finally {
      await sink.close();
    }
  }

  void _handleAttemptFailure(Object error, StackTrace stackTrace, int attempt) {
    final _rethrow = Error.throwWithStackTrace;
    final lastAttempt = attempt == _downloadAttempts - 1;

    switch (error) {
      case UpdateDownloadError.archiveTooLarge || UpdateDownloadError.invalidResponse:
        _rethrow(error, stackTrace);

      case UpdateDownloadError():
        if (lastAttempt) {
          _rethrow(error, stackTrace);
        }

      case SocketException() || TimeoutException() || ClientException():
        if (lastAttempt) {
          throw UpdateDownloadError.downloadFailed;
        }

      default:
        _rethrow(error, stackTrace);
    }
  }
}

enum UpdateDownloadError implements Exception {
  invalidArtifact,
  invalidResponse,
  archiveTooLarge,
  downloadFailed,
}
