import 'dart:collection';

import 'package:very_unofficial_lexer/very_unofficial_lexer.dart';

/// Token predicate.
typedef Predicate<T> = bool Function(T);

/// {@template token_parser}
/// Basic parer which allows you to [peek], [advance], [consume] and [match].
///
/// This is pretty much a copy of the base implementation from Bob's parser
/// for Bantam mentioned in his article about Pratt Parsing. I ❤️ Bob.
/// {@endtemplate}
class TokenParser {
  /// {@macro token_parser}
  ///
  /// {@macro pratt_parser_help}
  ///
  /// Create a new token parser with a never-ending source of [tokens].
  TokenParser(this.tokens);

  /// A never ending source of tokens.
  final Iterator<Token> tokens;

  final List<Token> _tokenCache = [];

  /// Tokens that have been examined by the parser but not yet consumed.
  UnmodifiableListView<Token> get tokenCache =>
      UnmodifiableListView<Token>(_tokenCache);

  /// Peek at the next token without skipping or matching it.
  Token get peek => _look();

  /// Ensure the cache contains the specified number of tokens. Returns the
  /// token at [distance] from the current token.
  Token _look([int distance = 0]) {
    while (distance >= _tokenCache.length) {
      assert(tokens.moveNext(), 'unexpected end of input');
      _tokenCache.add(tokens.current);
    }
    return _tokenCache[distance];
  }

  /// Consume the next token if it matches the expected type [T] and optional
  /// predicate [when], or issue a semantic [error].
  ///
  /// Returns the successfully matched token.
  Token consume<T extends Token>({
    Predicate<Token>? when,
    required String error,
  }) {
    final token = peek;
    if (token is T) {
      if (when == null || when(token)) {
        _tokenCache.removeAt(0);
        return token;
      }
    }
    // TODO(definitelyokay): Make a synthetic token for better error tolerance.
    throw StateError(error);
  }

  /// Match the next token if it matches the expected type [T] and optional
  /// predicate [when]. Returns true if the token was matched, false otherwise.
  bool match<T extends Token>([Predicate<Token>? when]) {
    final token = peek;
    if (token is T) {
      if (when == null || when(token)) {
        _tokenCache.removeAt(0);
        return true;
      }
    }
    return false;
  }

  /// Advances to the next token and returns it.
  Token advance() {
    final token = peek;
    _tokenCache.removeAt(0);
    return token;
  }
}
