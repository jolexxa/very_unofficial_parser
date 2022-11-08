import 'package:very_unofficial_parser/src/nodes/expression.dart';

/// A visitor for the abstract syntax tree.
/// Contains a visit method for each AST node subclass.
abstract class Visitor {
  /// Visits a [PrefixExpression] node.
  void visitPrefixExpression(PrefixExpression node);

  /// Visits a [PostfixExpression] node.
  void visitPostfixExpression(PostfixExpression node);

  /// Visits a [BinaryExpression] node.
  void visitBinaryExpression(BinaryExpression node);

  /// Visits a [GroupExpression] node (parenthesis).
  void visitGroupExpression(GroupExpression node);

  /// Visits a [ReferenceExpression] node (identifier).
  void visitReferenceExpression(ReferenceExpression node);

  /// Visits a [TernaryConditionalExpression] node.
  void visitTernaryConditionalExpression(TernaryConditionalExpression node);

  /// Visits a [NumericLiteralExpression] node.
  void visitNumericLiteralExpression(NumericLiteralExpression node);

  /// Visits a [StringLiteralExpression] node.
  void visitStringLiteralExpression(StringLiteralExpression node);

  /// Visits a [BooleanLiteralExpression] node.
  void visitBooleanLiteralExpression(BooleanLiteralExpression node);
}
