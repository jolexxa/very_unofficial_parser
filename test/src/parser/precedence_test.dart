import 'package:test/test.dart';
import 'package:very_unofficial_parser/src/parser/precedence.dart';

void main() {
  group('PrecedenceExtensions', () {
    test('subtraction', () {
      expect(Precedence.additive - 1, Precedence.shift);
    });

    test('less than', () {
      expect(Precedence.additive < Precedence.shift, isFalse);
      expect(Precedence.shift < Precedence.additive, isTrue);
    });
  });
}
