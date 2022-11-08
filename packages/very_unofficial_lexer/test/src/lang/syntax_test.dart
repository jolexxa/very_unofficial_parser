import 'package:test/test.dart';
import 'package:very_unofficial_lexer/src/lang/syntax.dart';

void main() {
  group('isDigit:', () {
    test('recognizes digits', () {
      expect(isDigit('0'), isTrue);
      expect(isDigit('1'), isTrue);
      expect(isDigit('2'), isTrue);
      expect(isDigit('3'), isTrue);
      expect(isDigit('4'), isTrue);
      expect(isDigit('5'), isTrue);
      expect(isDigit('6'), isTrue);
      expect(isDigit('7'), isTrue);
      expect(isDigit('8'), isTrue);
      expect(isDigit('9'), isTrue);
    });

    test('fails on non-digits', () {
      expect(isDigit('a'), isFalse);
      expect(isDigit('!'), isFalse);
      expect(isDigit('\n'), isFalse);
    });
  });

  group('isWhitespace:', () {
    test('contains basic whitespace escapes', () {
      expect(isWhitespace('\t'), isTrue);
      expect(isWhitespace(' '), isTrue);
    });

    test('fails on non-whitespace', () {
      // note: line break characters are not whitespace.
      expect(isWhitespace('\n'), isFalse);
      expect(isWhitespace('\r'), isFalse);
      expect(isWhitespace('a'), isFalse);
      expect(isWhitespace('!'), isFalse);
      expect(isWhitespace('9'), isFalse);
      expect(isWhitespace('?'), isFalse);
    });
  });

  group('isLetter:', () {
    test('recognizes letters', () {
      expect(isLetter('a'), isTrue);
      expect(isLetter('z'), isTrue);
      expect(isLetter('9'), isFalse);
      expect(isLetter('!'), isFalse);
    });
  });

  group('isBuiltInIdentifier:', () {
    test('recognizes built-in identifiers', () {
      expect(isBuiltInIdentifier('abstract'), isTrue);
      expect(isBuiltInIdentifier('bob'), isFalse);
    });
  });

  group('isReservedWord:', () {
    test('recognizes reserved words', () {
      expect(isReservedWord('assert'), isTrue);
      expect(isReservedWord('bob'), isFalse);
    });
  });
  group('isBoolLiteral:', () {
    test('recognizes boolean literals', () {
      expect(isBoolLiteral('true'), isTrue);
      expect(isBoolLiteral('false'), isTrue);
      expect(isBoolLiteral('not'), isFalse);
    });
  });

  group('isIdentifierStart:', () {
    test('recognizes identifier start, including dollar sign', () {
      expect(isIdentifierStart('a'), isTrue);
      expect(isIdentifierStart('z'), isTrue);
      expect(isIdentifierStart('9'), isFalse);
      expect(isIdentifierStart('_'), isTrue);
      expect(isIdentifierStart(r'$'), isTrue);
      expect(isIdentifierStart('!'), isFalse);
    });
  });

  group('isIdentifierPart:', () {
    test('recognizes identifier part, including dollar sign', () {
      expect(isIdentifierPart('a'), isTrue);
      expect(isIdentifierPart('z'), isTrue);
      expect(isIdentifierPart('9'), isTrue);
      expect(isIdentifierPart('_'), isTrue);
      expect(isIdentifierPart(r'$'), isTrue);
      expect(isIdentifierPart('!'), isFalse);
    });
  });

  group('isHexDigit:', () {
    test('recognizes hex digits', () {
      expect(isHexDigit('A'), isTrue);
      expect(isHexDigit('a'), isTrue);
      expect(isHexDigit('Z'), isFalse);
      expect(isHexDigit('g'), isFalse);
      expect(isHexDigit('!'), isFalse);
      expect(isHexDigit('1'), isTrue);
      expect(isHexDigit('4'), isTrue);
    });
  });

  group('isIdentifierStartNoDollar:', () {
    test('recognizes identifier start without dollar', () {
      expect(isIdentifierStartNoDollar('a'), isTrue);
      expect(isIdentifierStartNoDollar('_'), isTrue);
      expect(isIdentifierStartNoDollar('0'), isFalse);
      expect(isIdentifierStartNoDollar(r'$'), isFalse);
    });
  });

  group('isIdentifierPartNoDollar:', () {
    test('recognizes identifier part without dollar', () {
      expect(isIdentifierPartNoDollar('a'), isTrue);
      expect(isIdentifierPartNoDollar('_'), isTrue);
      expect(isIdentifierPartNoDollar('0'), isTrue);
      expect(isIdentifierPartNoDollar(r'$'), isFalse);
    });
  });

  group('isCommonStringContent:', () {
    test('recognizes common string content', () {
      expect(isCommonStringContent(r'\'), isFalse);
      expect(isCommonStringContent("'"), isFalse);
      expect(isCommonStringContent('"'), isFalse);
      expect(isCommonStringContent(r'$'), isFalse);
      expect(isCommonStringContent('\n'), isFalse);
      expect(isCommonStringContent('\r'), isFalse);
      expect(isCommonStringContent('a'), isTrue);
      expect(isCommonStringContent('~'), isTrue);
      expect(isCommonStringContent('1'), isTrue);
    });
  });

  group('isCommonMultilineStringContent:', () {
    test('recognizes common multiline string content', () {
      expect(isCommonMultilineStringContent(r'\'), isFalse);
      expect(isCommonMultilineStringContent("'"), isFalse);
      expect(isCommonMultilineStringContent('"'), isFalse);
      expect(isCommonMultilineStringContent(r'$'), isFalse);
      expect(isCommonMultilineStringContent('\n'), isTrue);
      expect(isCommonMultilineStringContent('\r'), isTrue);
      expect(isCommonMultilineStringContent('a'), isTrue);
      expect(isCommonMultilineStringContent('~'), isTrue);
      expect(isCommonMultilineStringContent('1'), isTrue);
    });
  });
}
