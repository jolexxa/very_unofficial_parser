import 'dart:core';

import 'package:test/expect.dart';
import 'package:very_unofficial_lexer/src/lang/lang.dart';
import 'package:very_unofficial_lexer/src/lexer/lexer.dart';
import 'package:very_unofficial_lexer/src/tokens/tokens.dart';

// Shorten token types.

const error = TokenType.error;
const eof = TokenType.eof;
const line = TokenType.line;
const whitespace = TokenType.whitespace;
const op = TokenType.op;
const comment = TokenType.comment;
const commentDoc = TokenType.commentDoc;
const commentMultiline = TokenType.commentMultiline;
const commentMultilineDoc = TokenType.commentMultilineDoc;
const id = TokenType.id;
const number = TokenType.number;
const string = TokenType.string;
const boolean = TokenType.boolean;
const braceOpen = TokenType.braceOpen;
const braceClose = TokenType.braceClose;
const symbol = TokenType.symbol;
const plus = TokenType.plus;
const minus = TokenType.minus;
const increment = TokenType.increment;
const decrement = TokenType.decrement;
const parenOpen = TokenType.parenOpen;
const parenClose = TokenType.parenClose;
const bracketOpen = TokenType.bracketOpen;
const bracketClose = TokenType.bracketClose;
const question = TokenType.question;
const ifNull = TokenType.ifNull;
const bang = TokenType.bang;
const memberAccess = TokenType.memberAccess;
const memberAccessNullAware = TokenType.memberAccessNullAware;
const comma = TokenType.comma;
const colon = TokenType.colon;
const semicolon = TokenType.semicolon;
const multiplication = TokenType.multiplication;
const division = TokenType.division;
const remainder = TokenType.remainder;
const integerDivision = TokenType.integerDivision;
const shiftLeft = TokenType.shiftLeft;
const shiftRight = TokenType.shiftRight;
const shiftRightUnsigned = TokenType.shiftRightUnsigned;
const bitwiseComplement = TokenType.bitwiseComplement;
const bitwiseAnd = TokenType.bitwiseAnd;
const bitwiseXor = TokenType.bitwiseXor;
const bitwiseOr = TokenType.bitwiseOr;
const greaterThan = TokenType.greaterThan;
const greaterThanOrEqual = TokenType.greaterThanOrEqual;
const lessThan = TokenType.lessThan;
const lessThanOrEqual = TokenType.lessThanOrEqual;
const asOp = TokenType.asOp;
const isOp = TokenType.isOp;
const isNotOp = TokenType.isNotOp;
const equality = TokenType.equality;
const inequality = TokenType.inequality;
const logicalAnd = TokenType.logicalAnd;
const logicalOr = TokenType.logicalOr;
const cascade = TokenType.cascade;
const cascadeNullAware = TokenType.cascadeNullAware;
const spread = TokenType.spread;
const spreadNullAware = TokenType.spreadNullAware;
const assignment = TokenType.assignment;
const assignmentMultiplication = TokenType.assignmentMultiplication;
const assignmentDivision = TokenType.assignmentDivision;
const assignmentIntegerDivision = TokenType.assignmentIntegerDivision;
const assignmentRemainder = TokenType.assignmentRemainder;
const assignmentAddition = TokenType.assignmentAddition;
const assignmentSubtraction = TokenType.assignmentSubtraction;
const assignmentShiftLeft = TokenType.assignmentShiftLeft;
const assignmentShiftRightUnsigned = TokenType.assignmentShiftRightUnsigned;
const assignmentShiftRight = TokenType.assignmentShiftRight;
const assignmentBitwiseAnd = TokenType.assignmentBitwiseAnd;
const assignmentBitwiseXor = TokenType.assignmentBitwiseXor;
const assignmentBitwiseOr = TokenType.assignmentBitwiseOr;
const assignmentIfNull = TokenType.assignmentIfNull;

/// Returns a real token read from the [source] with a [Lexer].
/// The [source] must not produce more than 1 token.
Token oneToken(String source) {
  final lexer = Lexer(source);
  final token = lexer.read();
  expect(lexer.read(), isA<EofToken>());
  return token;
}

/// Uses the lexer to tokenize a string. Returns the list of tokens.
List<Token> tokenize(String source) {
  final lexer = Lexer(source);
  late Token token;
  final tokens = <Token>[];
  do {
    token = lexer.read();
    tokens.add(token);
  } while (token is! EofToken);
  return tokens;
}

/// Given a list of expected [lexemes], expect all of them to be scanned as
/// the same [type].
List<Token> checkTokens(List<String> lexemes, TokenType type) {
  final tokens = <Token>[];
  for (final lexeme in lexemes) {
    final lexer = Lexer(lexeme);
    final token = lexer.read();
    tokens.add(token);
    expect(token.type, type);
    expect(token.lexeme, lexeme);
  }
  return tokens;
}

/// Given a map of invalid [lexemes], expect all of them to be scanned as
/// the given [type]. Each key in [lexemes] represents an invalid lexeme, and
/// each value is the expected lexeme the lexer will actually pick up.
List<Token> checkTokensAs(Map<String, String> lexemes,
    [TokenType type = error]) {
  final tokens = <Token>[];
  for (final lexeme in lexemes.entries) {
    final lexer = Lexer(lexeme.key);
    final token = lexer.read();
    tokens.add(token);
    expect(token.type, type);
    expect(token.lexeme, lexeme.value);
  }
  return tokens;
}
