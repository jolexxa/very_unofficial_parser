import 'package:very_unofficial_parser/very_unofficial_parser.dart';

/// {@template pratt_parser}
/// A pratt parser (used for parsing expressions).
/// {@endtemplate}
///
/// {@template pratt_parser_help}
/// See Bob's blog article about Pratt parsers: https://bit.ly/3CPpPew.
/// {@endtemplate}
class PrattParser extends TokenParser {
  /// {@macro pratt_parser}
  ///
  /// {@macro pratt_parser_help}
  PrattParser(super.tokens, this.expressionTable);

  /// Grammar table for parsing expressions. Maps tokens to the parselets that
  /// assist in parsing operators with respect to operator precedence.
  final ExpressionTable expressionTable;

  /// Parses an expression with the given [precedence].
  ///
  /// The specified [precedence] specifies which expressions can be parsed.
  ///
  /// If an expression with a lower precedence is encountered, the
  /// parser returns whatever it has already parsed.
  Expression expression([Precedence precedence = Precedence.none]) {
    var token = advance();

    if (!expressionTable.hasPrefix(token.type)) {
      // TODO(definitelyokay): Better error handling system
      throw StateError('expected start of expression');
    }
    final prefixParselet = expressionTable.getPrefix(token.type);
    var lhs = prefixParselet.parse(this, token);
    while (precedence < peekPrecedence) {
      token = advance();
      final infixParselet = expressionTable.getInfix(token.type);
      lhs = infixParselet.parse(this, token, lhs);
    }
    return lhs;
  }

  /// Peeks at the operator precedence of the next token.
  Precedence get peekPrecedence => expressionTable.hasInfix(peek.type)
      ? expressionTable.getInfix(peek.type).precedence
      : Precedence.none;
}
