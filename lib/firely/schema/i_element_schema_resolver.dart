/// An interface for objects that let you obtain an [ElementSchema] by its schema URI.
abstract class IElementSchemaResolver {
  /// Retrieve a schema by its schema URI.
  ///
  /// Returns null if the schema was not found.
  /// Throws [SchemaResolutionFailedException] when the schema was found, but could not be loaded or parsed.
  ElementSchema? getSchema(String schemaUri);
}

/// Placeholder class for ElementSchema.
class ElementSchema {
  // Implementation details would go here.
}

/// Custom exception for schema resolution failures.
class SchemaResolutionFailedException implements Exception {
  String message;

  SchemaResolutionFailedException(this.message);

  @override
  String toString() => 'SchemaResolutionFailedException: $message';
}
