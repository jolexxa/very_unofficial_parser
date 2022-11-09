import 'package:very_unofficial_lexer/very_unofficial_lexer.dart';
import 'package:very_unofficial_parser/src/parser/trivia_table.dart';

/// {@template token_provider}
/// Wraps the lexer and provides tokens. Queues up trivia tokens as they are
/// encountered and registers them with the trivia table once a non-trivial
/// token is found.
///
/// The trivia table contains a mapping of non-trivial tokens to the list of
/// trivia tokens that precede them.
///
/// For the sake of simplicity (and doc comments), trivia is always considered
/// to precede a token.
///
/// For more information, see this:
/// https://github.com/rust-lang/rust-analyzer/issues/6584
/// {@endtemplate}
class TokenProvider {
  /// {@macro token_provider}
  TokenProvider({required this.lexer, required this.triviaTable});

  /// Lexer used to generate tokens.
  final Lexer lexer;

  /// Trivia table containing a mapping of non-trivial tokens to the
  /// list of trivia tokens that precede them.
  final TriviaTable triviaTable;

  /// Iterable of non-trivial tokens.
  Iterable<Token> call() sync* {
    var token = lexer.read();
    var trivia = <TriviaToken>[];
    while (token is! EofToken) {
      if (token is TriviaToken) {
        trivia.add(token);
      } else {
        triviaTable.addTrivia(token, trivia);
        token.setTrivia(trivia);
        trivia = <TriviaToken>[];
        yield token;
      }
      token = lexer.read();
    }
  }
}
