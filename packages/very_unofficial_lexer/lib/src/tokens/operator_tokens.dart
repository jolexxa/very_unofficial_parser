import 'package:very_unofficial_lexer/src/lang/lang.dart';
import 'package:very_unofficial_lexer/src/lexical/lexical.dart';
import 'package:very_unofficial_lexer/src/tokens/token.dart';

/// The character which begins a symbol: e.g., the `# character.
class SymbolToken extends Token {
  /// Create a new [SymbolToken] from the lexer [state].
  SymbolToken({required LexerState state})
      : super(
          type: TokenType.symbol,
          state: state,
        );
}

/// Left brace token.
class BraceOpenToken extends Token {
  /// Create a new [BraceOpenToken] with the specified properties.
  BraceOpenToken({required LexerState state})
      : super(
          type: TokenType.braceOpen,
          state: state,
        );
}

/// Right brace token.
class BraceCloseToken extends Token {
  /// Create a new [BraceCloseToken] with the specified properties.
  BraceCloseToken({required LexerState state})
      : super(
          type: TokenType.braceClose,
          state: state,
        );
}

/// Plus token.
class PlusToken extends Token {
  /// Create a new [PlusToken] from the lexer [state].
  PlusToken({required LexerState state})
      : super(
          type: TokenType.plus,
          state: state,
        );
}

/// Increment token.
class IncrementToken extends Token {
  /// Create a new [IncrementToken] from the lexer [state].
  IncrementToken({required LexerState state})
      : super(
          type: TokenType.increment,
          state: state,
        );
}

/// Minus token.
class MinusToken extends Token {
  /// Create a new [MinusToken] from the lexer [state].
  MinusToken({required LexerState state})
      : super(
          type: TokenType.minus,
          state: state,
        );
}

/// Decrement token.
class DecrementToken extends Token {
  /// Create a new [DecrementToken] from the lexer [state].
  DecrementToken({required LexerState state})
      : super(
          type: TokenType.decrement,
          state: state,
        );
}

/// Left parenthesis token.
class ParenOpenToken extends Token {
  /// Create a new [ParenOpenToken] from the lexer [state].
  ParenOpenToken({required LexerState state})
      : super(
          type: TokenType.parenOpen,
          state: state,
        );
}

/// Right parenthesis token.
class ParenCloseToken extends Token {
  /// Create a new [ParenCloseToken] from the lexer [state].
  ParenCloseToken({required LexerState state})
      : super(
          type: TokenType.parenClose,
          state: state,
        );
}

/// Left bracket token.
class BracketOpenToken extends Token {
  /// Create a new [BracketOpenToken] from the lexer [state].
  BracketOpenToken({required LexerState state})
      : super(
          type: TokenType.bracketOpen,
          state: state,
        );
}

/// Right bracket token.
class BracketCloseToken extends Token {
  /// Create a new [BracketCloseToken] from the lexer [state].
  BracketCloseToken({required LexerState state})
      : super(
          type: TokenType.bracketClose,
          state: state,
        );
}

/// Question mark token.
class QuestionToken extends Token {
  /// Create a new [QuestionToken] from the lexer [state].
  QuestionToken({required LexerState state})
      : super(
          type: TokenType.question,
          state: state,
        );
}

/// If-null token.
class IfNullToken extends Token {
  /// Create a new [IfNullToken] from the lexer [state].
  IfNullToken({required LexerState state})
      : super(
          type: TokenType.ifNull,
          state: state,
        );
}

/// Bang token.
class BangToken extends Token {
  /// Create a new [BangToken] from the lexer [state].
  BangToken({required LexerState state})
      : super(
          type: TokenType.bang,
          state: state,
        );
}

/// Member access (dot operator) token.
class MemberAccessToken extends Token {
  /// Create a new [MemberAccessToken] from the lexer [state].
  MemberAccessToken({required LexerState state})
      : super(
          type: TokenType.memberAccess,
          state: state,
        );
}

/// Null-aware member access token.
class MemberAccessNullAwareToken extends Token {
  /// Create a new [MemberAccessNullAwareToken] from the lexer [state].
  MemberAccessNullAwareToken({required LexerState state})
      : super(
          type: TokenType.memberAccessNullAware,
          state: state,
        );
}

/// Comma token.
class CommaToken extends Token {
  /// Create a new [CommaToken] from the lexer [state].
  CommaToken({required LexerState state})
      : super(
          type: TokenType.comma,
          state: state,
        );
}

/// Colon token.
class ColonToken extends Token {
  /// Create a new [ColonToken] from the lexer [state].
  ColonToken({required LexerState state})
      : super(
          type: TokenType.colon,
          state: state,
        );
}

/// Semicolon token.
class SemicolonToken extends Token {
  /// Create a new [SemicolonToken] from the lexer [state].
  SemicolonToken({required LexerState state})
      : super(
          type: TokenType.semicolon,
          state: state,
        );
}

/// Multiplication token.
class MultiplicationToken extends Token {
  /// Create a new [MultiplicationToken] from the lexer [state].
  MultiplicationToken({required LexerState state})
      : super(
          type: TokenType.multiplication,
          state: state,
        );
}

/// Division token.
class DivisionToken extends Token {
  /// Create a new [DivisionToken] from the lexer [state].
  DivisionToken({required LexerState state})
      : super(
          type: TokenType.division,
          state: state,
        );
}

/// Remainder token.
class RemainderToken extends Token {
  /// Create a new [RemainderToken] from the lexer [state].
  RemainderToken({required LexerState state})
      : super(
          type: TokenType.remainder,
          state: state,
        );
}

/// Integer division token.
class IntegerDivisionToken extends Token {
  /// Create a new [IntegerDivisionToken] from the lexer [state].
  IntegerDivisionToken({required LexerState state})
      : super(
          type: TokenType.integerDivision,
          state: state,
        );
}

/// Shift left token.
class ShiftLeftToken extends Token {
  /// Create a new [ShiftLeftToken] from the lexer [state].
  ShiftLeftToken({required LexerState state})
      : super(
          type: TokenType.shiftLeft,
          state: state,
        );
}

/// Shift right token.
class ShiftRightToken extends Token {
  /// Create a new [ShiftRightToken] from the lexer [state].
  ShiftRightToken({required LexerState state})
      : super(
          type: TokenType.shiftRight,
          state: state,
        );
}

/// Unsigned right shift token.
class ShiftRightUnsignedToken extends Token {
  /// Create a new [ShiftRightUnsignedToken] from the lexer [state].
  ShiftRightUnsignedToken({required LexerState state})
      : super(
          type: TokenType.shiftRightUnsigned,
          state: state,
        );
}

/// Bitwise negation token.
class BitwiseComplementToken extends Token {
  /// Create a new [BitwiseComplementToken] from the lexer [state].
  BitwiseComplementToken({required LexerState state})
      : super(
          type: TokenType.bitwiseComplement,
          state: state,
        );
}

/// Bitwise and token.
class BitwiseAndToken extends Token {
  /// Create a new [BitwiseAndToken] from the lexer [state].
  BitwiseAndToken({required LexerState state})
      : super(
          type: TokenType.bitwiseAnd,
          state: state,
        );
}

/// Bitwise xor token.
class BitwiseXorToken extends Token {
  /// Create a new [BitwiseXorToken] from the lexer [state].
  BitwiseXorToken({required LexerState state})
      : super(
          type: TokenType.bitwiseXor,
          state: state,
        );
}

/// Bitwise or token.
class BitwiseOrToken extends Token {
  /// Create a new [BitwiseOrToken] from the lexer [state].
  BitwiseOrToken({required LexerState state})
      : super(
          type: TokenType.bitwiseOr,
          state: state,
        );
}

/// Greater than token.
class GreaterThanToken extends Token {
  /// Create a new [GreaterThanToken] from the lexer [state].
  GreaterThanToken({required LexerState state})
      : super(
          type: TokenType.greaterThan,
          state: state,
        );
}

/// Greater than or equal token.
class GreaterThanOrEqualToken extends Token {
  /// Create a new [GreaterThanOrEqualToken] from the lexer [state].
  GreaterThanOrEqualToken({required LexerState state})
      : super(
          type: TokenType.greaterThanOrEqual,
          state: state,
        );
}

/// Less than token.
class LessThanToken extends Token {
  /// Create a new [LessThanToken] from the lexer [state].
  LessThanToken({required LexerState state})
      : super(
          type: TokenType.lessThan,
          state: state,
        );
}

/// Less than or equal token.
class LessThanOrEqualToken extends Token {
  /// Create a new [LessThanOrEqualToken] from the lexer [state].
  LessThanOrEqualToken({required LexerState state})
      : super(
          type: TokenType.lessThanOrEqual,
          state: state,
        );
}

/// As operator token.
class AsToken extends Token {
  /// Create a new [AsToken] from the lexer [state].
  AsToken({required LexerState state})
      : super(
          type: TokenType.asOp,
          state: state,
        );
}

/// Is operator token.
class IsToken extends Token {
  /// Create a new [IsToken] from the lexer [state].
  IsToken({required LexerState state})
      : super(
          type: TokenType.isOp,
          state: state,
        );
}

/// Is not operator token.
class IsNotToken extends Token {
  /// Create a new [IsNotToken] from the lexer [state].
  IsNotToken({required LexerState state})
      : super(
          type: TokenType.isNotOp,
          state: state,
        );
}

/// Equality token.
class EqualityToken extends Token {
  /// Create a new [EqualityToken] from the lexer [state].
  EqualityToken({required LexerState state})
      : super(
          type: TokenType.equality,
          state: state,
        );
}

/// Inequality token.
class InequalityToken extends Token {
  /// Create a new [InequalityToken] from the lexer [state].
  InequalityToken({required LexerState state})
      : super(
          type: TokenType.inequality,
          state: state,
        );
}

/// Logical and token.
class LogicalAndToken extends Token {
  /// Create a new [LogicalAndToken] from the lexer [state].
  LogicalAndToken({required LexerState state})
      : super(
          type: TokenType.logicalAnd,
          state: state,
        );
}

/// Logical or token.
class LogicalOrToken extends Token {
  /// Create a new [LogicalOrToken] from the lexer [state].
  LogicalOrToken({required LexerState state})
      : super(
          type: TokenType.logicalOr,
          state: state,
        );
}

/// Cascade token.
class CascadeToken extends Token {
  /// Create a new [CascadeToken] from the lexer [state].
  CascadeToken({required LexerState state})
      : super(
          type: TokenType.cascade,
          state: state,
        );
}

/// Cascade (null aware) token.
class CascadeNullAwareToken extends Token {
  /// Create a new [CascadeNullAwareToken] from the lexer [state].
  CascadeNullAwareToken({required LexerState state})
      : super(
          type: TokenType.cascadeNullAware,
          state: state,
        );
}

/// Spread token.
class SpreadToken extends Token {
  /// Create a new [SpreadToken] from the lexer [state].
  SpreadToken({required LexerState state})
      : super(
          type: TokenType.spread,
          state: state,
        );
}

/// Spread (null aware) token.
class SpreadNullAwareToken extends Token {
  /// Create a new [SpreadNullAwareToken] from the lexer [state].
  SpreadNullAwareToken({required LexerState state})
      : super(
          type: TokenType.spreadNullAware,
          state: state,
        );
}

/// Assignment token.
class AssignmentToken extends Token {
  /// Create a new [AssignmentToken] from the lexer [state].
  AssignmentToken({required LexerState state})
      : super(
          type: TokenType.assignment,
          state: state,
        );
}

/// Compound assignment (multiply) token.
class AssignmentMultiplicationToken extends Token {
  /// Create a new [AssignmentMultiplicationToken] from the lexer [state].
  AssignmentMultiplicationToken({required LexerState state})
      : super(
          type: TokenType.assignmentMultiplication,
          state: state,
        );
}

/// Compound assignment (divide) token.
class AssignmentDivisionToken extends Token {
  /// Create a new [AssignmentDivisionToken] from the lexer [state].
  AssignmentDivisionToken({required LexerState state})
      : super(
          type: TokenType.assignmentDivision,
          state: state,
        );
}

/// Compound assignment (integer division) token.
class AssignmentIntegerDivisionToken extends Token {
  /// Create a new [AssignmentIntegerDivisionToken] from the lexer [state].
  AssignmentIntegerDivisionToken({required LexerState state})
      : super(
          type: TokenType.assignmentIntegerDivision,
          state: state,
        );
}

/// Compound assignment (remainder/modulo) token.
class AssignmentRemainderToken extends Token {
  /// Create a new [AssignmentRemainderToken] from the lexer [state].
  AssignmentRemainderToken({required LexerState state})
      : super(
          type: TokenType.assignmentRemainder,
          state: state,
        );
}

/// Compound assignment (add) token.
class AssignmentAdditionToken extends Token {
  /// Create a new [AssignmentAdditionToken] from the lexer [state].
  AssignmentAdditionToken({required LexerState state})
      : super(
          type: TokenType.assignmentAddition,
          state: state,
        );
}

/// Compound assignment (subtract) token.
class AssignmentSubtractionToken extends Token {
  /// Create a new [AssignmentSubtractionToken] from the lexer [state].
  AssignmentSubtractionToken({required LexerState state})
      : super(
          type: TokenType.assignmentSubtraction,
          state: state,
        );
}

/// Compound assignment (left shift) token.
class AssignmentShiftLeftToken extends Token {
  /// Create a new [AssignmentShiftLeftToken] from the lexer [state].
  AssignmentShiftLeftToken({required LexerState state})
      : super(
          type: TokenType.assignmentShiftLeft,
          state: state,
        );
}

/// Compound assignment (unsigned right shift) token.
class AssignmentShiftRightUnsignedToken extends Token {
  /// Create a new [AssignmentShiftRightUnsignedToken] from the lexer [state].
  AssignmentShiftRightUnsignedToken({required LexerState state})
      : super(
          type: TokenType.assignmentShiftRightUnsigned,
          state: state,
        );
}

/// Compound assignment (right shift) token.
class AssignmentShiftRightToken extends Token {
  /// Create a new [AssignmentShiftRightToken] from the lexer [state].
  AssignmentShiftRightToken({required LexerState state})
      : super(
          type: TokenType.assignmentShiftRight,
          state: state,
        );
}

/// Compound assignment (bitwise and) token.
class AssignmentBitwiseAndToken extends Token {
  /// Create a new [AssignmentBitwiseAndToken] from the lexer [state].
  AssignmentBitwiseAndToken({required LexerState state})
      : super(
          type: TokenType.assignmentBitwiseAnd,
          state: state,
        );
}

/// Compound assignment (bitwise xor) token.
class AssignmentBitwiseXorToken extends Token {
  /// Create a new [AssignmentBitwiseXorToken] from the lexer [state].
  AssignmentBitwiseXorToken({required LexerState state})
      : super(
          type: TokenType.assignmentBitwiseXor,
          state: state,
        );
}

/// Compound assignment (bitwise or) token.
class AssignmentBitwiseOrToken extends Token {
  /// Create a new [AssignmentBitwiseOrToken] from the lexer [state].
  AssignmentBitwiseOrToken({required LexerState state})
      : super(
          type: TokenType.assignmentBitwiseOr,
          state: state,
        );
}

/// Compound assignment (if-null) token.
class AssignmentIfNull extends Token {
  /// Create a new [AssignmentIfNull] from the lexer [state].
  AssignmentIfNull({required LexerState state})
      : super(
          type: TokenType.assignmentIfNull,
          state: state,
        );
}
