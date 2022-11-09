import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:very_unofficial_lexer/very_unofficial_lexer.dart';
import 'package:very_unofficial_parser/src/parser/token_provider.dart';
import 'package:very_unofficial_parser/src/parser/trivia_table.dart';

import '../../test_utils/test_utils.dart';

class FakeLexer extends Fake implements Lexer {
  FakeLexer(this.tokens);

  final List<Token> tokens;

  @override
  Token read() {
    if (tokens.isEmpty) {
      return EofToken(position: Position.zero);
    }
    final token = tokens.removeAt(0);
    return token;
  }
}

class MockTriviaTable extends Mock implements TriviaTable {}

void main() {
  // When writing unit tests, the convention is to mock all dependencies of
  // the system under test.
  //
  // That means these tests should use a mock trivia table: however, the trivia
  // table is so simple (and has its own unit tests) that using mocks would
  // make these tests a lot more difficult.
  //
  // It's always good to know the rules before breaking them 😇

  group('TokenProvider', () {
    test('reads non-trivial tokens', () {
      final tokens = allTokens('a&&b');
      final lexer = FakeLexer([...tokens]);
      final table = TriviaTable();
      final tokenProvider = TokenProvider(lexer: lexer, triviaTable: table);

      final result = [...tokenProvider()];

      expect(result, equals(tokens));
      expect(table.numTriviaTokens, 0);
    });

    test('queues up trivia tokens', () {
      final tokens = allTokens('a + b');
      final lexer = FakeLexer([...tokens]);
      final table = TriviaTable();
      final tokenProvider = TokenProvider(lexer: lexer, triviaTable: table);

      final result = [...tokenProvider()];

      expect(result, equals([tokens[0], tokens[2], tokens[4]]));
      expect(table.getTrivia(tokens[2]), equals([tokens[1]]));
      expect(table.getTrivia(tokens[4]), equals([tokens[3]]));

      expect(tokens[0].trivia, isEmpty);
      expect(tokens[2].trivia, equals([tokens[1]]));
      expect(tokens[4].trivia, equals([tokens[3]]));
    });
  });
}
