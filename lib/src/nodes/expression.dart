import 'package:very_unofficial_lexer/very_unofficial_lexer.dart';
import 'package:very_unofficial_parser/src/nodes/node.dart';
import 'package:very_unofficial_parser/src/parser/visitor.dart';

/// An expression node. Provides a common base class for all expression nodes.
abstract class Expression extends Node {}

/// An expression representing a location in memory which can be assigned to.
/// That is, this expression is a valid l-value.
/// E.g., variables, indexers, fields.
abstract class AssignableExpression extends Expression {}

/// An expression with a single operator. Useful for binary expressions,
/// postfix, and prefix expressions.
abstract class SingleOperatorExpression extends Expression {
  /// Operator token.
  Token get operatorToken;

  /// Operator token's type.
  TokenType get operator => operatorToken.type;
}

/// {@template prefix_expression}
/// Represents a prefix operator expression (an expression with an operator
/// preceding it).
/// {@endtemplate}
class PrefixExpression extends SingleOperatorExpression {
  /// {@macro prefix_expression}
  PrefixExpression({required this.operatorToken, required this.rhs});

  /// Right-hand side expression.
  final Expression rhs;

  @override
  final Token operatorToken;

  @override
  void accept(Visitor visitor) => visitor.visitPrefixExpression(this);
}

/// {@template postfix_expression}
/// Represents a postfix operator expression (an expression with an operator
/// following it).
/// {@endtemplate}
class PostfixExpression extends SingleOperatorExpression {
  /// {@macro postfix_expression}
  PostfixExpression({required this.lhs, required this.operatorToken});

  /// Left-hand side expression.
  final Expression lhs;

  @override
  final Token operatorToken;

  @override
  void accept(Visitor visitor) => visitor.visitPostfixExpression(this);
}

/// {@template binary_expression}
/// Represents a binary expression (with an operator between left hand and right
/// hand side expressions).
/// {@endtemplate}
class BinaryExpression extends SingleOperatorExpression {
  /// {@macro binary_expression}
  BinaryExpression({
    required this.lhs,
    required this.operatorToken,
    required this.rhs,
  });

  /// Left-hand side expression.
  final Expression lhs;

  @override
  final Token operatorToken;

  /// Right-hand side expression.
  final Expression rhs;

  @override
  void accept(Visitor visitor) => visitor.visitBinaryExpression(this);
}

/// {@template group_expression}
/// Represents an expression surrounded by parentheses.
/// {@endtemplate}
class GroupExpression extends Expression {
  /// {@macro group_expression}
  GroupExpression({
    required this.openToken,
    required this.expression,
    required this.closeToken,
  });

  /// Opening parenthesis token.
  Token openToken;

  /// Expression inside the parentheses.
  Expression expression;

  /// Closing parenthesis token.
  Token closeToken;

  @override
  void accept(Visitor visitor) => visitor.visitGroupExpression(this);
}

/// {@template reference_expression}
/// Represents a reference to the value in a variable/identifier.
/// {@endtemplate}
class ReferenceExpression extends Expression {
  /// {@macro reference_expression}
  ReferenceExpression({required this.idToken});

  /// Identifier token.
  Token idToken;

  /// Identifier string.
  String get identifier => idToken.lexeme;

  @override
  void accept(Visitor visitor) => visitor.visitReferenceExpression(this);
}

/// {@template numeric_literal_expression}
/// Represents a numeric literal expression.
/// {@endtemplate}
class NumericLiteralExpression extends Expression {
  /// {@macro numeric_literal_expression}
  NumericLiteralExpression({required this.numberToken});

  /// Numeric literal token.
  final NumberToken numberToken;

  @override
  void accept(Visitor visitor) => visitor.visitNumericLiteralExpression(this);
}

/// {@template string_literal_expression}
/// Represents a string literal expression.
/// {@endtemplate}
class StringLiteralExpression extends Expression {
  /// {@macro string_literal_expression}
  StringLiteralExpression({required this.stringToken});

  /// String literal token.
  final StringToken stringToken;

  @override
  void accept(Visitor visitor) => visitor.visitStringLiteralExpression(this);
}

/// {@template boolean_literal_expression}
/// Represents a boolean literal expression.
/// {@endtemplate}
class BooleanLiteralExpression extends Expression {
  /// {@macro boolean_literal_expression}
  BooleanLiteralExpression({required this.booleanToken});

  /// Boolean literal token.
  final BooleanToken booleanToken;

  @override
  void accept(Visitor visitor) => visitor.visitBooleanLiteralExpression(this);
}

/// {@template ternary_conditional_expression}
/// Represents a ternary conditional expression (a ? b : c).
/// {@endtemplate}
class TernaryConditionalExpression extends Expression {
  /// {@macro ternary_conditional_expression}
  TernaryConditionalExpression({
    required this.predicate,
    required this.questionToken,
    required this.consequent,
    required this.colonToken,
    required this.alternative,
  });

  /// Predicate (condition) expression.
  final Expression predicate;

  /// Question mark token.
  final Token questionToken;

  /// Consequent expression (if the predicate is true).
  final Expression consequent;

  /// Colon token.
  final Token colonToken;

  /// Alternative expression (if the predicate is false).
  final Expression alternative;

  @override
  void accept(Visitor visitor) =>
      visitor.visitTernaryConditionalExpression(this);
}
