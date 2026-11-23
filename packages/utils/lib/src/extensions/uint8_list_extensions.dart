import 'dart:typed_data';

extension Uint8ListExtensions on Uint8List {
  /// Yields byte views that include their terminating newline.
  ///
  /// Skips any trailing bytes after the last newline.
  Iterable<Uint8List> completeLines() sync* {
    const newline = 0x0a;
    var start = 0;
    for (var end = 0; end < length; end++) {
      final byte = this[end];
      if (byte != newline) {
        continue;
      }

      yield .sublistView(this, start, end + 1);
      start = end + 1;
    }
  }
}
