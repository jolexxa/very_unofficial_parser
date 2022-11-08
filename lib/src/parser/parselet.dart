import 'package:very_unofficial_lexer/very_unofficial_lexer.dart';
import 'package:very_unofficial_parser/src/nodes/expression.dart';
import 'package:very_unofficial_parser/src/parser/pratt_parser.dart';
import 'package:very_unofficial_parser/src/parser/precedence.dart';

/// Parsing assistant which calls back into a parser to parse
/// appropriate subtrees with respect to various rules, such
/// as precedence.
///
/// {@macro pratt_parser_help}
abstract class Parselet {}

/// Represents a parselet for prefix operators occurring before an operand.
abstract class PrefixParselet extends Parselet {
  /// Parses a token using the given pratt parser.
  Expression parse(PrattParser parser, Token token);
}

/// {@template infix_parselet}
/// Represents a parselet for non-prefix operators.
/// A non-prefix operator can be infix (occurring between two operands), or
/// postfix, occurring after an operand. Technically, infix is "not prefix"
/// rather than strictly being between two operands. Function invocations,
/// indexers, etc, all extend "infix."
/// {@endtemplate}
abstract class InfixParselet extends Parselet {
  /// {@macro infix_parselet}
  InfixParselet(this.precedence);

  /// Operator precedence.
  final Precedence precedence;

  /// Parses an infix operator [token] using the given pratt parser with
  /// the previously parsed [lhs] (left hand side) expression.
  Expression parse(PrattParser parser, Token token, Expression lhs);
}

/// {@template prefix_operator_parselet}
/// A parselet for prefix operators (operators which precede their operand).
/// {@endtemplate}
class PrefixOperatorParselet extends PrefixParselet {
  /// {@macro prefix_operator_parselet}
  PrefixOperatorParselet(this.precedence) : super();

  /// Operator precedence.
  final Precedence precedence;

  /// Parses a prefix operator [token] using the given pratt parser.
  @override
  PrefixExpression parse(PrattParser parser, Token token) {
    final rhs = parser.expression(precedence);
    return PrefixExpression(operatorToken: token, rhs: rhs);
  }
}

/// {@template postfix_operator_parselet}
/// A parselet for postfix operators (operators which follow their operand).
/// {@endtemplate}
class PostfixOperatorParselet extends InfixParselet {
  /// {@macro postfix_operator_parselet}
  PostfixOperatorParselet(super.precedence);

  @override
  PostfixExpression parse(PrattParser parser, Token token, Expression lhs) =>
      PostfixExpression(lhs: lhs, operatorToken: token);
}

/// {@template binary_operator_parselet}
/// A parselet for binary operators (operators which occur between two
/// operands).
/// {@endtemplate}
class BinaryOperatorParselet extends InfixParselet {
  /// {@macro binary_operator_parselet}
  BinaryOperatorParselet(super.precedence, {required this.isRightAssociative});

  /// Whether the operator is right associative (or not).
  final bool isRightAssociative;

  @override
  BinaryExpression parse(PrattParser parser, Token token, Expression lhs) {
    // We drop the precedence slightly for right associative operators
    // so that another right associative operator will bind more tightly.
    //
    // i.e.,
    // - For left associative operators, keep the precedence the same.
    // - For right associative operators, drop the precedence by one.
    final rhs = parser.expression(precedence - (isRightAssociative ? 1 : 0));
    return BinaryExpression(lhs: lhs, operatorToken: token, rhs: rhs);
  }
}

/// {@template group_parselet}
/// A parselet for expressions in parenthesis.
/// {@endtemplate}
class GroupParselet extends PrefixParselet {
  @override
  GroupExpression parse(PrattParser parser, Token token) {
    // Since parenthesis represent an explicit grouping,
    // we pass in the lowest precedence since we need to parse
    // all the expressions. When we're done, a closing parenthesis
    // should be waiting for us.
    final expression = parser.expression();
    final closeToken = parser.consume<ParenCloseToken>(
      error: 'expected closing parenthesis `)`',
    );
    return GroupExpression(
      openToken: token,
      expression: expression,
      closeToken: closeToken,
    );
  }
}

/// Creates identifier reference expressions.
class ReferenceParselet extends PrefixParselet {
  @override
  ReferenceExpression parse(PrattParser parser, Token token) =>
      ReferenceExpression(idToken: token);
}

/// Creates numeric literal expressions.
class NumericLiteralParselet extends PrefixParselet {
  @override
  NumericLiteralExpression parse(PrattParser parser, Token token) =>
      NumericLiteralExpression(numberToken: token as NumberToken);
}

/// Creates string literal expressions.
class StringLiteralParselet extends PrefixParselet {
  @override
  StringLiteralExpression parse(PrattParser parser, Token token) =>
      StringLiteralExpression(stringToken: token as StringToken);
}

/// Creates boolean literal expressions.
class BooleanLiteralParselet extends PrefixParselet {
  @override
  BooleanLiteralExpression parse(PrattParser parser, Token token) =>
      BooleanLiteralExpression(booleanToken: token as BooleanToken);
}

/// {@template ternary_conditional_parselet}
/// A parselet for ternary conditional expressions.
/// {@endtemplate}
class TernaryConditionalParselet extends InfixParselet {
  /// {@macro ternary_conditional_parselet}
  TernaryConditionalParselet() : super(Precedence.conditional);

  @override
  TernaryConditionalExpression parse(
    PrattParser parser,
    Token token,
    Expression lhs,
  ) {
    final questionToken = token;
    final predicate = lhs;
    // Since ternary is right associative, we must subtract one from precedence
    // for inner expressions.
    final consequent = parser.expression(precedence - 1);
    final colonToken = parser.consume<ColonToken>(
      error: 'Expected colon `:` for ternary conditional operator',
    );
    final alternative = parser.expression(precedence - 1);
    return TernaryConditionalExpression(
      predicate: predicate,
      questionToken: questionToken,
      consequent: consequent,
      colonToken: colonToken,
      alternative: alternative,
    );
  }
}
