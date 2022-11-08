import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:very_unofficial_lexer/very_unofficial_lexer.dart';
import 'package:very_unofficial_parser/very_unofficial_parser.dart';

import '../../test_utils/test_utils.dart';

class MockExpressionTable extends Mock implements ExpressionTable {}

class MockInfixParselet extends Mock implements InfixParselet {}

class MockPrefixParselet extends Mock implements PrefixParselet {}

class MockExpression extends Mock implements Expression {}

void main() {
  setUpAll(() {
    registerFallbackValue(EofToken(position: Position.zero));
  });

  group('PrattParser', () {
    test('initializes', () {
      final expressionTable = MockExpressionTable();
      final tokens = tokenize('a b').iterator;
      final parser = PrattParser(tokens, expressionTable);
      expect(parser.tokens, same(tokens));
      expect(parser.expressionTable, same(expressionTable));
    });

    group('peekPrecedence', () {
      test('returns upcoming infix precedence', () {
        final parselet = MockInfixParselet();
        const precedence = Precedence.conditional;
        when(() => parselet.precedence).thenReturn(precedence);
        final expressionTable = MockExpressionTable();
        when(() => expressionTable.hasInfix(TokenType.question))
            .thenReturn(true);
        when(() => expressionTable.getInfix(TokenType.question))
            .thenReturn(parselet);

        final parser = PrattParser(tokenize('?').iterator, expressionTable);

        expect(parser.peekPrecedence, precedence);
      });

      test('returns none if no infix operator is upcoming', () {
        final expressionTable = MockExpressionTable();
        when(() => expressionTable.hasInfix(TokenType.question))
            .thenReturn(false);

        final parser = PrattParser(tokenize('?').iterator, expressionTable);

        expect(parser.peekPrecedence, Precedence.none);
      });
    });

    group('expression', () {
      test('throws state error if no prefix parselet indicated', () {
        final expressionTable = MockExpressionTable();
        when(() => expressionTable.hasPrefix(TokenType.question))
            .thenReturn(false);

        final parser = PrattParser(tokenize('?').iterator, expressionTable);

        expect(parser.expression, throwsStateError);
      });

      test('parses prefix expression', () {
        final parselet = MockPrefixParselet();
        final expressionTable = MockExpressionTable();
        when(() => expressionTable.hasPrefix(TokenType.plus)).thenReturn(true);
        when(() => expressionTable.getPrefix(TokenType.plus))
            .thenReturn(parselet);
        when(() => expressionTable.hasInfix(TokenType.eof)).thenReturn(false);
        final expression = MockExpression();
        final parser = PrattParser(tokenize('+').iterator, expressionTable);
        when(() => parselet.parse(parser, any(that: isA<PlusToken>())))
            .thenReturn(expression);

        expect(parser.expression(), same(expression));
      });

      test('parses infix expression', () {
        final prefix = MockPrefixParselet();
        final infix = MockInfixParselet();
        final expression = MockExpression();
        final lhs = MockExpression();
        final expressionTable = MockExpressionTable();

        when(() => expressionTable.hasPrefix(TokenType.id)).thenReturn(true);
        when(() => expressionTable.getPrefix(TokenType.id)).thenReturn(prefix);
        when(() => expressionTable.hasInfix(TokenType.plus)).thenReturn(true);
        when(() => expressionTable.getInfix(TokenType.plus)).thenReturn(infix);
        when(() => infix.precedence).thenReturn(Precedence.additive);
        when(() => expressionTable.hasInfix(TokenType.id)).thenReturn(false);

        final parser = PrattParser(tokenize('a + b').iterator, expressionTable);

        when(() => prefix.parse(parser, any(that: isA<IdToken>())))
            .thenReturn(lhs);
        when(() => infix.parse(parser, any(that: isA<PlusToken>()), lhs))
            .thenReturn(expression);

        expect(parser.expression(), same(expression));
      });
    });
  });
}
