import 'package:very_unofficial_lexer/src/lang/lang.dart';
import 'package:very_unofficial_lexer/src/lexical/lexical.dart';
import 'package:very_unofficial_lexer/src/tokens/token.dart';

/// Numeric literal token.
class NumberToken extends Token {
  /// Create a new [NumberToken] with the specified properties.
  NumberToken({required LexerState state, required this.base})
      : super(state: state, type: TokenType.number);

  /// Numeric literal's base type.
  final NumericLiteral base;

  /// Numeric value, as computed from [double.tryParse].
  double get value => double.tryParse(lexeme) ?? 0;

  @override
  List<Object?> get props => [...super.props, base];
}
