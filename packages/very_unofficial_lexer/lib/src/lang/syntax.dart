/// Set of digits, per the Dart language specification.
const digits = <String>{'0', '1', '2', '3', '4', '5', '6', '7', '8', '9'};

/// True if the specified character is a digit character.
bool isDigit(String char) => digits.contains(char);

/// Set of letters, per the Dart language specification.
const letters = <String>{
  'a',
  'b',
  'c',
  'd',
  'e',
  'f',
  'g',
  'h',
  'i',
  'j',
  'k',
  'l',
  'm',
  'n',
  'o',
  'p',
  'q',
  'r',
  's',
  't',
  'u',
  'v',
  'w',
  'x',
  'y',
  'z',
  'A',
  'B',
  'C',
  'D',
  'E',
  'F',
  'G',
  'H',
  'I',
  'J',
  'K',
  'L',
  'M',
  'N',
  'O',
  'P',
  'Q',
  'R',
  'S',
  'T',
  'U',
  'V',
  'W',
  'X',
  'Y',
  'Z',
};

/// True if the specified character is a letter.
bool isLetter(String char) => letters.contains(char);

/// Set of whitespace characters (without line ending characters).
const whitespace = <String>{
  '\t',
  ' ',
};

/// True if the specified character is a whitespace character.
bool isWhitespace(String char) => whitespace.contains(char);

/// Built in identifiers from the Dart language specification.
const builtInIdentifiers = <String>{
  'abstract',
  'as',
  'covariant',
  'deferred',
  'dynamic',
  'export',
  'external',
  'extension',
  'factory',
  'Function',
  'get',
  'implements',
  'import',
  'interface',
  'late',
  'library',
  'mixin',
  'operator',
  'part',
  'required',
  'set',
  'static',
  'typedef',
};

/// True if the specified string is a built-in identifier.
bool isBuiltInIdentifier(String lexeme) => builtInIdentifiers.contains(lexeme);

/// Reserved words from the Dart language specification.
const reservedWords = <String>{
  'assert',
  'break',
  'case',
  'catch',
  'class',
  'const',
  'continue',
  'default',
  'do',
  'else',
  'enum',
  'extends',
  'false',
  'final',
  'finally',
  'for',
  'if',
  'in',
  'is',
  'new',
  'null',
  'rethrow',
  'return',
  'super',
  'switch',
  'this',
  'throw',
  'true',
  'try',
  'var',
  'void',
  'while',
  'with',
};

/// True if the specified string is a built-in identifier.
bool isReservedWord(String lexeme) => reservedWords.contains(lexeme);

/// Boolean literals, all two of them.
const boolLiterals = <String>{'true', 'false'};

/// True if the specified string is a boolean literal.
bool isBoolLiteral(String lexeme) => boolLiterals.contains(lexeme);

/// True if [char] is a valid start of an identifier.
bool isIdentifierStart(String char) =>
    char == r'$' || isLetter(char) || char == '_';

/// True if [char] is a valid start of an identifier, excluding the dollar sign.
bool isIdentifierStartNoDollar(String char) => isLetter(char) || char == '_';

/// True if [char] is a valid part of an identifier, including the dollar sign.
bool isIdentifierPart(String char) => isIdentifierStart(char) || isDigit(char);

/// True if [char] is a valid part of an identifier, excluding the dollar sign.
bool isIdentifierPartNoDollar(String char) =>
    isIdentifierStartNoDollar(char) || isDigit(char);

/// True if [char] is a valid piece of string content.
bool isCommonStringContent(String char) =>
    char != r'\' &&
    char != "'" &&
    char != '"' &&
    char != r'$' &&
    char != '\r' &&
    char != '\n';

/// True if [char] is a valid piece of multiline string content.
/// Same as [isCommonStringContent], but allows newlines.
bool isCommonMultilineStringContent(String char) =>
    isCommonStringContent(char) || char == '\r' || char == '\n';

/// Valid hexadecimal digits.
const hexLetters = <String>{
  'a',
  'b',
  'c',
  'd',
  'e',
  'f',
  'A',
  'B',
  'C',
  'D',
  'E',
  'F',
  '0',
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
};

/// True if the specified character is a hexadecimal digit.
bool isHexDigit(String char) => hexLetters.contains(char);
