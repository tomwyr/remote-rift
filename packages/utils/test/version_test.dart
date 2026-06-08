import 'package:remote_rift_utils/src/version.dart';
import 'package:test/test.dart';

void main() {
  group('parse', () {
    test('parses valid version', () {
      final v = Version.parse('1.2.3');
      expect(v, Version(major: 1, minor: 2, patch: 3));
    });

    test('parses version with build metadata', () {
      final v = Version.parse('1.2.3+45');
      expect(v, Version(major: 1, minor: 2, patch: 3));
    });

    test('throws on invalid input', () {
      expect(() => Version.parse('1.2'), throwsA(VersionError.invalidInput));
      expect(() => Version.parse('a.b.c'), throwsA(VersionError.invalidInput));
      expect(() => Version.parse('01.2.3'), throwsA(VersionError.invalidInput));
    });
  });

  group('stringValue', () {
    test('returns correct string representation', () {
      expect(Version(major: 1, minor: 2, patch: 3).stringValue, '1.2.3');
      expect(Version(major: 0, minor: 0, patch: 0).stringValue, '0.0.0');
      expect(Version(major: 10, minor: 20, patch: 30).stringValue, '10.20.30');
    });
  });

  group('equals', () {
    test('versions with same values are equal', () {
      expect(Version(major: 1, minor: 2, patch: 3), Version(major: 1, minor: 2, patch: 3));
    });

    test('different versions are not equal', () {
      expect(Version(major: 1, minor: 2, patch: 3), isNot(Version(major: 1, minor: 2, patch: 4)));
    });
  });

  group('isAtLeast', () {
    test('up to major', () {
      final v = Version(major: 2, minor: 3, patch: 4);

      expect(v.isAtLeast(Version(major: 1, minor: 0, patch: 0), upTo: .major), isTrue);
      expect(v.isAtLeast(Version(major: 1, minor: 5, patch: 6), upTo: .major), isTrue);
      expect(v.isAtLeast(Version(major: 2, minor: 2, patch: 2), upTo: .major), isTrue);
      expect(v.isAtLeast(Version(major: 2, minor: 3, patch: 3), upTo: .major), isTrue);
      expect(v.isAtLeast(Version(major: 2, minor: 3, patch: 4), upTo: .major), isTrue);
      expect(v.isAtLeast(Version(major: 2, minor: 3, patch: 5), upTo: .major), isTrue);
      expect(v.isAtLeast(Version(major: 2, minor: 4, patch: 5), upTo: .major), isTrue);
      expect(v.isAtLeast(Version(major: 3, minor: 0, patch: 0), upTo: .major), isFalse);
    });

    test('up to minor', () {
      final v = Version(major: 2, minor: 3, patch: 4);

      expect(v.isAtLeast(Version(major: 1, minor: 0, patch: 0), upTo: .minor), isTrue);
      expect(v.isAtLeast(Version(major: 1, minor: 5, patch: 6), upTo: .minor), isTrue);
      expect(v.isAtLeast(Version(major: 2, minor: 2, patch: 2), upTo: .minor), isTrue);
      expect(v.isAtLeast(Version(major: 2, minor: 3, patch: 3), upTo: .minor), isTrue);
      expect(v.isAtLeast(Version(major: 2, minor: 3, patch: 4), upTo: .minor), isTrue);
      expect(v.isAtLeast(Version(major: 2, minor: 3, patch: 5), upTo: .minor), isTrue);
      expect(v.isAtLeast(Version(major: 2, minor: 4, patch: 5), upTo: .minor), isFalse);
      expect(v.isAtLeast(Version(major: 3, minor: 0, patch: 0), upTo: .minor), isFalse);
    });

    test('up to patch', () {
      final v = Version(major: 2, minor: 3, patch: 4);

      expect(v.isAtLeast(Version(major: 1, minor: 0, patch: 0), upTo: .patch), isTrue);
      expect(v.isAtLeast(Version(major: 1, minor: 5, patch: 6), upTo: .patch), isTrue);
      expect(v.isAtLeast(Version(major: 2, minor: 2, patch: 2), upTo: .patch), isTrue);
      expect(v.isAtLeast(Version(major: 2, minor: 3, patch: 3), upTo: .patch), isTrue);
      expect(v.isAtLeast(Version(major: 2, minor: 3, patch: 4), upTo: .patch), isTrue);
      expect(v.isAtLeast(Version(major: 2, minor: 3, patch: 5), upTo: .patch), isFalse);
      expect(v.isAtLeast(Version(major: 2, minor: 4, patch: 5), upTo: .patch), isFalse);
      expect(v.isAtLeast(Version(major: 3, minor: 0, patch: 0), upTo: .patch), isFalse);
    });
  });

  group('isGreaterThan', () {
    test('up to major', () {
      final v = Version(major: 2, minor: 3, patch: 4);

      expect(v.isGreaterThan(Version(major: 1, minor: 0, patch: 0), upTo: .major), isTrue);
      expect(v.isGreaterThan(Version(major: 1, minor: 5, patch: 6), upTo: .major), isTrue);
      expect(v.isGreaterThan(Version(major: 2, minor: 2, patch: 2), upTo: .major), isFalse);
      expect(v.isGreaterThan(Version(major: 2, minor: 3, patch: 3), upTo: .major), isFalse);
      expect(v.isGreaterThan(Version(major: 2, minor: 3, patch: 4), upTo: .major), isFalse);
      expect(v.isGreaterThan(Version(major: 2, minor: 3, patch: 5), upTo: .major), isFalse);
      expect(v.isGreaterThan(Version(major: 2, minor: 4, patch: 5), upTo: .major), isFalse);
      expect(v.isGreaterThan(Version(major: 3, minor: 0, patch: 0), upTo: .major), isFalse);
    });

    test('up to minor', () {
      final v = Version(major: 2, minor: 3, patch: 4);

      expect(v.isGreaterThan(Version(major: 1, minor: 0, patch: 0), upTo: .minor), isTrue);
      expect(v.isGreaterThan(Version(major: 1, minor: 5, patch: 6), upTo: .minor), isTrue);
      expect(v.isGreaterThan(Version(major: 2, minor: 2, patch: 2), upTo: .minor), isTrue);
      expect(v.isGreaterThan(Version(major: 2, minor: 3, patch: 3), upTo: .minor), isFalse);
      expect(v.isGreaterThan(Version(major: 2, minor: 3, patch: 4), upTo: .minor), isFalse);
      expect(v.isGreaterThan(Version(major: 2, minor: 3, patch: 5), upTo: .minor), isFalse);
      expect(v.isGreaterThan(Version(major: 2, minor: 4, patch: 5), upTo: .minor), isFalse);
      expect(v.isGreaterThan(Version(major: 3, minor: 0, patch: 0), upTo: .minor), isFalse);
    });

    test('up to patch', () {
      final v = Version(major: 2, minor: 3, patch: 4);

      expect(v.isGreaterThan(Version(major: 1, minor: 0, patch: 0), upTo: .patch), isTrue);
      expect(v.isGreaterThan(Version(major: 1, minor: 5, patch: 6), upTo: .patch), isTrue);
      expect(v.isGreaterThan(Version(major: 2, minor: 2, patch: 2), upTo: .patch), isTrue);
      expect(v.isGreaterThan(Version(major: 2, minor: 3, patch: 3), upTo: .patch), isTrue);
      expect(v.isGreaterThan(Version(major: 2, minor: 3, patch: 4), upTo: .patch), isFalse);
      expect(v.isGreaterThan(Version(major: 2, minor: 3, patch: 5), upTo: .patch), isFalse);
      expect(v.isGreaterThan(Version(major: 2, minor: 4, patch: 5), upTo: .patch), isFalse);
      expect(v.isGreaterThan(Version(major: 3, minor: 0, patch: 0), upTo: .patch), isFalse);
    });
  });
}
