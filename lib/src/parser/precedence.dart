/// Operator precedence, from the least, [none], to the highest,
/// [unaryPostfix].
/// From page 241 of the Dart Language Specification v2.10.
enum Precedence {
  /// Only used as the default precedence value to accept.
  /// Just an implementation detail for Pratt Parsing.
  none,

  /// Assignment `=, *=, /=, +=, -=, &=, ˆ=, ??=, etc.` operators.
  assignment,

  /// Cascade `..` operator.
  cascade,

  /// Conditional `? :` operator.
  conditional,

  /// If-null `??` operator.
  ifNull,

  /// Logical `||` operator.
  logicalOr,

  /// Logical `&&` operator.
  logicalAnd,

  /// Equality `==` and inequality `!=` operators.
  equality,

  /// Relational `<, >, <=, >=, as, is, is!` operators.
  relational,

  /// Bitwise `|` operator.
  bitwiseOr,

  /// Bitwise `^` operator.
  bitwiseXor,

  /// Bitwise `&` operator.
  bitwiseAnd,

  /// Bitwise shift `<<, >>, >>>` operators.
  shift,

  /// Additive `+` and `-` operators.
  additive,

  /// Multiplicative `*, /, ~/, %` operators.
  multiplicative,

  /// Unary prefix `-e, !e, ~e, ++e, --e, await e` operators.
  unaryPrefix,

  /// Unary postfix `e., e?., e++, e--, e1[e2], e()` operators.
  unaryPostfix,
}

/// Allows Precedence to be manipulated for parsing convenience.
extension PrecedenceExtensions on Precedence {
  /// Subtract an integer from the precedence.
  Precedence operator -(int other) => Precedence.values[index - other];

  /// Less than operator for precedence.
  bool operator <(Precedence other) => index < other.index;
}

/// Operator associativity.
enum Associativity {
  /// Left-associative, such as `a + b + c`.
  left,

  /// Right-associative, such as `a ? b : c`.
  right,

  /// No associativity, such as `a is b`.
  none,
}

/// Operator associativity, defined by the Dart language specification.
const operatorAssociativity = <Precedence, Associativity>{
  Precedence.assignment: Associativity.right,
  Precedence.cascade: Associativity.left,
  Precedence.conditional: Associativity.right,
  Precedence.ifNull: Associativity.left,
  Precedence.logicalOr: Associativity.left,
  Precedence.logicalAnd: Associativity.left,
  Precedence.equality: Associativity.none,
  Precedence.relational: Associativity.none,
  Precedence.bitwiseOr: Associativity.left,
  Precedence.bitwiseXor: Associativity.left,
  Precedence.bitwiseAnd: Associativity.left,
  Precedence.shift: Associativity.left,
  Precedence.additive: Associativity.left,
  Precedence.multiplicative: Associativity.left,
  Precedence.unaryPrefix: Associativity.none,
  Precedence.unaryPostfix: Associativity.none,
};
