import 'package:equatable/equatable.dart';
import 'package:strings/strings.dart';
import 'package:very_unofficial_lexer/src/lang/lang.dart';
import 'package:very_unofficial_lexer/src/lexical/lexical.dart';

/// Represents a lexical token. Use a subclass to create a specific
/// type of token.
abstract class Token extends Equatable {
  /// Create a new [Token] with the specified [type] and lexer [state].
  Token({required this.type, required LexerState state})
      : position = state.position,
        length = state.length,
        lexeme = state.lexeme;

  /// Type of the token.
  final TokenType type;

  /// 0-based position of the token in the source.
  final Position position;

  /// End position of the token in the source.
  int get end => position.index + length;

  /// Length of the token in the source.
  final int length;

  /// Raw text representation of the token, such as a symbol or identifier.
  final String lexeme;

  @override
  List<Object?> get props => [type, position, length, lexeme];

  @override
  String toString() =>
      '${type.toString().split('.').last}(`${escape(lexeme)}`)';

  /// Trivia tokens that precede this token. Don't access this before it's been
  /// set with [setTrivia].
  late final List<TriviaToken> trivia;

  /// Sets the trivia tokens that precede this token. This can only be called
  /// once.
  void setTrivia(List<TriviaToken> trivia) {
    this.trivia = List.unmodifiable(trivia);
  }
}

/// Interface for trivial tokens.
abstract class TriviaToken implements Token {}
