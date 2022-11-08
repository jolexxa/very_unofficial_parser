import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:very_unofficial_lexer/very_unofficial_lexer.dart';
import 'package:very_unofficial_parser/src/parser/expression_table.dart';
import 'package:very_unofficial_parser/src/parser/parselet.dart';
import 'package:very_unofficial_parser/src/parser/precedence.dart';

class MockInfixParselet extends Mock implements InfixParselet {}

class MockPrefixParselet extends Mock implements PrefixParselet {}

void main() {
  group('ExpressionTable', () {
    test('registerPrefix', () {
      final table = ExpressionTable();
      final parselet = MockPrefixParselet();
      const type = TokenType.parenOpen;
      table.registerPrefix(type, parselet);
      expect(table.hasPrefix(type), isTrue);
      expect(table.getPrefix(type), parselet);
    });

    test('registerInfix', () {
      final table = ExpressionTable();
      final parselet = MockInfixParselet();
      const type = TokenType.question;
      table.registerInfix(type, parselet);
      expect(table.hasInfix(type), isTrue);
      expect(table.getInfix(type), parselet);
    });

    test('prefixOp', () {
      final table = ExpressionTable();
      const type = TokenType.minus;
      const precedence = Precedence.unaryPrefix;
      table.prefixOp(type, precedence);
      final parselet = table.getPrefix(type) as PrefixOperatorParselet;
      expect(parselet.precedence, precedence);
    });

    test('postfixOp', () {
      final table = ExpressionTable();
      const type = TokenType.increment;
      const precedence = Precedence.unaryPostfix;
      table.postfixOp(type, precedence);
      final parselet = table.getInfix(type) as PostfixOperatorParselet;
      expect(parselet.precedence, precedence);
    });

    test('infixOpLeft', () {
      final table = ExpressionTable();
      const type = TokenType.plus;
      const precedence = Precedence.additive;
      table.infixOpLeft(type, precedence);
      final parselet = table.getInfix(type) as BinaryOperatorParselet;
      expect(parselet.precedence, precedence);
      expect(parselet.isRightAssociative, isFalse);
    });

    test('infixOpRight', () {
      final table = ExpressionTable();
      const type = TokenType.equality;
      const precedence = Precedence.assignment;
      table.infixOpRight(type, precedence);
      final parselet = table.getInfix(type) as BinaryOperatorParselet;
      expect(parselet.precedence, precedence);
      expect(parselet.isRightAssociative, isTrue);
    });
  });
}
