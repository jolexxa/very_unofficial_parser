import 'package:test/test.dart';
import 'package:very_unofficial_lexer/src/lang/token_type.dart';
import 'package:very_unofficial_lexer/src/lexical/lexical.dart';
import 'package:very_unofficial_lexer/src/tokens/tokens.dart';

void main() {
  const state = LexerState(
    position: Position.zero,
    length: 8,
    lexeme: 'r"hello"',
  );

  final tokenA = StringToken(
    state: state,
    value: 'hello',
    isClosed: true,
    isRaw: true,
    isMultiline: false,
  );

  final tokenAClone = StringToken(
    state: const LexerState(
      position: Position.zero,
      length: 8,
      lexeme: 'r"hello"',
    ),
    value: 'hello',
    isClosed: true,
    isRaw: true,
    isMultiline: false,
  );

  final tokenB = StringToken(
    state: const LexerState(
      position: Position.zero,
      length: 8,
      lexeme: 'r"hell0"',
    ),
    value: 'hell0',
    isClosed: true,
    isRaw: true,
    isMultiline: false,
  );

  test('equatable', () {
    expect(tokenA == tokenAClone, isTrue);
    expect(tokenA == tokenB, isFalse);
  });

  test('type', () {
    expect(tokenA.type, TokenType.string);
  });

  test('toString()', () {
    expect(tokenA.toString(), 'string(`hello`)');
  });

  group('InterpolationSpan:', () {
    test('initializes', () {
      const id = 'id';
      final interpolation = InterpolationSpan(start: Position.zero, id: id);
      expect(interpolation.start, Position.zero);
      expect(interpolation.id, id);
      expect(interpolation.end, 2);
    });

    test('equatable', () {
      final a = InterpolationSpan(start: Position.zero, id: 'a');
      final b = InterpolationSpan(start: Position.one, id: 'b');
      expect(a == b, isFalse);
      expect(a == a, isTrue);
      expect(b == b, isTrue);
    });

    test('toString', () {
      final interpolation = InterpolationSpan(start: Position.zero, id: 'a');
      expect(
        interpolation.toString(),
        'InterpolationSpan(start: ${Position.zero.toString()}, id: a)',
      );
    });
  });

  group('InterpolatedStringToken', () {
    test('equatable', () {
      final a = InterpolatedStringToken(
        state: state,
        isClosed: true,
        isMultiline: false,
        spans: [ContentSpan('hello')],
      );
      final b = InterpolatedStringToken(
        state: state,
        isClosed: true,
        isMultiline: false,
        spans: [ContentSpan('goodbye')],
      );
      expect(a == b, isFalse);
      expect(a == a, isTrue);
      expect(b == b, isTrue);
    });
  });
}
