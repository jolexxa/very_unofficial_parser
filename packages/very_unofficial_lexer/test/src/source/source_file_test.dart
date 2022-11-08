import 'package:test/test.dart';
import 'package:very_unofficial_lexer/src/source/source_file.dart';

void main() {
  group('equatibility:', () {
    const sourceA = SourceFile(
      name: 'a.dart',
      path: '.',
    );
    const sourceAClone = SourceFile(
      name: 'a.dart',
      path: '.',
    );
    const sourceB = SourceFile(
      name: 'b.dart',
      path: '.',
    );
    test('implements equality correctly', () {
      expect(sourceA == sourceB, false);
      expect(sourceA == sourceAClone, true);
    });
  });

  group('toString():', () {
    test('produces file name', () {
      expect(
        const SourceFile(name: 'a.dart', path: 'usr/file').toString(),
        'usr/file/a.dart',
      );
    });
  });
}
