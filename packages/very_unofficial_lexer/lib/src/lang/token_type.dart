/// Token type.
enum TokenType {
  /// Error token.
  error,

  /// End of file token.
  eof,

  /// New line token.
  line,

  /// Whitespace token.
  whitespace,

  /// Operator token.
  op,

  /// Single line comment token.
  comment,

  /// Single line doc comment token.
  commentDoc,

  /// Multi line comment token.
  commentMultiline,

  /// Multi line doc comment token.
  commentMultilineDoc,

  /// Identifier token.
  id,

  /// Numeric literal token.
  number,

  /// String literal token.
  /// There are many variations of string literal tokens to enable
  /// string interpolation.
  string,

  /// Boolean literal token.
  boolean,

  /// Opening brace (left brace).
  braceOpen,

  /// Closing brace (right brace).
  braceClose,

  /// Symbol character (`#`).
  symbol,

  /// Plus operator.
  plus,

  /// Minus operator.
  minus,

  /// Increment operator.
  increment,

  /// Decrement operator.
  decrement,

  /// Opening parenthesis (left parenthesis).
  parenOpen,

  /// Closing parenthesis (right parenthesis).
  parenClose,

  /// Opening square bracket (left square bracket).
  bracketOpen,

  /// Closing square bracket (right square bracket).
  bracketClose,

  /// Question mark (`?`).
  question,

  /// If-null operator (`??`).
  ifNull,

  /// Bang (exclamation mark, `!`).
  bang,

  /// Member access (`.`).
  memberAccess,

  /// Null-aware member access (`?.`).
  memberAccessNullAware,

  /// Comma (`,`).
  comma,

  /// Colon (`:`).
  colon,

  /// Semicolon (`;`).
  semicolon,

  /// Multiplication (`*`) operator.
  multiplication,

  /// Division (`/`) operator.
  division,

  /// Remainder/modulo (`%`) operator.
  remainder,

  /// Integer division (`~/`) operator.
  integerDivision,

  /// Left shift (`<<`) operator.
  shiftLeft,

  /// Right shift (`>>`) operator.
  shiftRight,

  /// Unsigned right shift (`>>>`) operator.
  shiftRightUnsigned,

  /// Bitwise complement/negation (`~`) operator.
  bitwiseComplement,

  /// Bitwise and (`&`) operator.
  bitwiseAnd,

  /// Bitwise xor (`^`) operator.
  bitwiseXor,

  /// Bitwise or (`|`) operator.
  bitwiseOr,

  /// Greater than (`>`) operator.
  greaterThan,

  /// Greater than or equal (`>=`) operator.
  greaterThanOrEqual,

  /// Less than (`<`) operator.
  lessThan,

  /// Less than or equal (`<=`) operator.
  lessThanOrEqual,

  /// As (`as`) operator.
  asOp,

  /// Is (`is`) operator.
  isOp,

  /// Is not (`is!`) operator.
  isNotOp,

  /// Equality (`==`) operator.
  equality,

  /// Inequality (`!=`) operator.
  inequality,

  /// Logical and (`&&`) operator.
  logicalAnd,

  /// Logical or (`||`) operator.
  logicalOr,

  /// Cascade (`..`) operator.
  cascade,

  /// Null-aware cascade (`?..`) operator.
  cascadeNullAware,

  /// Spread (`...`) operator.
  spread,

  /// Null-aware spread (`...?`) operator.
  spreadNullAware,

  /// Assignment (`=`) operator.
  assignment,

  /// Assignment (`*=`) operator.
  assignmentMultiplication,

  /// Assignment (`/=`) operator.
  assignmentDivision,

  /// Assignment (`~/=`) operator.
  assignmentIntegerDivision,

  /// Assignment (`%=`) operator.
  assignmentRemainder,

  /// Assignment (`+=`) operator.
  assignmentAddition,

  /// Assignment (`-=`) operator.
  assignmentSubtraction,

  /// Assignment (`<<=`) operator.
  assignmentShiftLeft,

  /// Assignment (`>>>=`) operator.
  assignmentShiftRightUnsigned,

  /// Assignment (`>>=`) operator.
  assignmentShiftRight,

  /// Assignment (`&=`) operator.
  assignmentBitwiseAnd,

  /// Assignment (`^=`) operator.
  assignmentBitwiseXor,

  /// Assignment (`|=`) operator.
  assignmentBitwiseOr,

  /// Assignment (`??=`) operator.
  assignmentIfNull,
}
