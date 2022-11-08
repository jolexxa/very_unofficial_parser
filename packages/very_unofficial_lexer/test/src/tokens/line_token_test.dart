import 'package:test/test.dart';
import 'package:very_unofficial_lexer/src/lexical/lexical.dart';
import 'package:very_unofficial_lexer/src/tokens/tokens.dart';

void main() {
  group('line token:', () {
    group('toString()', () {
      test('describes token', () {
        final token = LineToken(
          state: const LexerState(
            position: Position.zero,
            length: 1,
            lexeme: '\n',
          ),
        );
        expect(token.toString(), r'line(`\n`)');
      });
    });
  });
}
