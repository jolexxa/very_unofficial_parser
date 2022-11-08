import 'package:test/test.dart';
import 'package:very_unofficial_lexer/src/lexical/lexer_state.dart';
import 'package:very_unofficial_lexer/src/lexical/position.dart';
import 'package:very_unofficial_lexer/src/tokens/tokens.dart';

void main() {
  final tokenA = ErrorToken(
    state: const LexerState(
      position: Position(
        index: 15,
        line: 1,
        col: 15,
      ),
      length: 4,
      lexeme: '    ',
    ),
    hint: 'Hint',
  );

  final tokenB = ErrorToken(
    state: const LexerState(
      position: Position(
        index: 15,
        line: 1,
        col: 15,
      ),
      length: 4,
      lexeme: '    ',
    ),
    hint: 'Hint',
  );

  final tokenC = ErrorToken(
    state: const LexerState(
      position: Position(
        index: 16,
        line: 1,
        col: 16,
      ),
      length: 4,
      lexeme: '    ',
    ),
    hint: 'Hint 2',
  );

  group('equatable:', () {
    test('implements equality', () {
      expect(tokenA == tokenB, isTrue);
      expect(tokenA == tokenC, isFalse);
    });
  });
  group('toString():', () {
    test('describes token', () {
      expect(
        tokenA.toString(),
        'Error on line 1:15 (15) with `    `.'
        ' Hint.',
      );
    });
  });
}
