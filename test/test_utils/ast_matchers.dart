import 'package:test/test.dart';
import 'package:very_unofficial_lexer/very_unofficial_lexer.dart';
import 'package:very_unofficial_parser/very_unofficial_parser.dart';

import 'test_matchers.dart';

class PrefixExpressionMatcher extends NodeMatcher<PrefixExpression> {
  PrefixExpressionMatcher({this.operatorToken = anyToken, this.rhs = anyNode});

  final Matcher rhs;
  final Matcher operatorToken;

  @override
  bool match(PrefixExpression expression) {
    return rhs.match(expression.rhs) && operatorToken.match(operatorToken);
  }
}

class PostfixExpressionMatcher extends NodeMatcher<PostfixExpression> {
  PostfixExpressionMatcher({this.lhs = anyNode, this.operatorToken = anyToken});

  final Matcher lhs;
  final Matcher operatorToken;

  @override
  bool match(PostfixExpression expression) {
    return lhs.match(expression.lhs) && operatorToken.match(operatorToken);
  }
}

class BinaryExpressionMatcher extends NodeMatcher<BinaryExpression> {
  BinaryExpressionMatcher({
    this.lhs = anyNode,
    this.operatorToken = anyToken,
    this.rhs = anyNode,
    this.isRightAssociative = anyBool,
  });

  final Matcher lhs;
  final Matcher operatorToken;
  final Matcher rhs;
  final Matcher isRightAssociative;

  @override
  bool match(BinaryExpression expression) {
    return lhs.match(expression.lhs) &&
        operatorToken.match(expression.operatorToken) && // failing here?
        rhs.match(expression.rhs);
  }
}

class GroupExpressionMatcher extends NodeMatcher<GroupExpression> {
  GroupExpressionMatcher({
    this.openToken = const TypeMatcher<ParenOpenToken>(),
    this.expression = anyNode,
    this.closeToken = const TypeMatcher<ParenCloseToken>(),
  });

  final Matcher openToken;
  final Matcher expression;
  final Matcher closeToken;

  @override
  bool match(GroupExpression expression) {
    return this.expression.match(expression.expression) &&
        openToken.match(expression.openToken) &&
        closeToken.match(expression.closeToken);
  }
}

class ReferenceExpressionMatcher extends NodeMatcher<ReferenceExpression> {
  ReferenceExpressionMatcher({this.id = const TypeMatcher<IdToken>()});

  final Matcher id;

  @override
  bool match(ReferenceExpression expression) {
    return id.match(expression.identifier);
  }
}

class NumericLiteralExpressionMatcher
    extends NodeMatcher<NumericLiteralExpression> {
  NumericLiteralExpressionMatcher({
    this.numberToken = const TypeMatcher<NumberToken>(),
  });

  final Matcher numberToken;

  @override
  bool match(NumericLiteralExpression expression) {
    return numberToken.match(expression.numberToken);
  }
}

class StringLiteralExpressionMatcher
    extends NodeMatcher<StringLiteralExpression> {
  StringLiteralExpressionMatcher({
    this.stringToken = const TypeMatcher<StringToken>(),
  });

  final Matcher stringToken;

  @override
  bool match(StringLiteralExpression expression) {
    return stringToken.match(expression.stringToken);
  }
}

class BooleanLiteralExpressionMatcher
    extends NodeMatcher<BooleanLiteralExpression> {
  BooleanLiteralExpressionMatcher({
    this.booleanToken = const TypeMatcher<BooleanToken>(),
  });

  final Matcher booleanToken;

  @override
  bool match(BooleanLiteralExpression expression) {
    return booleanToken.match(expression.booleanToken);
  }
}

class TernaryConditionalExpressionMatcher
    extends NodeMatcher<TernaryConditionalExpression> {
  TernaryConditionalExpressionMatcher({
    this.predicate = anyNode,
    this.questionToken = const TypeMatcher<QuestionToken>(),
    this.consequent = anyNode,
    this.colonToken = const TypeMatcher<ColonToken>(),
    this.alternative = anyNode,
  });

  final Matcher predicate;
  final Matcher questionToken;
  final Matcher consequent;
  final Matcher colonToken;
  final Matcher alternative;

  @override
  bool match(TernaryConditionalExpression expression) {
    return predicate.match(expression.predicate) &&
        questionToken.match(expression.questionToken) &&
        consequent.match(expression.consequent) &&
        colonToken.match(expression.colonToken) &&
        alternative.match(expression.alternative);
  }
}
