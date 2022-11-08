import 'package:test/test.dart';
import 'package:very_unofficial_lexer/src/lexical/lexer_state.dart';
import 'package:very_unofficial_lexer/src/lexical/position.dart';

void main() {
  group('equatable', () {
    test('implements equatable correctly', () {
      const a = LexerState(
        length: 1,
        position: Position.zero,
        lexeme: 'x',
      );
      const b = LexerState(
        length: 1,
        position: Position.zero,
        lexeme: 'x',
      );
      const c = LexerState(
        length: 1,
        position: Position.zero,
        lexeme: 'y',
      );
      expect(a == b, isTrue);
      expect(a == c, isFalse);
    });
  });
}
