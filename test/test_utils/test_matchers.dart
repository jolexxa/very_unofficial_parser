import 'package:test/test.dart';
import 'package:very_unofficial_lexer/very_unofficial_lexer.dart';
import 'package:very_unofficial_parser/very_unofficial_parser.dart';

// These utility classes allow AST trees to be verified more easily.
// Sadly, one has to be created for each AST node and maintained by hand.
// If you have a better idea for how to do this, please file an issue.

const anyNode = TypeMatcher<Node>();
const anyToken = TypeMatcher<Token>();
const anyBool = TypeMatcher<bool>();

extension Match on Matcher {
  /// Matches the expected [item] according to the matcher's rules.
  bool match(dynamic item) => this.matches(item, {});
}

abstract class NodeMatcher<T extends Node> extends TypeMatcher<T> {
  bool match(T node);

  @override
  Description describe(Description description) =>
      description.add(runtimeType.toString());

  @override
  bool matches(dynamic item, Map<dynamic, dynamic> matchState) =>
      item is T && match(item);

  @override
  Description describeMismatch(
    dynamic item,
    Description mismatchDescription,
    Map<dynamic, dynamic> matchState,
    bool verbose,
  ) {
    if (item is! T) {
      return mismatchDescription.add('is not a ${T.runtimeType}');
    }
    return mismatchDescription.add('does not match');
  }
}

class TokenMatcher<T extends Token> extends TypeMatcher<T> {
  const TokenMatcher(this.lexemeMatcher);

  final Object lexemeMatcher;

  @override
  Description describe(Description description) =>
      description.add('Token with lexeme: ').addDescriptionOf(lexemeMatcher);

  @override
  bool matches(dynamic item, Map<dynamic, dynamic> matchState) =>
      item is T &&
      (lexemeMatcher is Matcher
          ? (lexemeMatcher as Matcher).match(item.lexeme)
          : item.lexeme == (lexemeMatcher as String));
}
