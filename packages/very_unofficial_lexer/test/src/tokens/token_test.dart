import 'dart:core';

import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:very_unofficial_lexer/src/lang/lang.dart';
import 'package:very_unofficial_lexer/src/lexical/lexical.dart';
import 'package:very_unofficial_lexer/src/tokens/token.dart';

class TestToken extends Token {
  TestToken({required super.type, required super.state});
}

class MockTriviaToken extends Mock implements TriviaToken {}

void main() {
  group('Token', () {
    test('initializes', () {
      const type = TokenType.error;
      const state = LexerState(lexeme: 'a', length: 1, position: Position.zero);
      final token = TestToken(type: type, state: state);
      expect(token.type, type);
      expect(token.lexeme, state.lexeme);
      expect(token.length, state.length);
      expect(token.position, state.position);
      expect(() => token.setTrivia([MockTriviaToken()]), returnsNormally);
      // Shouldn't be able to call token.setTrivia more than once.
      expect(
        () => token.setTrivia([MockTriviaToken(), MockTriviaToken()]),
        throwsA(isA<Error>()),
      );
    });
  });
}
