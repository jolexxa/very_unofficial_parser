import 'package:test/test.dart';
import 'package:very_unofficial_lexer/src/lexical/position.dart';

void main() {
  const posA = Position.zero;
  // ignore: prefer_const_constructors
  final posAClone = Position(index: 0, line: 1, col: 0);
  const posB = Position.one;

  test('equatable', () {
    expect(posA == posAClone, isTrue);
    expect(posA == posB, isFalse);
  });

  test('copy()', () {
    expect(posA == posA.copy(), isTrue);
    expect(posA.line == posA.copy().line, isTrue);
    expect(posA.col == posA.copy().col, isTrue);
  });

  test('toString', () {
    expect(posA.toString(), 'Position(index: 0, line: 1, col: 0)');
  });
}
