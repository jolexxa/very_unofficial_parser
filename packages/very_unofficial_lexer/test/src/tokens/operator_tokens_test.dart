import 'package:test/test.dart';
import 'package:very_unofficial_lexer/src/lexical/lexical.dart';
import 'package:very_unofficial_lexer/src/tokens/operator_tokens.dart';

void main() {
  group('operator tokens', () {
    group('toString', () {
      test('describes tokens', toStringTests);
    });
  });
}

void toStringTests() {
  LexerState s(String lexeme) => LexerState(
      position: Position.zero, length: lexeme.length, lexeme: lexeme);
  expect(SymbolToken(state: s('#')).toString(), 'symbol(`#`)');
  expect(BraceOpenToken(state: s('{')).toString(), 'braceOpen(`{`)');
  expect(BraceCloseToken(state: s('}')).toString(), 'braceClose(`}`)');
  expect(PlusToken(state: s('+')).toString(), 'plus(`+`)');
  expect(IncrementToken(state: s('++')).toString(), 'increment(`++`)');
  expect(MinusToken(state: s('-')).toString(), 'minus(`-`)');
  expect(DecrementToken(state: s('--')).toString(), 'decrement(`--`)');
  expect(ParenOpenToken(state: s('(')).toString(), 'parenOpen(`(`)');
  expect(ParenCloseToken(state: s(')')).toString(), 'parenClose(`)`)');
  expect(BracketOpenToken(state: s('[')).toString(), 'bracketOpen(`[`)');
  expect(BracketCloseToken(state: s(']')).toString(), 'bracketClose(`]`)');
  expect(QuestionToken(state: s('?')).toString(), 'question(`?`)');
  expect(IfNullToken(state: s('??')).toString(), 'ifNull(`??`)');
  expect(BangToken(state: s('!')).toString(), 'bang(`!`)');
  expect(MemberAccessToken(state: s('.')).toString(), 'memberAccess(`.`)');
  expect(MemberAccessNullAwareToken(state: s('?.')).toString(),
      'memberAccessNullAware(`?.`)');
  expect(ColonToken(state: s(':')).toString(), 'colon(`:`)');
  expect(SemicolonToken(state: s(';')).toString(), 'semicolon(`;`)');
  expect(MultiplicationToken(state: s('*')).toString(), 'multiplication(`*`)');
  expect(DivisionToken(state: s('/')).toString(), 'division(`/`)');
  expect(RemainderToken(state: s('%')).toString(), 'remainder(`%`)');
  expect(
      IntegerDivisionToken(state: s('~/')).toString(), 'integerDivision(`~/`)');
  expect(ShiftLeftToken(state: s('<<')).toString(), 'shiftLeft(`<<`)');
  expect(ShiftRightToken(state: s('>>')).toString(), 'shiftRight(`>>`)');
  expect(ShiftRightUnsignedToken(state: s('>>>')).toString(),
      'shiftRightUnsigned(`>>>`)');
  expect(BitwiseComplementToken(state: s('~')).toString(),
      'bitwiseComplement(`~`)');
  expect(BitwiseAndToken(state: s('&')).toString(), 'bitwiseAnd(`&`)');
  expect(BitwiseXorToken(state: s('^')).toString(), 'bitwiseXor(`^`)');
  expect(BitwiseOrToken(state: s('|')).toString(), 'bitwiseOr(`|`)');
  expect(GreaterThanToken(state: s('>')).toString(), 'greaterThan(`>`)');
  expect(GreaterThanOrEqualToken(state: s('>=')).toString(),
      'greaterThanOrEqual(`>=`)');
  expect(LessThanToken(state: s('<')).toString(), 'lessThan(`<`)');
  expect(
      LessThanOrEqualToken(state: s('<=')).toString(), 'lessThanOrEqual(`<=`)');
  expect(AsToken(state: s('as')).toString(), 'asOp(`as`)');
  expect(IsToken(state: s('is')).toString(), 'isOp(`is`)');
  expect(IsNotToken(state: s('is!')).toString(), 'isNotOp(`is!`)');
  expect(EqualityToken(state: s('==')).toString(), 'equality(`==`)');
  expect(InequalityToken(state: s('!=')).toString(), 'inequality(`!=`)');
  expect(LogicalAndToken(state: s('&&')).toString(), 'logicalAnd(`&&`)');
  expect(LogicalOrToken(state: s('||')).toString(), 'logicalOr(`||`)');
  expect(CascadeToken(state: s('..')).toString(), 'cascade(`..`)');
  expect(CascadeNullAwareToken(state: s('?.')).toString(),
      'cascadeNullAware(`?.`)');
  expect(SpreadToken(state: s('...')).toString(), 'spread(`...`)');
  expect(SpreadNullAwareToken(state: s('...?')).toString(),
      'spreadNullAware(`...?`)');
  expect(AssignmentToken(state: s('=')).toString(), 'assignment(`=`)');
  expect(AssignmentMultiplicationToken(state: s('*=')).toString(),
      'assignmentMultiplication(`*=`)');
  expect(AssignmentDivisionToken(state: s('/=')).toString(),
      'assignmentDivision(`/=`)');
  expect(AssignmentIntegerDivisionToken(state: s('~/=')).toString(),
      'assignmentIntegerDivision(`~/=`)');
  expect(AssignmentRemainderToken(state: s('%=')).toString(),
      'assignmentRemainder(`%=`)');
  expect(AssignmentAdditionToken(state: s('+=')).toString(),
      'assignmentAddition(`+=`)');
  expect(AssignmentSubtractionToken(state: s('-=')).toString(),
      'assignmentSubtraction(`-=`)');
  expect(AssignmentShiftLeftToken(state: s('<<=')).toString(),
      'assignmentShiftLeft(`<<=`)');
  expect(AssignmentShiftRightUnsignedToken(state: s('>>>=')).toString(),
      'assignmentShiftRightUnsigned(`>>>=`)');
  expect(AssignmentShiftRightToken(state: s('>>=')).toString(),
      'assignmentShiftRight(`>>=`)');
  expect(AssignmentBitwiseAndToken(state: s('&=')).toString(),
      'assignmentBitwiseAnd(`&=`)');
  expect(AssignmentBitwiseXorToken(state: s('^=')).toString(),
      'assignmentBitwiseXor(`^=`)');
  expect(AssignmentBitwiseOrToken(state: s('|=')).toString(),
      'assignmentBitwiseOr(`|=`)');
  expect(
      AssignmentIfNull(state: s('??=')).toString(), 'assignmentIfNull(`??=`)');
}
