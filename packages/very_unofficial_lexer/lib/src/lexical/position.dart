import 'package:equatable/equatable.dart';

/// Represents a position inside of a source file.
class Position extends Equatable {
  /// Create a new position at the specified position [index] at [line]
  /// and [col].
  const Position({required this.index, required this.line, required this.col});

  /// Initial position for a source file.
  static const zero = Position(index: 0, line: 1, col: 0);

  /// Second character position in a source file.
  static const one = Position(index: 1, line: 1, col: 1);

  /// Absolute 0-based position in the source file.
  final int index;

  /// Line number in the source file.
  final int line;

  /// Column number for the current line in the source file.
  final int col;

  /// Returns a copy of the current position.
  Position copy() => Position(index: index, line: line, col: col);

  @override
  String toString() => 'Position(index: $index, line: $line, col: $col)';

  @override
  List<Object?> get props => [index, line, col];
}
