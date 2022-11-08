import 'package:very_unofficial_lexer/src/lang/lang.dart';
import 'package:very_unofficial_lexer/src/lexical/lexer_state.dart';
import 'package:very_unofficial_lexer/src/tokens/token.dart';

/// Boolean literal token.
class BooleanToken extends Token {
  /// Create a new [BooleanToken] with the specified properties.
  BooleanToken({required LexerState state})
      : super(type: TokenType.boolean, state: state);

  /// Represents the boolean value of the literal.
  bool get value => lexeme == 'true';
}
