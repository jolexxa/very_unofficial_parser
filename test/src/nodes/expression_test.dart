import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:very_unofficial_lexer/very_unofficial_lexer.dart';
import 'package:very_unofficial_parser/src/nodes/expression.dart';
import 'package:very_unofficial_parser/src/parser/visitor.dart';

import '../../test_utils/test_utils.dart';

class MockExpression extends Mock implements Expression {}

class MockVisitor extends Mock implements Visitor {}

void main() {
  group('PrefixExpression', () {
    test('initializes and visits', () {
      final opToken = oneToken('+');
      final rhs = MockExpression();
      final expression = PrefixExpression(operatorToken: opToken, rhs: rhs);
      expect(expression.operatorToken, opToken);
      expect(expression.rhs, rhs);
      expect(expression.operator, TokenType.plus);
      final visitor = MockVisitor();
      when(() => visitor.visitPrefixExpression(expression)).thenReturn(null);
      expression.accept(visitor);
    });
  });

  group('PostfixExpression', () {
    test('initializes and visits', () {
      final opToken = oneToken('+');
      final lhs = MockExpression();
      final expression = PostfixExpression(operatorToken: opToken, lhs: lhs);
      expect(expression.operatorToken, opToken);
      expect(expression.lhs, lhs);
      expect(expression.operator, TokenType.plus);
      final visitor = MockVisitor();
      when(() => visitor.visitPostfixExpression(expression)).thenReturn(null);
      expression.accept(visitor);
    });
  });

  group('BinaryExpression', () {
    test('initializes and visits', () {
      final opToken = oneToken('+');
      final lhs = MockExpression();
      final rhs = MockExpression();
      final expression = BinaryExpression(
        operatorToken: opToken,
        lhs: lhs,
        rhs: rhs,
      );
      expect(expression.operatorToken, opToken);
      expect(expression.lhs, lhs);
      expect(expression.rhs, rhs);
      expect(expression.operator, TokenType.plus);
      final visitor = MockVisitor();
      when(() => visitor.visitBinaryExpression(expression)).thenReturn(null);
      expression.accept(visitor);
    });
  });

  group('GroupExpression', () {
    test('initializes and visits', () {
      final openToken = oneToken('(');
      final closeToken = oneToken(')');
      final expression = GroupExpression(
        openToken: openToken,
        expression: MockExpression(),
        closeToken: closeToken,
      );
      expect(expression.openToken, openToken);
      expect(expression.expression, isNotNull);
      expect(expression.closeToken, closeToken);
      final visitor = MockVisitor();
      when(() => visitor.visitGroupExpression(expression)).thenReturn(null);
      expression.accept(visitor);
    });
  });

  group('ReferenceExpression', () {
    test('initializes and visits', () {
      final token = oneToken('name') as IdToken;
      final expression = ReferenceExpression(idToken: token);
      expect(expression.idToken, token);
      expect(expression.identifier, token.lexeme);
      final visitor = MockVisitor();
      when(() => visitor.visitReferenceExpression(expression)).thenReturn(null);
      expression.accept(visitor);
    });
  });

  group('NumericLiteralExpression', () {
    test('initializes and visits', () {
      final token = oneToken('123') as NumberToken;
      final expression = NumericLiteralExpression(numberToken: token);
      expect(expression.numberToken, token);
      final visitor = MockVisitor();
      when(() => visitor.visitNumericLiteralExpression(expression))
          .thenReturn(null);
      expression.accept(visitor);
    });
  });

  group('StringLiteralExpression', () {
    test('initializes and visits', () {
      final token = oneToken('"abc"') as StringToken;
      final expression = StringLiteralExpression(stringToken: token);
      expect(expression.stringToken, token);
      final visitor = MockVisitor();
      when(() => visitor.visitStringLiteralExpression(expression))
          .thenReturn(null);
      expression.accept(visitor);
    });
  });

  group('BooleanLiteralExpression', () {
    test('initializes and visits', () {
      final token = oneToken('true') as BooleanToken;
      final expression = BooleanLiteralExpression(booleanToken: token);
      expect(expression.booleanToken, token);
      final visitor = MockVisitor();
      when(() => visitor.visitBooleanLiteralExpression(expression))
          .thenReturn(null);
      expression.accept(visitor);
    });
  });

  group('TernaryConditionalExpression', () {
    test('initializes and visits', () {
      final questionToken = oneToken('?');
      final colonToken = oneToken(':');
      final predicate = MockExpression();
      final consequent = MockExpression();
      final alternative = MockExpression();
      final expression = TernaryConditionalExpression(
        questionToken: questionToken,
        predicate: predicate,
        consequent: consequent,
        colonToken: colonToken,
        alternative: alternative,
      );
      expect(expression.questionToken, questionToken);
      expect(expression.predicate, predicate);
      expect(expression.consequent, consequent);
      expect(expression.colonToken, colonToken);
      expect(expression.alternative, alternative);
      final visitor = MockVisitor();
      when(() => visitor.visitTernaryConditionalExpression(expression))
          .thenReturn(null);
      expression.accept(visitor);
    });
  });
}
