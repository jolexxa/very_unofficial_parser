import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:very_unofficial_lexer/very_unofficial_lexer.dart';
import 'package:very_unofficial_parser/very_unofficial_parser.dart';

import '../../test_utils/test_utils.dart';

class MockPrattParser extends Mock implements PrattParser {}

class MockExpression extends Mock implements Expression {}

void main() {
  group('PrefixOperatorParselet', () {
    test('initializes', () {
      const precedence = Precedence.unaryPrefix;
      final parselet = PrefixOperatorParselet(precedence);
      expect(parselet.precedence, precedence);
    });

    test('parses prefix expression', () {
      final parser = MockPrattParser();
      final token = oneToken('++');
      const precedence = Precedence.unaryPrefix;
      final rhs = MockExpression();
      final parselet = PrefixOperatorParselet(precedence);

      when(() => parser.expression(precedence)).thenReturn(rhs);

      final expression = parselet.parse(parser, token);

      expect(expression.rhs, rhs);
      expect(expression.operatorToken, token);
    });
  });

  group('PostfixOperatorParselet', () {
    test('initializes', () {
      const precedence = Precedence.unaryPrefix;
      final parselet = PostfixOperatorParselet(precedence);
      expect(parselet.precedence, precedence);
    });

    test('parses postfix expression', () {
      final parser = MockPrattParser();
      final token = oneToken('++');
      const precedence = Precedence.unaryPostfix;
      final lhs = MockExpression();
      final parselet = PostfixOperatorParselet(precedence);

      final expression = parselet.parse(parser, token, lhs);

      expect(expression.lhs, lhs);
      expect(expression.operatorToken, token);
    });

    group('BinaryOperatorParselet', () {
      test('initializes', () {
        const precedence = Precedence.unaryPrefix;
        const isRightAssociative = true;

        final parselet = BinaryOperatorParselet(
          precedence,
          isRightAssociative: isRightAssociative,
        );

        expect(parselet.precedence, precedence);
        expect(parselet.isRightAssociative, isRightAssociative);
      });

      test('parses binary expression when right associative', () {
        final parser = MockPrattParser();
        final token = oneToken('=');
        const precedence = Precedence.assignment;
        const isRightAssociative = true;
        final lhs = MockExpression();
        final rhs = MockExpression();
        final parselet = BinaryOperatorParselet(
          precedence,
          isRightAssociative: isRightAssociative,
        );

        when(() => parser.expression(precedence - 1)).thenReturn(rhs);

        final expression = parselet.parse(parser, token, lhs);

        expect(expression.lhs, lhs);
        expect(expression.operatorToken, token);
        expect(expression.rhs, rhs);
      });

      test('parses binary expression when not right associative', () {
        final parser = MockPrattParser();
        final token = oneToken('=');
        const precedence = Precedence.assignment;
        const isRightAssociative = false;
        final lhs = MockExpression();
        final rhs = MockExpression();
        final parselet = BinaryOperatorParselet(
          precedence,
          isRightAssociative: isRightAssociative,
        );

        when(() => parser.expression(precedence)).thenReturn(rhs);

        final expression = parselet.parse(parser, token, lhs);

        expect(expression.lhs, lhs);
        expect(expression.operatorToken, token);
        expect(expression.rhs, rhs);
      });
    });

    group('GroupParselet', () {
      test('parses group expression', () {
        final parser = MockPrattParser();
        final tokens = tokenList('()');
        final openToken = tokens[0];
        final closeToken = tokens[1];
        final innerExpression = MockExpression();
        final parselet = GroupParselet();

        when(parser.expression).thenReturn(innerExpression);
        when(
          () => parser.consume<ParenCloseToken>(
            error: any(named: 'error', that: isA<String>()),
          ),
        ).thenReturn(closeToken);

        final expression = parselet.parse(parser, openToken);

        expect(expression.openToken, openToken);
        expect(expression.expression, innerExpression);
        expect(expression.closeToken, closeToken);
      });
    });

    group('ReferenceParselet', () {
      test('parses reference expression', () {
        final parser = MockPrattParser();
        final token = oneToken('a');
        final parselet = ReferenceParselet();

        final expression = parselet.parse(parser, token);

        expect(expression.idToken, token);
        expect(expression.identifier, token.lexeme);
      });
    });

    group('NumericLiteralParselet', () {
      test('parses numeric literal expression', () {
        final parser = MockPrattParser();
        final token = oneToken('42');
        final parselet = NumericLiteralParselet();

        final expression = parselet.parse(parser, token);

        expect(expression.numberToken, token);
      });
    });

    group('StringLiteralParselet', () {
      test('parses string literal expression', () {
        final parser = MockPrattParser();
        final token = oneToken('"hello"');
        final parselet = StringLiteralParselet();

        final expression = parselet.parse(parser, token);

        expect(expression.stringToken, token);
      });
    });

    group('BooleanLiteralParselet', () {
      test('parses boolean literal expression', () {
        final parser = MockPrattParser();
        final token = oneToken('true');
        final parselet = BooleanLiteralParselet();

        final expression = parselet.parse(parser, token);

        expect(expression.booleanToken, token);
      });
    });

    group('TernaryConditionalParselet', () {
      test('parses ternary conditional expression', () {
        final parser = MockPrattParser();
        final tokens = tokenList('a ? b : c');
        final questionToken = tokens[1];
        final colonToken = tokens[3];

        const precedence = Precedence.conditional;

        final predicate = MockExpression();
        final consequent = MockExpression();
        final alternative = MockExpression();

        final parselet = TernaryConditionalParselet();

        // mocktail can't handle multiple return values for the same invocation
        // signature, so we have to use this little hack to return different
        // values each time.
        var invocations = 0;
        final returns = [consequent, alternative];
        when(() => parser.expression(precedence - 1))
            .thenAnswer((_) => returns[invocations++ % returns.length]);

        when(
          () => parser.consume<ColonToken>(
            error: any(named: 'error', that: isA<String>()),
          ),
        ).thenReturn(colonToken);

        final expression = parselet.parse(parser, questionToken, predicate);

        expect(expression.predicate, predicate);
        expect(expression.questionToken, questionToken);
        expect(expression.consequent, consequent);
        expect(expression.colonToken, colonToken);
        expect(expression.alternative, alternative);
      });
    });
  });
}
