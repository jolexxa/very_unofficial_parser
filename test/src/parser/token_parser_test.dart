import 'package:test/test.dart';
import 'package:very_unofficial_lexer/very_unofficial_lexer.dart';
import 'package:very_unofficial_parser/src/parser/parser.dart';

import '../../test_utils/test_utils.dart';

void main() {
  group('TokenParser', () {
    group('peeking, caching, and advancing', () {
      test('peeks the next token and advance returns it', () {
        final tokens = tokenize('a b');
        final parser = TokenParser(tokens.iterator);
        expect(
          parser.peek,
          isA<IdToken>().having((t) => t.lexeme, 'lexeme', 'a'),
        );
        expect(parser.tokenCache, hasLength(1));
        final a = parser.advance();
        expect(parser.tokenCache, hasLength(0));
        expect(
          a,
          isA<IdToken>().having((t) => t.lexeme, 'lexeme', 'a'),
        );
        expect(
          parser.peek,
          isA<IdToken>().having((t) => t.lexeme, 'lexeme', 'b'),
        );
        expect(parser.tokenCache, hasLength(1));
        final b = parser.advance();
        expect(parser.tokenCache, hasLength(0));
        expect(
          b,
          isA<IdToken>().having((t) => t.lexeme, 'lexeme', 'b'),
        );
      });
    });

    group('consume', () {
      test('consumes matching token without predicate', () {
        final tokens = tokenize('a');
        final parser = TokenParser(tokens.iterator);
        final a = parser.consume<IdToken>(error: 'expected an id');
        expect(
          a,
          isA<IdToken>().having((t) => t.lexeme, 'lexeme', 'a'),
        );
      });

      test('consumes matching token with a predicate', () {
        final tokens = tokenize('a');
        final parser = TokenParser(tokens.iterator);
        final a = parser.consume<IdToken>(
          when: (t) => t.lexeme == 'a',
          error: 'expected an id matching `a`',
        );
        expect(
          a,
          isA<IdToken>().having((t) => t.lexeme, 'lexeme', 'a'),
        );
      });

      test('throws error if token does not match', () {
        final tokens = tokenize('a');
        final parser = TokenParser(tokens.iterator);
        const message = 'expected a number';
        expect(
          () => parser.consume<NumberToken>(error: message),
          throwsA(
            isA<StateError>().having((e) => e.message, 'message', message),
          ),
        );
      });
    });

    group('match', () {
      test('matches a token without a predicate', () {
        final tokens = tokenize('a');
        final parser = TokenParser(tokens.iterator);
        expect(parser.match<IdToken>(), isTrue);
        expect(parser.tokenCache, hasLength(0));
      });

      test('matches a token with a predicate', () {
        final tokens = tokenize('a');
        final parser = TokenParser(tokens.iterator);
        expect(parser.match<IdToken>((t) => t.lexeme == 'a'), isTrue);
        expect(parser.tokenCache, hasLength(0));
      });

      test('does not match a token', () {
        final tokens = tokenize('a');
        final parser = TokenParser(tokens.iterator);
        expect(parser.match<NumberToken>(), isFalse);
        expect(parser.tokenCache, hasLength(1));
      });
    });
  });
}
