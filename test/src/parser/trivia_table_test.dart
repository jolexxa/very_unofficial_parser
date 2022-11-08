import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:very_unofficial_lexer/very_unofficial_lexer.dart';
import 'package:very_unofficial_parser/src/parser/trivia_table.dart';

class MockToken extends Mock implements Token {}

void main() {
  group('TriviaTable', () {
    test('adds and retrieves trivia', () {
      final table = TriviaTable();
      final token = MockToken();
      final trivia1 = [MockToken()];
      final trivia2 = [MockToken()];
      table
        ..addTrivia(token, trivia1)
        ..addTrivia(token, trivia2);
      expect(table.getTrivia(token), [...trivia1, ...trivia2]);
    });
  });
}
