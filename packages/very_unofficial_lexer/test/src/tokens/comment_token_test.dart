import 'package:test/test.dart';
import 'package:very_unofficial_lexer/src/lexical/lexical.dart';
import 'package:very_unofficial_lexer/src/tokens/tokens.dart';

void main() {
  final tokenA = CommentToken(
    state: const LexerState(
      position: Position(
        index: 15,
        line: 1,
        col: 15,
      ),
      length: 5,
      lexeme: '// hi',
    ),
  );

  final tokenAClone = CommentToken(
    state: const LexerState(
      position: Position(
        index: 15,
        line: 1,
        col: 15,
      ),
      length: 5,
      lexeme: '// hi',
    ),
  );

  final tokenB = CommentToken(
    state: const LexerState(
      position: Position(
        index: 15,
        line: 1,
        col: 15,
      ),
      length: 8,
      lexeme: '// hello',
    ),
  );

  group('equatable:', () {
    test('implements equatable correctly', () {
      expect(tokenA == tokenAClone, isTrue);
      expect(tokenA == tokenB, isFalse);
    });
  });

  group('toString():', () {
    test('describes token', () {
      expect(tokenA.toString(), 'comment(`// hi`)');
    });
  });
}
