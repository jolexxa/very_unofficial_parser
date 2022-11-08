import 'package:very_unofficial_lexer/very_unofficial_lexer.dart';

/// {@template trivia_table}
/// Stores trivia tokens that precede a token.
///
/// Any whitespace, comments, or other trivia tokens that are encountered while
/// reading from a token source are stored in the [TriviaTable] and popped when
/// the next non-trivial token is read.
///
/// This parser preserves trivial tokens to ensure the AST can be printed back
/// out exactly as it was parsed.
/// {@endtemplate}
class TriviaTable {
  /// {@macro trivia_table}
  TriviaTable();

  final Map<Token, List<Token>> _trivia = {};

  /// Add a [trivialToken] to the list of trivia for [token].
  void addTrivia(Token token, List<Token> trivialToken) {
    final trivia = (_trivia[token] ?? [])..addAll(trivialToken);
    _trivia[token] = trivia;
  }

  /// Get the trivia tokens associated with [token], if any.
  List<Token> getTrivia(Token token) => _trivia[token] ?? const [];
}
