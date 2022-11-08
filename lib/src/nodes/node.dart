import 'package:very_unofficial_parser/src/parser/visitor.dart';

/// An abstract syntax tree node. Provides a common base class for all nodes.
// ignore: one_member_abstracts
abstract class Node {
  /// Accepts a [visitor] by calling the method on the visitor that
  /// corresponds to the type of this node.
  void accept(Visitor visitor);
}
