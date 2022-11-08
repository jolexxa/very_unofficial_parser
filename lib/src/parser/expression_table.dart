import 'package:very_unofficial_lexer/very_unofficial_lexer.dart';
import 'package:very_unofficial_parser/src/parser/parselet.dart';
import 'package:very_unofficial_parser/src/parser/precedence.dart';

/// Maps operator token types to their respective parselets. Helps with
/// expression parsing using a Pratt parser.
///
/// {@macro pratt_parser_help}
class ExpressionTable {
  /// Mapping of token types to prefix expression parsers which handle the
  /// operator indicated by the type of token.
  Map<TokenType, PrefixParselet> prefixParselets = {};

  /// Mapping of token types to infix expression parsers which handle the
  /// operator indicated by the type of token.
  Map<TokenType, InfixParselet> infixParselets = {};

  /// Registers a prefix unary operator parselet for the specified
  /// token [type] and [precedence].
  void prefixOp(TokenType type, Precedence precedence) =>
      registerPrefix(type, PrefixOperatorParselet(precedence));

  /// Registers a postfix unary operator parselet for the specified
  /// token [type] and [precedence].
  void postfixOp(TokenType type, Precedence precedence) =>
      registerInfix(type, PostfixOperatorParselet(precedence));

  /// Registers a left-associative binary operator parselet for the specified
  /// token [type] and [precedence].
  void infixOpLeft(TokenType type, Precedence precedence) => registerInfix(
        type,
        BinaryOperatorParselet(precedence, isRightAssociative: false),
      );

  /// Registers a right-associative binary operator parselet for the specified
  /// token [type] and [precedence].
  void infixOpRight(TokenType type, Precedence precedence) => registerInfix(
        type,
        BinaryOperatorParselet(precedence, isRightAssociative: true),
      );

  /// Registers a prefix parselet (can be a prefix parselet for something
  /// other than a prefix operator) for the specified token [type].
  void registerPrefix(TokenType type, PrefixParselet parselet) =>
      prefixParselets[type] = parselet;

  /// Registers a non-prefix parselet for the specified token [type].
  void registerInfix(TokenType type, InfixParselet parselet) =>
      infixParselets[type] = parselet;

  /// Checks whether a prefix parselet has been registered for the
  /// specified token [type].
  bool hasPrefix(TokenType type) => prefixParselets.containsKey(type);

  /// Checks whether an infix parselet has been registered for the
  /// specified token [type].
  bool hasInfix(TokenType type) => infixParselets.containsKey(type);

  /// Returns a registered prefix parselet for the specified token [type],
  /// if there is one. Otherwise, the default invalid index exception
  /// will be thrown.
  PrefixParselet getPrefix(TokenType type) => prefixParselets[type]!;

  /// Returns a registered infix parselet for the specified token [type],
  /// if there is one. Otherwise, the default invalid index exception
  /// will be thrown.
  InfixParselet getInfix(TokenType type) => infixParselets[type]!;
}
