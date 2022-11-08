import 'package:test/test.dart';
import 'package:very_unofficial_lexer/src/lexical/lexical.dart';
import 'package:very_unofficial_lexer/src/tokens/tokens.dart';

void main() {
  group('toString():', () {
    test('describes token', () {
      final token = IdToken(
        state: const LexerState(
          position: Position.zero,
          length: 1,
          lexeme: 'a',
        ),
      );
      expect(token.toString(), 'id(`a`)');
    });
  });
}
