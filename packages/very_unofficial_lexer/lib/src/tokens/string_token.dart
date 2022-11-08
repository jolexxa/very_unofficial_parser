import 'package:equatable/equatable.dart';
import 'package:strings/strings.dart';
import 'package:very_unofficial_lexer/src/lang/lang.dart';
import 'package:very_unofficial_lexer/src/lexical/lexical.dart';
import 'package:very_unofficial_lexer/src/tokens/token.dart';

/// Represents a span of string content. There are two types of string spans:
/// [ContentSpan] and [InterpolationSpan].
abstract class StringSpan {
  /// String depicting the span.
  String toContent();
}

/// {@template string_content}
/// Normal string contents.
/// {@endtemplate}
class ContentSpan extends Equatable implements StringSpan {
  /// {@macro string_content}
  ContentSpan(this.content);

  /// String content.
  final String content;

  @override
  String toString() => content;

  @override
  String toContent() => toString();

  @override
  List<Object?> get props => [content];
}

/// {@template interpolation_span}
/// Represents a simple string interpolation inside a string literal.
/// Example: '$myVariable'
/// {@endtemplate}
class InterpolationSpan extends Equatable implements StringSpan {
  /// {@macro interpolation_span}
  InterpolationSpan({required this.start, required this.id});

  /// Start position of the identifier.
  final Position start;

  /// Identifier name (without the '$').
  final String id;

  /// End index of the identifier. Guaranteed to always be on the same line.
  int get end => start.index + id.length;

  @override
  List<Object?> get props => [start, id];

  @override
  String toString() => 'InterpolationSpan(start: ${start.toString()}, id: $id)';

  @override
  String toContent() => '\$$id';
}

/// String token.
class StringToken extends Token {
  /// Create a new [StringToken] with the specified properties.
  StringToken({
    required LexerState state,
    required this.value,
    required this.isClosed,
    required this.isRaw,
    required this.isMultiline,
  }) : super(
          type: TokenType.string,
          state: state,
        );

  /// Actual string represented by this string literal token,
  /// since the lexeme includes the quotes and escape sequences.
  final String value;

  /// True if this token represents a string literal which ends in quotes
  /// (even if it doesn't necessarily start with quotes).
  final bool isClosed;

  /// True if this token comprises an entire raw string literal.
  final bool isRaw;

  /// True if this token comprises a multiline string literal.
  final bool isMultiline;

  @override
  List<Object?> get props => [
        ...super.props,
        value,
        isClosed,
        isRaw,
        isMultiline,
      ];

  @override
  String toString() => '${type.toString().split('.').last}(`${escape(value)}`)';
}

/// {@template interpolated_string_token}
/// Interpolated string token, potentially composed of multiple spans
/// of text with simple interpretations in-between. Complex interpolations will
/// always produce multiple [InterpolatedStringToken]s with various tokens
/// representing the expression.
/// {@endtemplate}
class InterpolatedStringToken extends StringToken {
  /// {@macro InterpolatedStringToken}
  InterpolatedStringToken({
    required LexerState state,
    required bool isClosed,
    required bool isMultiline,
    required this.spans,
  }) : super(
          state: state,
          isClosed: isClosed,
          isRaw: false,
          isMultiline: isMultiline,
          value: spans.map((span) => span.toContent()).join(),
        );

  /// Spans comprising the contents of this string. There are two types of
  /// spans: [ContentSpan]s and [InterpolationSpan]s. A [ContentSpan] indicates
  /// a string literal value, while the [InterpolationSpan] indicates a simple
  /// string interpolation.
  final List<StringSpan> spans;

  @override
  List<Object?> get props => [...super.props, spans];
}
