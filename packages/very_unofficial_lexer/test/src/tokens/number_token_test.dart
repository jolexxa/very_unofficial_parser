import 'package:test/test.dart';
import 'package:very_unofficial_lexer/src/lang/lang.dart';
import 'package:very_unofficial_lexer/src/lexical/lexical.dart';
import 'package:very_unofficial_lexer/src/tokens/tokens.dart';

void main() {
  final tokenA = NumberToken(
      state: const LexerState(
          position: Position.zero, length: 1, lexeme: '10.13e-10'),
      base: NumericLiteral.decimal);
  final tokenAClone = NumberToken(
      state: const LexerState(
          position: Position.zero, length: 1, lexeme: '10.13e-10'),
      base: NumericLiteral.decimal);
  final tokenB = NumberToken(
      state: const LexerState(position: Position.one, length: 1, lexeme: '42'),
      base: NumericLiteral.hexadecimal);

  group('equatable:', () {
    test('implements equatable correctly', () {
      expect(tokenA == tokenAClone, isTrue);
      expect(tokenA == tokenB, isFalse);
    });
  });

  group('toString():', () {
    test('describes token', () {
      expect(tokenA.toString(), 'number(`10.13e-10`)');
    });
  });

  group('value', () {
    test('returns the value of the number', () {
      expect(tokenA.value, 10.13e-10);
      expect(tokenB.value, 42);
    });
  });
}
