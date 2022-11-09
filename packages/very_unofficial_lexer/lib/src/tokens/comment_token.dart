import 'package:very_unofficial_lexer/src/lang/lang.dart';
import 'package:very_unofficial_lexer/src/lexical/lexical.dart';
import 'package:very_unofficial_lexer/src/tokens/token.dart';

/// Identifier token.
class CommentToken extends Token implements TriviaToken {
  /// Create a new [CommentToken] with the specified properties.
  CommentToken({
    required LexerState state,
    this.isDocComment = false,
    this.isMultiline = false,
  }) : super(
          type: isDocComment
              ? isMultiline
                  ? TokenType.commentMultilineDoc
                  : TokenType.commentDoc
              : isMultiline
                  ? TokenType.commentMultiline
                  : TokenType.comment,
          state: state,
        );

  /// True if this is a doc comment.
  final bool isDocComment;

  /// True if this is a multiline comment.
  final bool isMultiline;

  @override
  List<Object?> get props => [...super.props, isDocComment, isMultiline];
}
