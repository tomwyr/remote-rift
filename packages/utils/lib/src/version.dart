import 'package:equatable/equatable.dart';

class Version extends Equatable {
  Version({required this.major, required this.minor, required this.patch});

  String get stringValue => '$major.$minor.$patch';

  factory Version.parse(String input) {
    final regex = RegExp(r'^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:\+\d+)?$');
    final match = regex.firstMatch(input);
    if (match == null) {
      throw VersionError.invalidInput;
    }

    final major = int.parse(match.group(1)!);
    final minor = int.parse(match.group(2)!);
    final patch = int.parse(match.group(3)!);
    return Version(major: major, minor: minor, patch: patch);
  }

  final int major;
  final int minor;
  final int patch;

  bool isAtLeast(Version other, {VersionComponent upTo = .patch}) {
    return switch (upTo) {
      .major => major >= other.major,
      .minor => major > other.major || major == other.major && minor >= other.minor,
      .patch =>
        major > other.major ||
            major == other.major && minor > other.minor ||
            major == other.major && minor == other.minor && patch >= other.patch,
    };
  }

  bool isGreaterThan(Version other, {VersionComponent upTo = .patch}) {
    return switch (upTo) {
      .major => major > other.major,
      .minor => major > other.major || major == other.major && minor > other.minor,
      .patch =>
        major > other.major ||
            major == other.major && minor > other.minor ||
            major == other.major && minor == other.minor && patch > other.patch,
    };
  }

  @override
  List<Object?> get props => [major, minor, patch];
}

enum VersionComponent { major, minor, patch }

enum VersionError implements Exception { invalidInput }
