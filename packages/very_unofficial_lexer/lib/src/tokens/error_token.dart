import 'package:very_unofficial_lexer/src/lang/lang.dart';
import 'package:very_unofficial_lexer/src/lexical/lexical.dart';
import 'package:very_unofficial_lexer/src/tokens/token.dart';

/// Representation of an unexpected token.
class ErrorToken extends Token {
  /// Create a new [ErrorToken] with the specified properties.
  ErrorToken({required LexerState state, required this.hint})
      : super(type: TokenType.error, state: state);

  /// Error hints describing the problem and/or possible solutions.
  final String hint;

  @override
  String toString() {
    return 'Error on line '
        '${position.line}:${position.col}'
        ' (${position.index}) with '
        '`$lexeme`. $hint.';
  }

  @override
  List<Object?> get props => [...super.props, hint];
}
