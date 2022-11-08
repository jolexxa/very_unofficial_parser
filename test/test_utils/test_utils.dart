import 'package:test/test.dart';
import 'package:very_unofficial_lexer/very_unofficial_lexer.dart';

export 'ast_matchers.dart';
export 'test_matchers.dart';

/// Returns a real token read from the [source] with a [Lexer].
/// The [source] must not produce more than 1 token.
Token oneToken(String source) {
  final lexer = Lexer(source);
  final token = lexer.read();
  expect(lexer.read(), isA<EofToken>());
  return token;
}

/// Returns a never-ending iterable of tokens (ignoring whitespace tokens).
Iterable<Token> tokenize(String source) sync* {
  final lexer = Lexer(source);
  Token token;
  do {
    do {
      token = lexer.read();
    } while (token is WhitespaceToken);
    yield token;
  } while (token is! EofToken);
  while (true) {
    yield token;
  }
}

/// Returns a list of tokens (ignoring whitespace tokens).
List<Token> tokenList(String source) {
  final iterator = tokenize(source).iterator;
  final tokens = <Token>[];
  while (iterator.moveNext()) {
    final token = iterator.current;
    if (token is EofToken) {
      break;
    }
    tokens.add(token);
  }
  return tokens;
}
