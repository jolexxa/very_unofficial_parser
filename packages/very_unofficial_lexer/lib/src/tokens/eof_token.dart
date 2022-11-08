import 'package:very_unofficial_lexer/src/lang/lang.dart';
import 'package:very_unofficial_lexer/src/lexical/lexical.dart';
import 'package:very_unofficial_lexer/src/tokens/token.dart';

/// Represents the end of a file being scanned.
class EofToken extends Token {
  /// Create a new EOF token.
  EofToken({
    required Position position,
  }) : super(
          type: TokenType.eof,
          state: LexerState(
            position: position,
            length: 0,
            lexeme: '',
          ),
        );
}
