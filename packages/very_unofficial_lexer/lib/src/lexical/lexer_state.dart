import 'package:equatable/equatable.dart';
import 'package:very_unofficial_lexer/src/lexical/position.dart';

/// Lexer state representation.
class LexerState extends Equatable {
  /// Create a new LexerState with the specified [lexeme] of [length] at
  /// [position].
  const LexerState({
    required this.lexeme,
    required this.length,
    required this.position,
  });

  /// Current lexeme determined by lexer head and tail position.
  final String lexeme;

  /// Current length between the lexer's head and tail position.
  final int length;

  /// Current start position of the lexer's tail.
  final Position position;

  @override
  List<Object?> get props => [lexeme, length, position];
}
