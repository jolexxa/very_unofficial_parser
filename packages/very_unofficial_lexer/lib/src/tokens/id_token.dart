import 'package:very_unofficial_lexer/src/lang/lang.dart';
import 'package:very_unofficial_lexer/src/lexical/lexical.dart';
import 'package:very_unofficial_lexer/src/tokens/token.dart';

/// Identifier token.
class IdToken extends Token {
  /// Create a new [IdToken] with the specified properties.
  IdToken({required LexerState state})
      : super(type: TokenType.id, state: state);
}
