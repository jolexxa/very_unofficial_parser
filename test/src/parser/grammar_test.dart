import 'package:test/test.dart';
import 'package:very_unofficial_parser/src/parser/grammar.dart';

void main() {
  group('expressionTable', () {
    test('is initialized', () {
      expect(Grammar.expressionTable, isNotNull);
    });
  });
}
