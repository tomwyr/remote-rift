import 'dart:convert';
import 'dart:typed_data';

class LogContents(
  final List<LogLine> _lines,
  var int _byteLength,
  var DateTime? _oldestTimestamp,
) {
  factory empty() => LogContents([], 0, null);

  bool get isEmpty => _lines.isEmpty;

  int get byteLength => _byteLength;

  Uint8List toBytes() {
    final bytes = BytesBuilder(copy: false);
    for (final line in _lines) {
      bytes.add(line.bytes);
    }
    return bytes.takeBytes();
  }

  void add(LogLine line) {
    _lines.add(line);
    _byteLength += line.bytes.length;
    _oldestTimestamp = _earliestTimestamp(_oldestTimestamp, line.timestamp);
  }

  LogContents pruned(DateTime cutoff, int maxBytes) {
    final hasExpiredLines = _oldestTimestamp?.isBefore(cutoff) ?? false;
    if (!hasExpiredLines && _byteLength <= maxBytes) return this;

    final unexpiredLines = _lines.reversed.where((line) => !line.timestamp.isBefore(cutoff));
    return _fitToSize(unexpiredLines, maxBytes);
  }

  LogContents _fitToSize(Iterable<LogLine> lines, int maxBytes) {
    final retained = <LogLine>[];
    var byteLength = 0;
    DateTime? oldestTimestamp;
    for (final line in lines) {
      final nextByteLength = byteLength + line.bytes.length;
      if (nextByteLength > maxBytes) {
        break;
      }
      retained.add(line);
      byteLength = nextByteLength;
      oldestTimestamp = _earliestTimestamp(oldestTimestamp, line.timestamp);
    }
    final orderedLines = [...retained.reversed];
    return LogContents(orderedLines, byteLength, oldestTimestamp);
  }

  DateTime _earliestTimestamp(DateTime? oldest, DateTime timestamp) {
    return oldest == null || timestamp.isBefore(oldest) ? timestamp : oldest;
  }
}

class LogLine(final DateTime timestamp, final List<int> bytes) {
  static LogLine? fromBytes(List<int> bytes) {
    try {
      final json = jsonDecode(utf8.decode(bytes));
      if (json case {'timestamp': String timestamp}) {
        if (DateTime.tryParse(timestamp) case var parsed?) {
          return LogLine(parsed, bytes);
        }
      }
    } on FormatException {
      // Skip malformed lines to recover intact records after an interrupted write.
    }
    return null;
  }
}
