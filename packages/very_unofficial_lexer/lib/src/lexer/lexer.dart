import 'package:meta/meta.dart';
import 'package:string_unescape/string_unescape.dart';
import 'package:very_unofficial_lexer/src/lang/lang.dart';
import 'package:very_unofficial_lexer/src/lexical/lexical.dart';
import 'package:very_unofficial_lexer/src/source/source.dart';
import 'package:very_unofficial_lexer/src/tokens/tokens.dart';

/// Type of brace encountered. This is used to keep track of the last
/// encountered opening brace so that string interpolation can be properly
/// resolved. See https://bit.ly/3VBX9hD.
///
/// Dart uses an "auxiliary string interpolation state stack" to keep track of
/// opening braces and their associated string interpolation context. By storing
/// the quote information associated with an opening brace, the lexer can
/// recognize when to close the current string literal despite possibly being
/// inside another string literal. See page 100 of the spec.
enum BraceType {
  /// Curly brace typically used in scope blocks (i.e., not related to string
  /// interpolation).
  normal,

  /// Curly brace represented with interpolation opening `'...${`
  singleQuote,

  /// Curly brace represented with interpolation opening `"...${`
  doubleQuote,

  /// Curly brace represented with interpolation opening `'''...${`
  singleQuoteMultiline,

  /// Curly brace represented with interpolation opening `"""...${`
  doubleQuoteMultiline,
}

/// Convenience extensions for [BraceType].
extension BraceTypeExtensions on BraceType {
  /// The quote character for the string literal associated with the brace.
  /// Throws on [BraceType.normal].
  String get quote {
    switch (this) {
      case BraceType.singleQuote:
      case BraceType.singleQuoteMultiline:
        return "'";
      case BraceType.doubleQuote:
      case BraceType.doubleQuoteMultiline:
        return '"';
      default:
        throw StateError('No quote type associated with $this brace type');
    }
  }

  /// True if the string literal associated with the brace is multi-line.
  /// Throws on [BraceType.normal].
  bool get isMultiline {
    switch (this) {
      case BraceType.singleQuoteMultiline:
      case BraceType.doubleQuoteMultiline:
        return true;
      case BraceType.normal:
        throw StateError('Brace type $this is not associated with a string.');
      default:
        return false;
    }
  }
}

/// Lexical scanner for the Dart language.
///
/// Given a file with the following contents, the lexer moves a head and
/// tail object through the contents like so:
///
/// some file <TAIL>contents<HEAD> here
///
/// Where <HEAD> is always in front of or equal to <TAIL>.
///
/// Inspired by the language specification, but not guaranteed to be perfectly
/// correct.
class Lexer {
  /// Create a new [Lexer] for the specified source code [sourceFile].
  Lexer(this.contents, {this.sourceFile = SourceFile.none});

  Position _head = Position.zero;
  Position _tail = Position.zero;
  int _numTokens = 0;
  int _line = 1;
  String _lastChar = '';

  /// The index of the last newline character which incremented the
  /// logical line count.
  int _lastLine = 0;
  Token? _eofToken;

  // String interpolation state stack. A stack of encountered opening braces and
  // whether or not they are part of a string interpolation. See [BraceType].
  final List<BraceType> _braceLevels = [];

  /// Returns true if the most recently encountered opening brace is the given
  /// type of opening brace.
  bool currentBraceLevel(BraceType type) =>
      _braceLevels.isNotEmpty && _braceLevels.last == type;

  BraceType get _braceType => _braceLevels.last;
  bool get _hasBraces => _braceLevels.isNotEmpty;

  void _enterBrace(BraceType type) => _braceLevels.add(type);

  void _exitBrace() {
    if (_braceLevels.isEmpty) return;
    _braceLevels.removeLast();
  }

  /// Source code file to be scanned.
  final SourceFile sourceFile;

  /// String contents to be scanned.
  final String contents;

  /// Head position (start of current token).
  Position get head => _head;

  /// Tail position (end of current token).
  Position get tail => _tail;

  /// The end of file token (if the lexer has reached the end of the file,
  /// otherwise null).
  Token? get eofToken => _eofToken;

  /// Number of tokens read.
  int get numTokens => _numTokens;

  /// Length of the current "value" of the lexer, as measured between the
  /// lexer's start position and the current position.
  int get length => _head.index - _tail.index;

  /// True if the lexer has reached the end of the source file.
  bool get isAtEnd => _head.index >= contents.length;

  /// True if the lexer has not reached the end of the source file.
  /// Note that `peek` is guaranteed to return a character if [ok] is true.
  bool get ok => _head.index < contents.length;

  /// Look-ahead character or null if there are no more characters.
  String? get peek => isAtEnd ? null : contents[_head.index];

  /// Current "value" of the lexer, as measured between the lexer's start
  /// position and the current position.
  String get lexeme => contents.substring(_tail.index, _head.index);

  /// Current lexer state.
  LexerState get state => LexerState(
        lexeme: lexeme,
        length: length,
        position: _tail.copy(),
      );

  /// Scans the source file for the next token.
  Token read() {
    final token = _scan();
    _tail = _head.copy();
    if (token.type == TokenType.line) {
      _lastLine = _tail.index;
      _line++;
    }
    return token;
  }

  /// Returns the current character and advances the lexer position.
  @visibleForTesting
  String advance() {
    if (isAtEnd) throw StateError('Cannot advance past end of file');
    final next = contents[_head.index];
    final nextIndex = _head.index + 1;
    _head = Position(
      index: nextIndex,
      line: _line,
      col: nextIndex - _lastLine,
    );
    _lastChar = next;
    return next;
  }

  /// Advances the lexer position if the next character matches the [expected]
  /// character.
  bool match(String expected) =>
      (isAtEnd || peek != expected) ? false : advance() != '';

  /// Create an error token for the current position with the specified [hint].
  ErrorToken error(String hint) {
    final token = ErrorToken(state: state, hint: hint);
    return token;
  }

  /// The method that actually does the work for reading the next token.
  Token _scan() {
    if (isAtEnd) {
      if (_eofToken == null) {
        _eofToken = EofToken(position: _tail);
        _numTokens++;
      }
      return _eofToken!;
    }

    _numTokens++;

    final char = advance();

    if (isWhitespace(char)) {
      return _whitespace();
    } else if (char == '0' && peek == 'x' || peek == 'X') {
      return _hexNumber();
    } else if (isDigit(char)) {
      return _number(isDecimal: false);
    } else if (char == '.' && ok && isDigit(peek!)) {
      return _number(isDecimal: true);
    } else if (char == '\n') {
      return LineToken(state: state);
    } else if (char == '\r') {
      return _carriageReturn();
    } else if (char == '/') {
      return _forwardSlash();
    } else if (char == 'r' && (peek == "'" || peek == '"')) {
      return _rawString(quote: peek!);
    } else if (char == "'" || char == '"') {
      return _string(quote: char, isReturning: false);
    } else if (char == '#') {
      return SymbolToken(state: state);
    } else if (char == '+') {
      return _plus();
    } else if (char == '-') {
      return _minus();
    } else if (char == '*') {
      return _star();
    } else if (char == '%') {
      return _percent();
    } else if (char == '~') {
      return _tilde();
    } else if (char == '<') {
      return _lessThan();
    } else if (char == '>') {
      return _greaterThan();
    } else if (char == '&') {
      return _ampersand();
    } else if (char == '|') {
      return _pipe();
    } else if (char == '^') {
      return _caret();
    } else if (char == '=') {
      return _equals();
    } else if (char == '(') {
      return ParenOpenToken(state: state);
    } else if (char == ')') {
      return ParenCloseToken(state: state);
    } else if (char == '[') {
      return BracketOpenToken(state: state);
    } else if (char == ']') {
      return BracketCloseToken(state: state);
    } else if (char == '?') {
      return _question();
    } else if (char == '!') {
      return _bang();
    } else if (char == '.') {
      return _dot();
    } else if (char == ',') {
      return CommaToken(state: state);
    } else if (char == ':') {
      return ColonToken(state: state);
    } else if (char == ';') {
      return SemicolonToken(state: state);
    } else if (char == '{') {
      return _braceOpen();
    } else if (char == '}') {
      return _braceClose();
    } else if (isIdentifierStart(char)) {
      return _identifier();
    }

    return error('syntax error');
  }

  Token _equals() {
    if (match('=')) {
      return EqualityToken(state: state);
    }
    return AssignmentToken(state: state);
  }

  Token _pipe() {
    if (match('|')) {
      return LogicalOrToken(state: state);
    } else if (match('=')) {
      return AssignmentBitwiseOrToken(state: state);
    }
    return BitwiseOrToken(state: state);
  }

  Token _caret() {
    if (match('=')) {
      return AssignmentBitwiseXorToken(state: state);
    }
    return BitwiseXorToken(state: state);
  }

  Token _ampersand() {
    if (match('&')) {
      return LogicalAndToken(state: state);
    } else if (match('=')) {
      return AssignmentBitwiseAndToken(state: state);
    } else {
      return BitwiseAndToken(state: state);
    }
  }

  Token _lessThan() {
    if (match('<')) {
      if (match('=')) {
        return AssignmentShiftLeftToken(state: state);
      }
      return ShiftLeftToken(state: state);
    } else if (match('=')) {
      return LessThanOrEqualToken(state: state);
    }
    return LessThanToken(state: state);
  }

  Token _greaterThan() {
    if (match('>')) {
      if (match('>')) {
        if (match('=')) {
          return AssignmentShiftRightUnsignedToken(state: state);
        }
        return ShiftRightUnsignedToken(state: state);
      } else if (match('=')) {
        return AssignmentShiftRightToken(state: state);
      }
      return ShiftRightToken(state: state);
    } else if (match('=')) {
      return GreaterThanOrEqualToken(state: state);
    }
    return GreaterThanToken(state: state);
  }

  Token _tilde() {
    if (match('/')) {
      if (match('=')) {
        return AssignmentIntegerDivisionToken(state: state);
      }
      return IntegerDivisionToken(state: state);
    }
    return BitwiseComplementToken(state: state);
  }

  Token _percent() {
    if (match('=')) {
      return AssignmentRemainderToken(state: state);
    }
    return RemainderToken(state: state);
  }

  Token _star() {
    if (match('=')) {
      return AssignmentMultiplicationToken(state: state);
    }
    return MultiplicationToken(state: state);
  }

  Token _carriageReturn() {
    match('\n');
    return LineToken(state: state);
  }

  Token _braceOpen() {
    _enterBrace(BraceType.normal);
    return BraceOpenToken(state: state);
  }

  Token _braceClose() {
    final isNormal = currentBraceLevel(BraceType.normal);
    if (!_hasBraces || isNormal) {
      // normal closing brace token
      if (isNormal) {
        _exitBrace();
      }
      return BraceCloseToken(state: state);
    } else {
      // closing brace token associated with string interpolation.
      // reached the end of a complex string interpolation, return to whatever
      // string we were inside of.
      final quote = _braceType.quote;
      return _string(
        quote: quote,
        isReturning: true,
      );
    }
  }

  Token _dot() {
    if (match('.')) {
      if (match('.')) {
        if (match('?')) {
          return SpreadNullAwareToken(state: state);
        }
        return SpreadToken(state: state);
      }
      return CascadeToken(state: state);
    }
    return MemberAccessToken(state: state);
  }

  Token _question() {
    if (match('?')) {
      if (match('=')) {
        return AssignmentIfNull(state: state);
      }
      return IfNullToken(state: state);
    } else if (match('.')) {
      if (match('.')) {
        return CascadeNullAwareToken(state: state);
      }
      return MemberAccessNullAwareToken(state: state);
    }
    return QuestionToken(state: state);
  }

  Token _bang() {
    if (match('=')) {
      return InequalityToken(state: state);
    }
    return BangToken(state: state);
  }

  Token _plus() {
    if (match('+')) {
      return IncrementToken(state: state);
    } else if (match('=')) {
      return AssignmentAdditionToken(state: state);
    }
    return PlusToken(state: state);
  }

  Token _minus() {
    if (match('-')) {
      return DecrementToken(state: state);
    } else if (match('=')) {
      return AssignmentSubtractionToken(state: state);
    }
    return MinusToken(state: state);
  }

  Token _whitespace() {
    while (ok && isWhitespace(peek!)) {
      advance();
    }
    return WhitespaceToken(state: state);
  }

  Token _singleLineComment({bool isDocComment = false}) {
    while (ok && peek != '\n' && peek != '\r') {
      advance();
    }
    return CommentToken(state: state, isDocComment: isDocComment);
  }

  Token _multiLineComment({bool isDocComment = false}) {
    var indent = 1;
    while (ok) {
      if (match('*')) {
        if (match('/')) {
          if (--indent == 0) {
            return CommentToken(
              state: state,
              isDocComment: isDocComment,
              isMultiline: true,
            );
          }
        }
      } else if (match('/')) {
        if (match('*')) indent++;
      } else {
        advance();
      }
    }
    return error('unterminated comment');
  }

  Token _identifier() {
    while (ok && isIdentifierPart(peek!)) {
      advance();
    }
    switch (lexeme) {
      // operators:
      case 'as':
        return AsToken(state: state);
      case 'is':
        if (match('!')) {
          return IsNotToken(state: state);
        }
        return IsToken(state: state);
      case 'true':
      case 'false':
        return BooleanToken(state: state);
    }
    return IdToken(state: state);
  }

  Token _number({required bool isDecimal}) {
    ErrorToken noDecimalDigitsErr() => error(
          'numeric literals must have at least one '
          'digit following the decimal point',
        );
    ErrorToken noExponentDigitsErr() => error(
          'numeric literals must have at least one '
          'digit following the exponent sign',
        );
    while (ok && isDigit(peek!)) {
      advance();
    }
    if (ok && !isDecimal && match('.')) {
      if (isAtEnd || !isDigit(peek!)) return noDecimalDigitsErr();
      while (ok && isDigit(peek!)) {
        advance();
      }
    }
    if (ok && (match('e') || match('E'))) {
      match('+') || match('-');
      if (isAtEnd || !isDigit(peek!)) return noExponentDigitsErr();
      while (ok && isDigit(peek!)) {
        advance();
      }
    }
    return NumberToken(state: state, base: NumericLiteral.decimal);
  }

  Token _hexNumber() {
    match('x') || match('X');
    do {
      if (isAtEnd || !isHexDigit(peek!)) {
        return error(
          'hexadecimal literals must have at least one digit',
        );
      }
      advance();
    } while (ok && isHexDigit(peek!));
    return NumberToken(state: state, base: NumericLiteral.hexadecimal);
  }

  Token _forwardSlash() {
    if (match('/')) {
      final isDocComment = match('/');
      return _singleLineComment(isDocComment: isDocComment);
    } else if (match('*')) {
      var isDocComment = false;
      if (match('*')) {
        if (match('/')) {
          return CommentToken(
            state: state,
            isMultiline: true,
          );
        }
        isDocComment = peek != '/';
      }
      return _multiLineComment(isDocComment: isDocComment);
    } else if (match('=')) {
      return AssignmentDivisionToken(state: state);
    }
    return DivisionToken(state: state);
  }

  Token _rawString({required String quote}) {
    // eat opening quote
    advance();
    var isMultiline = false;
    var finished = false;

    if (peek == quote) {
      // second quote—either empty string or multiline string start
      advance();
      if (peek == quote) {
        // multiline string
        advance();
        isMultiline = true;
      } else {
        // empty string
        return StringToken(
          state: state,
          value: '',
          isClosed: true,
          isRaw: true,
          isMultiline: false,
        );
      }
    }

    while (ok) {
      if (isMultiline) {
        if (match(quote) && match(quote) && match(quote)) {
          // closing triple quote
          finished = true;
          break;
        } else {
          // gobble up raw multiline string
          advance();
        }
      } else {
        // single line string
        if (peek != '\n' && peek != '\r' && peek != quote) {
          // gobble up raw single line string
          advance();
        } else if (match(quote)) {
          // closing quote
          finished = true;
          break;
        } else {
          // break out if we hit a new line
          break;
        }
      }
    }

    if (!finished) {
      // String was not closed—ran out of characters
      return error('unterminated string literal');
    }

    final numQuotes = isMultiline ? 3 : 1;
    final value = lexeme.substring(numQuotes + 1, lexeme.length - numQuotes);

    return StringToken(
      state: state,
      value: value,
      isClosed: true,
      isRaw: true,
      isMultiline: isMultiline,
    );
  }

  /// Consumes a string literal component, breaking at the required
  /// interpolation boundaries.
  /// Quote should either be ' or ", depending on the type of the string.
  /// Whether or not the string is multiline is inferred inside this method.
  /// If [isReturning], we are re-entering the string denoted by the top of
  /// the string interpolation state stack.
  Token _string({required String quote, required bool isReturning}) {
    final otherQuote = quote == "'" ? '"' : "'";
    var isMultiline = isReturning ? _braceType.isMultiline : false;

    final spans = <StringSpan>[];
    final value = StringBuffer();

    if (peek == quote && !isReturning) {
      // second quote—either empty string or multiline string start
      advance();
      if (peek == quote) {
        // multiline string
        advance();
        isMultiline = true;
      } else {
        // empty string
        return InterpolatedStringToken(
          state: state,
          spans: spans,
          isClosed: true,
          isMultiline: false,
        );
      }
    }

    final quoteType = isMultiline
        ? (quote == "'"
            ? BraceType.singleQuoteMultiline
            : BraceType.doubleQuoteMultiline)
        : (quote == "'" ? BraceType.singleQuote : BraceType.doubleQuote);

    bool canGobble() {
      return ok &&
              (isMultiline
                  ? isCommonMultilineStringContent(peek!)
                  : isCommonStringContent(peek!)) ||
          peek == otherQuote;
    }

    void addValueIfNeeded() {
      if (value.isNotEmpty) {
        spans.add(ContentSpan(value.toString()));
        value.clear();
      }
    }

    InterpolatedStringToken getToken({bool isClosed = true}) {
      addValueIfNeeded();
      return InterpolatedStringToken(
        state: state,
        isClosed: isClosed,
        isMultiline: isMultiline,
        spans: spans,
      );
    }

    while (ok) {
      // single quote, single line string
      if (match(r'\')) {
        // escape sequence
        if (!_escapeSequence(quote: quote, value: value)) {
          return error('missing escape sequence inside string');
        }
      } else if (match(quote)) {
        // closing quote detected
        //
        // When the string is closed, we pop it from the interpolation stack
        // (if we were inside a complex interpolation).
        if (isMultiline && match(quote)) {
          if (match(quote)) {
            // closing triple quote — end multiline string
            if (isReturning) {
              _exitBrace();
            }
            return getToken();
          } else {
            // Two quotes inside a multiline string are just fine.
            value.write(quote + quote);
            continue;
          }
        }
        // closing single quote — end single line string
        if (isReturning) {
          _exitBrace();
        }
        return getToken();
      } else if (match(r'$')) {
        // interpolation
        if (match('{')) {
          // complex interpolation
          //
          // Add the current quote type to the string interpolation stack
          // (if we're not already inside a string) so we can look for the
          // end of the string after we're done getting expression tokens.
          if (!isReturning) _enterBrace(quoteType);
          return getToken(isClosed: false);
        } else {
          // simple interpolation
          if (ok && isIdentifierStartNoDollar(peek!)) {
            addValueIfNeeded();
            final id = StringBuffer();
            final idStartPos = _head;
            id.write(advance());
            while (ok && isIdentifierPartNoDollar(peek!)) {
              id.write(advance());
            }
            spans.add(InterpolationSpan(start: idStartPos, id: id.toString()));
          } else {
            return error('invalid identifier for interpolation');
          }
        }
      } else {
        // normal string content
        if (!canGobble()) break;
        do {
          value.write(advance());
        } while (canGobble());
      }
    }

    return error('unterminated string');
  }

  bool _escapeSequence({required String quote, required StringBuffer value}) {
    // See page 102 of the spec
    if (!ok) return false;
    // Simple escape sequences
    if (match('n') || // newline
            match('r') || // carriage return
            match('f') || // form feed
            match('b') || // backspace
            match('t') || // horizontal tab
            match('v') // vertical tab
        ) {
      value.write(unescape('\\$_lastChar'));
      return true;
    } else if (match('x')) {
      var hex = '';
      if (!ok || !isHexDigit(peek!)) return false;
      hex += advance();
      if (!ok || !isHexDigit(peek!)) return false;
      hex += advance();
      value.write(unescape(r'\x' + hex));
      return true;
    } else if (match('u')) {
      if (match('{')) {
        // match at least one hex digit, up to 6 (inclusive)
        var hex = '';
        if (!ok || !isHexDigit(peek!)) return false;
        hex += advance();
        for (var i = 0; i < 5; i++) {
          if (ok && isHexDigit(peek!)) {
            hex += advance();
          } else {
            break;
          }
        }
        if (!ok || !match('}')) return false;
        value.write(unescape('\\u{$hex}'));
        return true;
      } else {
        // match 4 hex digits
        var hex = '';
        if (!ok || !isHexDigit(peek!)) return false;
        hex += advance();
        if (!ok || !isHexDigit(peek!)) return false;
        hex += advance();
        if (!ok || !isHexDigit(peek!)) return false;
        hex += advance();
        if (!ok || !isHexDigit(peek!)) return false;
        hex += advance();
        value.write(unescape(r'\u' + hex));
        return true;
      }
    } else if (match(quote)) {
      value.write(quote);
      return true;
    } else if (peek == '\n' || peek == '\r') {
      // Can't have a newline here.
      return false;
    } else {
      // Not technically an escape sequence if we didn't match one of the above,
      // but because strings allow arbitrary characters, an unrecognized escape
      // is still valid string content.
      value.write(advance());
      return true;
    }
  }
}
