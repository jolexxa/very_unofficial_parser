import 'package:very_unofficial_lexer/src/lang/lang.dart';
import 'package:very_unofficial_lexer/src/lexical/lexer_state.dart';
import 'package:very_unofficial_lexer/src/tokens/token.dart';

/// Identifier token.
class WhitespaceToken extends Token implements TriviaToken {
  /// Create a new [WhitespaceToken] with the specified properties.
  WhitespaceToken({required LexerState state})
      : super(type: TokenType.whitespace, state: state);
}
