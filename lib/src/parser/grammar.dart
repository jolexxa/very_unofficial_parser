import 'package:very_unofficial_lexer/very_unofficial_lexer.dart';
import 'package:very_unofficial_parser/src/parser/expression_table.dart';
import 'package:very_unofficial_parser/src/parser/parselet.dart';
import 'package:very_unofficial_parser/src/parser/precedence.dart';

/// Dart language grammar.
class Grammar {
  // Define our operator grammar by defining tokens and their respective
  // parselets (to help parse operators with respect to precedence).

  /// A table of token types to parselets. Parselets assist the parser
  /// in parsing expressions indicated by the different token types.
  static final ExpressionTable expressionTable = ExpressionTable()
    // Register specialty prefix parselets parselets.
    ..registerPrefix(TokenType.parenOpen, GroupParselet())
    ..registerPrefix(TokenType.id, ReferenceParselet())
    ..registerPrefix(TokenType.number, NumericLiteralParselet())
    ..registerPrefix(TokenType.string, StringLiteralParselet())
    ..registerPrefix(TokenType.boolean, BooleanLiteralParselet())
    // ..registerPrefix(TokenType.braceOpen, new MapOrSetParselet())
    // ..registerPrefix(TokenType.bracketOpen, new ListParselet())
    // ..registerInfix(TokenType.parenOpen, InvocationParselet())
    // ..registerInfix(TokenType.bracketOpen, IndexerParselet())
    // ..registerInfix(TokenType.memberAccess, MemberAccessParselet());

    // Ternary conditional operator.
    ..registerInfix(TokenType.question, TernaryConditionalParselet())

    // Equality operators.
    ..infixOpLeft(TokenType.equality, Precedence.equality)

    // Prefix operators.
    ..prefixOp(TokenType.minus, Precedence.unaryPrefix) // unary minus sign
    ..prefixOp(TokenType.bang, Precedence.unaryPrefix) // logical negation
    ..prefixOp(TokenType.bitwiseComplement, Precedence.unaryPrefix) // ~
    ..prefixOp(TokenType.increment, Precedence.unaryPrefix) // prefix ++
    ..prefixOp(TokenType.decrement, Precedence.unaryPrefix) // prefix --

    // Left-associative infix operators.
    ..infixOpLeft(TokenType.plus, Precedence.additive)
    ..infixOpLeft(TokenType.minus, Precedence.additive)
    ..infixOpLeft(TokenType.multiplication, Precedence.multiplicative)
    ..infixOpLeft(TokenType.division, Precedence.multiplicative)
    ..infixOpLeft(TokenType.remainder, Precedence.multiplicative)
    ..infixOpLeft(TokenType.integerDivision, Precedence.multiplicative)
    ..infixOpLeft(TokenType.logicalAnd, Precedence.logicalAnd)
    ..infixOpLeft(TokenType.logicalOr, Precedence.logicalOr)
    ..infixOpLeft(TokenType.bitwiseAnd, Precedence.bitwiseAnd)
    ..infixOpLeft(TokenType.bitwiseXor, Precedence.bitwiseXor)
    ..infixOpLeft(TokenType.bitwiseOr, Precedence.bitwiseOr)
    ..infixOpLeft(TokenType.shiftLeft, Precedence.shift)
    ..infixOpLeft(TokenType.shiftRight, Precedence.shift)
    ..infixOpLeft(TokenType.shiftRightUnsigned, Precedence.shift)
    ..infixOpLeft(TokenType.ifNull, Precedence.ifNull)
    ..infixOpLeft(TokenType.cascade, Precedence.cascade)
    ..infixOpLeft(TokenType.cascadeNullAware, Precedence.cascade)
    ..infixOpLeft(TokenType.isOp, Precedence.relational)
    ..infixOpLeft(TokenType.isNotOp, Precedence.relational)
    ..infixOpLeft(TokenType.asOp, Precedence.relational)
    ..infixOpLeft(TokenType.lessThan, Precedence.relational)
    ..infixOpLeft(TokenType.lessThanOrEqual, Precedence.relational)
    ..infixOpLeft(TokenType.greaterThan, Precedence.relational)
    ..infixOpLeft(TokenType.greaterThanOrEqual, Precedence.relational)

    // Right-associative infix operators.
    ..infixOpRight(TokenType.assignment, Precedence.assignment)
    ..infixOpRight(TokenType.assignmentAddition, Precedence.assignment)
    ..infixOpRight(TokenType.assignmentSubtraction, Precedence.assignment)
    ..infixOpRight(TokenType.assignmentMultiplication, Precedence.assignment)
    ..infixOpRight(TokenType.assignmentDivision, Precedence.assignment)
    ..infixOpRight(TokenType.assignmentRemainder, Precedence.assignment)
    ..infixOpRight(TokenType.assignmentIntegerDivision, Precedence.assignment)
    ..infixOpRight(TokenType.assignmentBitwiseAnd, Precedence.assignment)
    ..infixOpRight(TokenType.assignmentBitwiseXor, Precedence.assignment)
    ..infixOpRight(TokenType.assignmentBitwiseOr, Precedence.assignment)
    ..infixOpRight(TokenType.assignmentShiftLeft, Precedence.assignment)
    ..infixOpRight(TokenType.assignmentShiftRight, Precedence.assignment)
    ..infixOpRight(
      TokenType.assignmentShiftRightUnsigned,
      Precedence.assignment,
    )
    ..infixOpRight(TokenType.assignmentIfNull, Precedence.assignment)

    // Postfix operators.
    ..postfixOp(TokenType.increment, Precedence.unaryPostfix)
    ..postfixOp(TokenType.decrement, Precedence.unaryPostfix);
}
