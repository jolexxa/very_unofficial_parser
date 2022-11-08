import 'package:test/test.dart';
import 'package:very_unofficial_lexer/src/lexical/lexical.dart';
import 'package:very_unofficial_lexer/src/tokens/tokens.dart';

void main() {
  group('toString():', () {
    test('describes token', () {
      final token = EofToken(
        position: const Position(
          index: 15,
          line: 1,
          col: 15,
        ),
      );
      expect(token.toString(), 'eof(``)');
    });
  });
}
