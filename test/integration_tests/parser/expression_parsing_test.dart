import 'package:test/test.dart';
import 'package:very_unofficial_lexer/very_unofficial_lexer.dart';
import 'package:very_unofficial_parser/very_unofficial_parser.dart';

import '../../test_utils/test_utils.dart';

void main() {
  // Integration tests for parsing expressions.
  // Test all the systems together (parser, parselets, lexer) and make sure we
  // can get a well-formed AST from the parser.
  group('Expression Parsing Scenarios', () {
    test('1 + 1', () {
      // If it can't parse this, we're in trouble.

      final tokens = tokenize('1 + 1');
      final parser = PrattParser(tokens.iterator, Grammar.expressionTable);

      final ast = parser.expression();

      expect(ast, isA<BinaryExpression>());

      final binary = ast as BinaryExpression;
      expect(binary.lhs, isA<NumericLiteralExpression>());
      expect(binary.operatorToken.type, TokenType.plus);
      expect(binary.rhs, isA<NumericLiteralExpression>());
    });

    test('true && false', () {
      final tokens = tokenize('true && false');
      final parser = PrattParser(tokens.iterator, Grammar.expressionTable);

      final ast = parser.expression();

      expect(ast, isA<BinaryExpression>());

      final binary = ast as BinaryExpression;
      expect(binary.lhs, isA<BooleanLiteralExpression>());
      expect(binary.operatorToken.type, TokenType.logicalAnd);
      expect(binary.rhs, isA<BooleanLiteralExpression>());
    });

    test('a + b', () {
      final tokens = tokenize('a + b');
      final parser = PrattParser(tokens.iterator, Grammar.expressionTable);

      final ast = parser.expression();

      final expectedAst = BinaryExpressionMatcher(
        lhs: ReferenceExpressionMatcher(id: equals('a')),
        operatorToken: const TypeMatcher<PlusToken>(),
        rhs: ReferenceExpressionMatcher(id: equals('b')),
      );

      expect(ast, expectedAst);
    });

    test('a + (b - c)', () {
      final tokens = tokenize('a + (b - c)');
      final parser = PrattParser(tokens.iterator, Grammar.expressionTable);

      final ast = parser.expression();

      final expectedAst = BinaryExpressionMatcher(
        lhs: ReferenceExpressionMatcher(id: equals('a')),
        operatorToken: const TypeMatcher<PlusToken>(),
        rhs: GroupExpressionMatcher(
          expression: BinaryExpressionMatcher(
            lhs: ReferenceExpressionMatcher(id: equals('b')),
            operatorToken: const TypeMatcher<MinusToken>(),
            rhs: ReferenceExpressionMatcher(id: equals('c')),
          ),
        ),
      );

      expect(ast, expectedAst);
    });

    test('a * b - 3 % c + x', () {
      // should be (((a * b) - (3 % c)) + x)
      final tokens = tokenize('a * b - 3 % c + x');
      final parser = PrattParser(tokens.iterator, Grammar.expressionTable);

      final ast = parser.expression();

      final expectedAst = BinaryExpressionMatcher(
        lhs: BinaryExpressionMatcher(
          lhs: BinaryExpressionMatcher(
            lhs: ReferenceExpressionMatcher(id: equals('a')),
            operatorToken: const TypeMatcher<MultiplicationToken>(),
            rhs: ReferenceExpressionMatcher(id: equals('b')),
          ),
          operatorToken: const TypeMatcher<MinusToken>(),
          rhs: BinaryExpressionMatcher(
            lhs: NumericLiteralExpressionMatcher(
              numberToken:
                  isA<NumberToken>().having((t) => t.value, 'value', equals(3)),
            ),
            operatorToken: const TypeMatcher<RemainderToken>(),
            rhs: ReferenceExpressionMatcher(id: equals('c')),
          ),
        ),
        operatorToken: const TypeMatcher<PlusToken>(),
        rhs: ReferenceExpressionMatcher(id: equals('x')),
      );

      expect(ast, expectedAst);
    });
  });
}
