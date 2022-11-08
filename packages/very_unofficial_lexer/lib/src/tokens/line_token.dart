import 'package:very_unofficial_lexer/src/lang/lang.dart';
import 'package:very_unofficial_lexer/src/lexical/lexer_state.dart';
import 'package:very_unofficial_lexer/src/tokens/token.dart';

/// Identifier token.
class LineToken extends Token {
  /// Create a new [LineToken] with the specified properties.
  LineToken({required LexerState state})
      : super(type: TokenType.line, state: state);
}
