import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:very_unofficial_lexer/very_unofficial_lexer.dart';
import 'package:very_unofficial_parser/src/parser/trivia_table.dart';

class MockToken extends Mock implements Token {}

class MockTriviaToken extends Mock implements TriviaToken {}

void main() {
  group('TriviaTable', () {
    test('adds and retrieves trivia', () {
      final table = TriviaTable();
      final token = MockToken();
      final trivia1 = [MockTriviaToken()];
      final trivia2 = [MockTriviaToken()];

      expect(table.numTriviaTokens, 0);

      table
        ..addTrivia(token, trivia1)
        ..addTrivia(token, trivia2);
      expect(table.getTrivia(token), [...trivia1, ...trivia2]);

      expect(table.numTriviaTokens, 2);
    });
  });
}
