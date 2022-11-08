import 'package:test/test.dart' hide greaterThan, lessThan;
import 'package:very_unofficial_lexer/src/lang/lang.dart';
import 'package:very_unofficial_lexer/src/lexer/lexer.dart';
import 'package:very_unofficial_lexer/src/lexical/lexical.dart';
import 'package:very_unofficial_lexer/src/tokens/tokens.dart';

import '../../lexer_utils.dart';

void main() {
  group('BraceTypeExtensions', () {
    test('quote', () {
      expect(BraceType.singleQuote.quote, "'");
      expect(BraceType.singleQuoteMultiline.quote, "'");
      expect(BraceType.doubleQuote.quote, '"');
      expect(BraceType.doubleQuoteMultiline.quote, '"');
      expect(() => BraceType.normal.quote, throwsStateError);
    });
    test('isMultiline', () {
      expect(BraceType.singleQuote.isMultiline, isFalse);
      expect(BraceType.singleQuoteMultiline.isMultiline, isTrue);
      expect(BraceType.doubleQuote.isMultiline, isFalse);
      expect(BraceType.doubleQuoteMultiline.isMultiline, isTrue);
      expect(() => BraceType.normal.isMultiline, throwsStateError);
    });
  });

  group('initialization', () {
    test('initializes on empty file', () {
      expect(() => Lexer(''), returnsNormally);
    });
  });

  group('token positions', () {
    test(
        'scans token and lookahead, '
        'will not read past end of file, '
        'and token positions are computed correctly', () {
      final lexer = Lexer('  \r\n');
      const endPosition = Position(index: 4, line: 1, col: 4);

      expect(lexer.head, Position.zero);
      expect(lexer.tail, Position.zero);
      expect(lexer.isAtEnd, false);
      expect(lexer.peek, ' ');
      expect(lexer.lexeme, '');
      expect(lexer.numTokens, 0);
      final token1 = WhitespaceToken(
        state: const LexerState(
          position: Position.zero,
          length: 2,
          lexeme: '  ',
        ),
      );
      final token2 = LineToken(
        state: const LexerState(
          position: Position(index: 2, line: 1, col: 2),
          length: 2,
          lexeme: '\r\n',
        ),
      );
      final token3 = EofToken(position: endPosition);
      final tokenA = lexer.read();
      expect(tokenA, equals(token1));
      expect(tokenA.end, 2);
      expect(lexer.head, const Position(index: 2, line: 1, col: 2));
      final tokenB = lexer.read();
      expect(tokenB, equals(token2));
      expect(lexer.read(), equals(token3));
      expect(lexer.head, equals(endPosition));
      expect(lexer.tail, equals(endPosition));
      expect(lexer.isAtEnd, true);
      expect(lexer.numTokens, 3);
      expect(lexer.eofToken, equals(token3));
      expect(lexer.advance, throwsA(isA<StateError>()));
    });
  });

  group('match', () {
    test('will not match at end of file', () {
      final lexer = Lexer('');
      expect(lexer.match('a'), isFalse);
    });
    test('will not match on unexpected input', () {
      final lexer = Lexer(' \n ');
      expect(lexer.match('X'), false);
    });
    test('advances on expected match', () {
      final lexer = Lexer('\n\n\n');
      expect(lexer.match('\n'), true);
      expect(lexer.head.index, 1);
    });
  });

  group('errors', () {
    test('creates well-formed errors', () {
      final lexer = Lexer('\v');
      expect(
        lexer.read(),
        equals(
          ErrorToken(
            state: const LexerState(
              position: Position.zero,
              length: 1,
              lexeme: '\v',
            ),
            hint: 'syntax error',
          ),
        ),
      );
    });
  });

  group('tokens', () {
    test('whitespace', () {
      checkTokens(
        [' ', '  ', '\t  \t  ', ' \t'],
        TokenType.whitespace,
      );
    });

    group('forward slash and comments', () {
      test('division operators', () {
        checkTokens(['/'], division);
        checkTokens(['/='], assignmentDivision);
      });

      test('single line comment', () {
        checkTokens(
          ['//', '//  ', '//\t  hi!', '// .81*', '//  😅', '//a'],
          comment,
        );
      });

      test('single line doc comment', () {
        checkTokens(
          ['///', '///  ', '///\t  hi!', '/// .81*', '///  😅', '///a'],
          commentDoc,
        );
      });

      group('multi line comments', () {
        test('matches simple multiline comments', () {
          checkTokens(
            [
              '/**/',
              '/* */',
              '/*\t*/',
              '/*\t  */',
              '/* .81* */',
              '/*  😅 */',
              '/*a*/'
            ],
            commentMultiline,
          );
        });
        test('matches valid nested comments', () {
          checkTokens(
            ['/* hello/*world ayy*/eek */', '/* ooh/* ahh*/ */', '/*/**/*/'],
            commentMultiline,
          );
        });
        test('rejects badly nested comment', () {
          const string = '/*/*hello\n /*world*/*/';
          final err = checkTokens([string], error).single as ErrorToken;
          expect(err.hint, 'unterminated comment');
        });
        test('finishes comment when nesting ends', () {
          const string = '/*/*hello\n /*world*/*/*/';
          checkTokensAs({'$string*/': string}, commentMultiline);
        });
        test('matches multiline doc comment', () {
          checkTokens(
              ['/***hello\n /*world*/*/', '/***/'], commentMultilineDoc);
        });
        test('rejects badly nested doc comment', () {
          const string = '/** /*hello\n /*world*/*/';
          final err = checkTokens([string], error).single as ErrorToken;
          expect(err.hint, 'unterminated comment');
        });
      });
    });
    group('identifier', () {
      test('matches valid identifiers', () {
        checkTokens([
          r'$$my_crazy$_id',
          r'_$',
          r'$_',
          r'_1$13',
          r'$_1_1',
          'id',
          'a_va39_0lid135_id',
          'A_Valid_Id'
        ], TokenType.id);
      });

      test('id operators', () {
        checkTokens(['is'], isOp);
        checkTokens(['is!'], isNotOp);
        checkTokens(['as'], asOp);
      });

      test('bool literals', () {
        expect(oneToken('true'),
            isA<BooleanToken>().having((t) => t.value, 'value', equals(true)));
        expect(oneToken('false'),
            isA<BooleanToken>().having((t) => t.value, 'value', equals(false)));
      });
    });

    group('numbers', () {
      test('matches numbers', () {
        final numbers = [
          '1',
          '13581',
          '313.5',
          '315.31531',
          '3123e103',
          '583e-1',
          '5381E+10',
          '55681.538e103',
          '55681.538E103',
          '55681.538e-103',
          '55681.538E-103',
          '.1581',
          '.1e+10',
          '.1E+10',
          '.0014571E+10',
          '00.0014571e-10',
        ];
        checkTokens(numbers, TokenType.number);
      });
      test('rejects invalid numbers', () {
        final badNumbers = [
          '1.',
          '1.2e',
          '.1e',
          '5803.1e-',
          '53.68E+',
        ];
        checkTokens(badNumbers, TokenType.error);
      });
    });

    group('hex numbers', () {
      test('matches valid hex literals', () {
        final hexNumbers = [
          '0x1FE31',
          '0xe3Fa3',
          '0x0',
          '0xA',
          '0X0',
          '0XA',
        ];
        checkTokens(hexNumbers, TokenType.number);
      });
      test('rejects invalid hex literals', () {
        // ^_^
        final evilHexes = {'0X': '0X', '0x': '0x', '0xG': '0x', '0Xg': '0X'};
        checkTokensAs(evilHexes);
      });
    });

    group('raw strings', () {
      group('single line', () {
        test('matches a valid raw string', () {
          final lexer = Lexer('r"hello, world"\n');
          final token = lexer.read();
          expect(token, isA<StringToken>());
          final string = token as StringToken;
          expect(string.type, TokenType.string);
          expect(string.isClosed, isTrue);
          expect(string.isRaw, isTrue);
          expect(string.isMultiline, isFalse);
          expect(string.lexeme, 'r"hello, world"');
          expect(string.value, 'hello, world');
        });

        test('matches empty string', () {
          final lexer = Lexer("\nr''\n")..read();
          final token = lexer.read();
          expect(token, isA<StringToken>());
          final string = token as StringToken;
          expect(string.lexeme, "r''");
          expect(string.value, '');
        });

        test('unterminated string with line', () {
          final lexer = Lexer('r"hello, world\n');
          final token = lexer.read();
          expect(token, isA<ErrorToken>());
          expect(lexer.read(), isA<LineToken>());
        });

        test('unterminated string at end', () {
          final lexer = Lexer('r"hello, world');
          final token = lexer.read();
          expect(token, isA<ErrorToken>());
          expect(lexer.read(), isA<EofToken>());
        });
      });

      group('multiline', () {
        test('matches a valid multiline raw string', () {
          final lexer = Lexer('r"""hello, world"""\n');
          final token = lexer.read();
          expect(token, isA<StringToken>());
          final string = token as StringToken;
          expect(string.type, TokenType.string);
          expect(string.isClosed, isTrue);
          expect(string.isRaw, isTrue);
          expect(string.isMultiline, isTrue);
          expect(string.lexeme, 'r"""hello, world"""');
          expect(string.value, 'hello, world');
        });

        test('matches empty multiline string', () {
          final lexer = Lexer("\nr''''''")..read();
          final token = lexer.read();
          expect(token, isA<StringToken>());
          final string = token as StringToken;
          expect(string.lexeme, "r''''''");
          expect(string.value, '');
        });

        test('unterminated string with line', () {
          final lexer = Lexer('r"""hello, world\n');
          final token = lexer.read();
          expect(token, isA<ErrorToken>());
          expect(lexer.read(), isA<EofToken>());
        });

        test('unterminated string at end', () {
          final lexer = Lexer('r"""hello, world');
          final token = lexer.read();
          expect(token, isA<ErrorToken>());
          expect(lexer.read(), isA<EofToken>());
        });
      });
    });

    group('strings', () {
      group('single line', () {
        group('empty', () {
          test('single quotes', () {
            final lexer = Lexer("''");
            final token = lexer.read();
            expect(token, isA<StringToken>());
            final string = token as StringToken;
            expect(string.isClosed, isTrue);
            expect(string.isRaw, isFalse);
            expect(string.isMultiline, isFalse);
            expect(string.lexeme, "''");
            expect(string.value, '');
          });
          test('double quotes', () {
            final lexer = Lexer('""');
            final token = lexer.read();
            expect(token, isA<StringToken>());
            final string = token as StringToken;
            expect(string.isClosed, isTrue);
            expect(string.isRaw, isFalse);
            expect(string.isMultiline, isFalse);
            expect(string.lexeme, '""');
            expect(string.value, '');
          });
        });

        group('unterminated', () {
          test('invalid new line', () {
            final lexer = Lexer('"hello, world\n"');
            final token = lexer.read();
            expect(token, isA<ErrorToken>());
            expect(lexer.read(), isA<LineToken>());
          });

          test('out of characters', () {
            final lexer = Lexer('"hello, world');
            final token = lexer.read();
            expect(token, isA<ErrorToken>());
            expect(lexer.read(), isA<EofToken>());
          });
        });

        group('escapes', () {
          test('unicode escapes', () {
            final lexer = Lexer(r'"\u0041\u0042\u0043"');
            final token = lexer.read();
            expect(token, isA<StringToken>());
            final string = token as StringToken;
            expect(string.isClosed, isTrue);
            expect(string.isRaw, isFalse);
            expect(string.isMultiline, isFalse);
            expect(string.lexeme, r'"\u0041\u0042\u0043"');
            expect(string.value, 'ABC');
          });

          test('variable length unicode escapes', () {
            final lexer = Lexer(r'"\u{41}\u{000042}\u{043}"');
            final token = lexer.read();
            expect(token, isA<StringToken>());
            final string = token as StringToken;
            expect(string.isClosed, isTrue);
            expect(string.isRaw, isFalse);
            expect(string.isMultiline, isFalse);
            expect(string.lexeme, r'"\u{41}\u{000042}\u{043}"');
            expect(string.value, 'ABC');
          });

          test(r'\x escapes', () {
            final lexer = Lexer(r'"\x41\x42\x43"');
            final token = lexer.read();
            expect(token, isA<StringToken>());
            final string = token as StringToken;
            expect(string.isClosed, isTrue);
            expect(string.isRaw, isFalse);
            expect(string.isMultiline, isFalse);
            expect(string.lexeme, r'"\x41\x42\x43"');
            expect(string.value, 'ABC');
          });

          test('single quote escapes', () {
            final lexer = Lexer(r"'\''");
            final token = lexer.read();
            expect(token, isA<StringToken>());
            final string = token as StringToken;
            expect(string.isClosed, isTrue);
            expect(string.isRaw, isFalse);
            expect(string.isMultiline, isFalse);
            expect(string.lexeme, r"'\''");
            expect(string.value, "'");
          });

          test('double quote escapes', () {
            final lexer = Lexer(r'"\""');
            final token = lexer.read();
            expect(token, isA<StringToken>());
            final string = token as StringToken;

            expect(string.isClosed, isTrue);
            expect(string.isRaw, isFalse);
            expect(string.isMultiline, isFalse);
            expect(string.lexeme, r'"\""');
            expect(string.value, '"');
          });

          test('newline, carriage return, etc', () {
            final lexer = Lexer(r'"\n\r\f\b\t\v"');
            final token = lexer.read();
            expect(token, isA<StringToken>());
            final string = token as StringToken;

            expect(string.isClosed, isTrue);
            expect(string.isRaw, isFalse);
            expect(string.isMultiline, isFalse);
            expect(string.lexeme, r'"\n\r\f\b\t\v"');
            expect(string.value, '\n\r\f\b\t\v');
          });

          test('newline not allowed after slash', () {
            final lexer = Lexer('"\\\n"');
            final token = lexer.read();
            expect(token, isA<ErrorToken>());
            expect(lexer.read(), isA<LineToken>());
          });

          test('carriage return not allowed after slash', () {
            final lexer = Lexer('"\\\r"');
            final token = lexer.read();
            expect(token, isA<ErrorToken>());
            expect(lexer.read(), isA<LineToken>());
          });

          test('non-escape is permitted', () {
            final lexer = Lexer(r'"\q"');
            final token = lexer.read();
            expect(token, isA<StringToken>());
            final string = token as StringToken;
            expect(string.value, 'q');
          });
        });

        group('simple interpolation', () {
          test('single quotes', () {
            final lexer = Lexer(r'"hello, $name!"');
            final token = lexer.read();
            expect(token, isA<InterpolatedStringToken>());
            final string = token as InterpolatedStringToken;
            expect(string.isClosed, isTrue);
            expect(string.isRaw, isFalse);
            expect(string.isMultiline, isFalse);
            expect(string.lexeme, r'"hello, $name!"');
            expect(string.value, r'hello, $name!');
            expect(string.spans, [
              ContentSpan('hello, '),
              InterpolationSpan(
                start: const Position(index: 9, line: 1, col: 9),
                id: 'name',
              ),
              ContentSpan('!'),
            ]);
          });

          test('rejects bad identifier for interpolation', () {
            final lexer = Lexer(r'"$$name"');
            final token = lexer.read();
            expect(token, isA<ErrorToken>());
          });

          test('back to back interpolations', () {
            final lexer = Lexer(r'"$name$age"');
            final token = lexer.read();
            expect(token, isA<InterpolatedStringToken>());
            final string = token as InterpolatedStringToken;
            expect(string.isClosed, isTrue);
            expect(string.isRaw, isFalse);
            expect(string.isMultiline, isFalse);
            expect(string.lexeme, r'"$name$age"');
            expect(string.value, r'$name$age');
            expect(string.spans, [
              InterpolationSpan(
                start: const Position(index: 2, line: 1, col: 2),
                id: 'name',
              ),
              InterpolationSpan(
                start: const Position(index: 7, line: 1, col: 7),
                id: 'age',
              )
            ]);
          });
        });

        group('complex interpolation', () {
          test('re-enters string', () {
            final lexer = Lexer(r'"hello, ${name}!"');
            final token = lexer.read();
            expect(token, isA<InterpolatedStringToken>());
            final first = token as InterpolatedStringToken;
            expect(first.spans, [ContentSpan('hello, ')]);
            expect(first.isClosed, false);
            expect(first.value, 'hello, ');
            expect(first.lexeme, r'"hello, ${');
            final id = lexer.read();
            expect(id, isA<IdToken>());
            expect(id.lexeme, 'name');
            final last = lexer.read();
            expect(last, isA<InterpolatedStringToken>());
            final lastToken = last as InterpolatedStringToken;
            expect(lastToken.isClosed, true);
            expect(lastToken.value, '!');
            expect(lastToken.lexeme, '}!"');
          });

          test('nested interpolation', () {
            final lexer = Lexer(r'"hello, ${"${name}"}!"');
            final token = lexer.read();
            expect(token, isA<InterpolatedStringToken>());
            final first = token as InterpolatedStringToken;
            expect(first.spans, [ContentSpan('hello, ')]);
            expect(first.isClosed, false);
            expect(first.value, 'hello, ');
            expect(first.lexeme, r'"hello, ${');
            final second = lexer.read();
            expect(second, isA<InterpolatedStringToken>());
            final secondToken = second as InterpolatedStringToken;
            expect(secondToken.value, '');
            expect(secondToken.lexeme, r'"${');
            expect(secondToken.isClosed, false);
            final id = lexer.read();
            expect(id, isA<IdToken>());
            expect(id.lexeme, 'name');
            final third = lexer.read();
            expect(third, isA<InterpolatedStringToken>());
            final thirdToken = third as InterpolatedStringToken;
            expect(thirdToken.isClosed, true);
            expect(thirdToken.value, '');
            expect(thirdToken.lexeme, '}"');
            final last = lexer.read();
            expect(last, isA<InterpolatedStringToken>());
            final lastToken = last as InterpolatedStringToken;
            expect(lastToken.isClosed, true);
            expect(lastToken.value, '!');
            expect(lastToken.lexeme, '}!"');
          });
        });
      });
      group('multiline', () {
        group('empty', () {
          test('single quote multiline string', () {
            final lexer = Lexer("''''''");
            final token = lexer.read();
            expect(token, isA<InterpolatedStringToken>());
            final string = token as InterpolatedStringToken;
            expect(string.isClosed, isTrue);
            expect(string.isRaw, isFalse);
            expect(string.isMultiline, isTrue);
            expect(string.lexeme, "''''''");
            expect(string.value, '');
          });
          test('double quote multiline string', () {
            final lexer = Lexer('""""""');
            final token = lexer.read();
            expect(token, isA<InterpolatedStringToken>());
            final string = token as InterpolatedStringToken;
            expect(string.isClosed, isTrue);
            expect(string.isRaw, isFalse);
            expect(string.isMultiline, isTrue);
            expect(string.lexeme, '""""""');
            expect(string.value, '');
          });
        });

        group('contents', () {
          group('quotes', () {
            test('single quote multiline string', () {
              final lexer = Lexer("'''hello, ''name''!'''");
              final token = lexer.read();
              expect(token, isA<InterpolatedStringToken>());
              final string = token as InterpolatedStringToken;
              expect(string.isMultiline, isTrue);
              expect(string.isClosed, isTrue);
              expect(string.lexeme, "'''hello, ''name''!'''");
              expect(string.value, "hello, ''name''!");
            });

            test('double quote multiline string', () {
              final lexer = Lexer('"""hello, ""name""!"""');
              final token = lexer.read();
              expect(token, isA<InterpolatedStringToken>());
              final string = token as InterpolatedStringToken;
              expect(string.isMultiline, isTrue);
              expect(string.isClosed, isTrue);
              expect(string.lexeme, '"""hello, ""name""!"""');
              expect(string.value, 'hello, ""name""!');
            });

            test('single quote allows double quote', () {
              final lexer = Lexer("'''hello, \"name\"!'''");
              final token = lexer.read();
              expect(token, isA<InterpolatedStringToken>());
              final string = token as InterpolatedStringToken;
              expect(string.isMultiline, isTrue);
              expect(string.isClosed, isTrue);
              expect(string.lexeme, "'''hello, \"name\"!'''");
              expect(string.value, 'hello, "name"!');
            });

            test('double quote allows single quote', () {
              final lexer = Lexer('"""hello, \'name\'!"');
              final token = lexer.read();
              expect(token, isA<InterpolatedStringToken>());
              final string = token as InterpolatedStringToken;
              expect(string.isMultiline, isTrue);
              expect(string.isClosed, isTrue);
              expect(string.lexeme, '"""hello, \'name\'!"');
              expect(string.value, "hello, 'name'!");
            });
          });
        });

        group('simple interpolation', () {
          test('single quote multiline string', () {
            final lexer = Lexer(r"'''hello, $name!'''");
            final token = lexer.read();
            expect(token, isA<InterpolatedStringToken>());
            final string = token as InterpolatedStringToken;
            expect(string.isMultiline, isTrue);
            expect(string.isClosed, isTrue);
            expect(string.lexeme, r"'''hello, $name!'''");
            expect(string.value, r'hello, $name!');
            expect(string.spans, [
              ContentSpan('hello, '),
              InterpolationSpan(
                start: const Position(index: 11, line: 1, col: 11),
                id: 'name',
              ),
              ContentSpan('!')
            ]);
          });

          test('double quote multiline string', () {
            final lexer = Lexer(r'"""hello, $name!"""');
            final token = lexer.read();
            expect(token, isA<InterpolatedStringToken>());
            final string = token as InterpolatedStringToken;
            expect(string.isMultiline, isTrue);
            expect(string.isClosed, isTrue);
            expect(string.lexeme, r'"""hello, $name!"""');
            expect(string.value, r'hello, $name!');
            expect(string.spans, [
              ContentSpan('hello, '),
              InterpolationSpan(
                start: const Position(index: 11, line: 1, col: 11),
                id: 'name',
              ),
              ContentSpan('!')
            ]);
          });
        });

        group('newlines', () {
          test('single quote multiline string', () {
            final lexer = Lexer(r"'''hello, \nname!'''");
            final token = lexer.read();
            expect(token, isA<InterpolatedStringToken>());
            final string = token as InterpolatedStringToken;
            expect(string.isMultiline, isTrue);
            expect(string.isClosed, isTrue);
            expect(string.lexeme, r"'''hello, \nname!'''");
            expect(string.value, 'hello, \nname!');
            expect(string.spans, [
              ContentSpan('hello, \nname!'),
            ]);
          });
          test('double quote multiline string', () {
            final lexer = Lexer(r'"""hello, \nname!"""');
            final token = lexer.read();
            expect(token, isA<InterpolatedStringToken>());
            final string = token as InterpolatedStringToken;
            expect(string.isMultiline, isTrue);
            expect(string.isClosed, isTrue);
            expect(string.lexeme, r'"""hello, \nname!"""');
            expect(string.value, 'hello, \nname!');
            expect(string.spans, [
              ContentSpan('hello, \nname!'),
            ]);
          });
        });
      });

      group('complex interpolation', () {
        test('re-enters multiline string', () {
          final lexer = Lexer(r'"""hello, ${name}!"""');
          final token = lexer.read();
          expect(token, isA<InterpolatedStringToken>());
          final first = token as InterpolatedStringToken;
          expect(first.spans, [ContentSpan('hello, ')]);
          expect(first.isClosed, false);
          expect(first.value, 'hello, ');
          expect(first.lexeme, r'"""hello, ${');
          final id = lexer.read();
          expect(id, isA<IdToken>());
          expect(id.lexeme, 'name');
          final last = lexer.read();
          expect(last, isA<InterpolatedStringToken>());
          final lastToken = last as InterpolatedStringToken;
          expect(lastToken.isClosed, true);
          expect(lastToken.value, '!');
          expect(lastToken.lexeme, '}!"""');
        });

        test('nested interpolation', () {
          final lexer = Lexer(r'"""hello, ${"${name}"}!"""');
          final token = lexer.read();
          expect(token, isA<InterpolatedStringToken>());
          final first = token as InterpolatedStringToken;
          expect(first.spans, [ContentSpan('hello, ')]);
          expect(first.isClosed, false);
          expect(first.value, 'hello, ');
          expect(first.lexeme, r'"""hello, ${');
          final second = lexer.read();
          expect(second, isA<InterpolatedStringToken>());
          final secondToken = second as InterpolatedStringToken;
          expect(secondToken.value, '');
          expect(secondToken.lexeme, r'"${');
          expect(secondToken.isClosed, false);
          final id = lexer.read();
          expect(id, isA<IdToken>());
          expect(id.lexeme, 'name');
          final third = lexer.read();
          expect(third, isA<InterpolatedStringToken>());
          final thirdToken = third as InterpolatedStringToken;
          expect(thirdToken.isClosed, true);
          expect(thirdToken.value, '');
          expect(thirdToken.lexeme, '}"');
          final last = lexer.read();
          expect(last, isA<InterpolatedStringToken>());
          final lastToken = last as InterpolatedStringToken;
          expect(lastToken.isClosed, true);
          expect(lastToken.value, '!');
          expect(lastToken.lexeme, '}!"""');
        });
      });
    });

    group('braces', () {
      group('open brace', () {
        test('reads opening braces', () {
          checkTokens(['{', '{'], TokenType.braceOpen);
        });

        test('reads closing braces', () {
          final lexer = Lexer('{}}');
          final open = lexer.read();
          expect(open, isA<BraceOpenToken>());
          final closeMatch = lexer.read();
          expect(closeMatch, isA<BraceCloseToken>());
          final closeUnmatched = lexer.read();
          expect(closeUnmatched, isA<BraceCloseToken>());
        });
      });
    });

    test('other operators', () {
      checkTokens(['#'], symbol);
      checkTokens(['+'], plus);
      checkTokens(['++'], increment);
      checkTokens(['+='], assignmentAddition);
      checkTokens(['-'], minus);
      checkTokens(['--'], decrement);
      checkTokens(['-='], assignmentSubtraction);
      checkTokens(['!'], bang);
      checkTokens(['!='], inequality);
      checkTokens(['?'], question);
      checkTokens(['??'], ifNull);
      checkTokens(['??='], assignmentIfNull);
      checkTokens(['?.'], memberAccessNullAware);
      checkTokens(['?..'], cascadeNullAware);
      checkTokens(['.'], memberAccess);
      checkTokens(['..'], cascade);
      checkTokens(['...'], spread);
      checkTokens(['...?'], spreadNullAware);
      checkTokens(['*'], multiplication);
      checkTokens(['*='], assignmentMultiplication);
      checkTokens(['%'], remainder);
      checkTokens(['%='], assignmentRemainder);
      checkTokens(['~'], bitwiseComplement);
      checkTokens(['~/'], integerDivision);
      checkTokens(['~/='], assignmentIntegerDivision);
      checkTokens(['>'], greaterThan);
      checkTokens(['>>'], shiftRight);
      checkTokens(['>>>'], shiftRightUnsigned);
      checkTokens(['>>='], assignmentShiftRight);
      checkTokens(['>>>='], assignmentShiftRightUnsigned);
      checkTokens(['>='], greaterThanOrEqual);
      checkTokens(['<'], lessThan);
      checkTokens(['<<'], shiftLeft);
      checkTokens(['<<='], assignmentShiftLeft);
      checkTokens(['<='], lessThanOrEqual);
      checkTokens(['&'], bitwiseAnd);
      checkTokens(['&='], assignmentBitwiseAnd);
      checkTokens(['&&'], logicalAnd);
      checkTokens(['|'], bitwiseOr);
      checkTokens(['|='], assignmentBitwiseOr);
      checkTokens(['||'], logicalOr);
      checkTokens(['^'], bitwiseXor);
      checkTokens(['^='], assignmentBitwiseXor);
      checkTokens(['='], assignment);
      checkTokens(['=='], equality);
      checkTokens([','], comma);
      checkTokens([':'], colon);
      checkTokens([';'], semicolon);
      checkTokens(['('], parenOpen);
      checkTokens([')'], parenClose);
      checkTokens(['['], bracketOpen);
      checkTokens([']'], bracketClose);
    });
  });
}
