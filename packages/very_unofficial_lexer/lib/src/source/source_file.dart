import 'package:equatable/equatable.dart';

/// A representation of a dart language source code file.
class SourceFile extends Equatable {
  /// Create a new source file representation for the file named [name] at
  /// [path]. Path should not contain trailing slashes. Name should include
  /// the file's extension, if any.
  const SourceFile({
    required this.name,
    required this.path,
  });

  /// Default source file for code that is not in a file.
  /// Useful primarily for testing.
  static const none = SourceFile(name: '', path: '.');

  /// File name to be shown in error messages. Include the file's extension,
  /// if one is present.
  final String name;

  /// File path. Must not contain trailing slashes.
  /// Means nothing to this library—use it as an organizational tool.
  final String path;

  @override
  String toString() => '$path/$name';

  @override
  List<Object?> get props => [name, path];
}
