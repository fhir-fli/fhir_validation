/// Represents thread-safe, shareable state for a single run of the validator.
class ValidationState {
  final GlobalState _global = GlobalState();
  final InstanceState _instance = InstanceState();
  final LocationState _location = LocationState();

  /// State to be kept for one full run of the validator.
  GlobalState get global => _global;

  /// State to be kept while validating a single instance.
  InstanceState get instance => _instance;

  /// State to be kept while validating at the same location in the instance and definition.
  LocationState get location => _location;

  /// Create a state with a clean instance container.
  ValidationState newInstanceScope() {
    return ValidationState().._global.copyFrom(_global);
  }

  /// Update the location, returning a new state with the updated location.
  ValidationState updateLocation(Function(DefinitionPath) pathStackUpdate) {
    var newState = ValidationState()
      .._global.copyFrom(_global)
      .._instance.copyFrom(_instance);
    newState._location.definitionPath =
        pathStackUpdate(_location.definitionPath);
    return newState;
  }

  /// Update the instance location, returning a new state with the updated instance location.
  ValidationState updateInstanceLocation(
      Function(InstancePath) pathStackUpdate) {
    var newState = ValidationState()
      .._global.copyFrom(_global)
      .._instance.copyFrom(_instance);
    newState._location.instanceLocation =
        pathStackUpdate(_location.instanceLocation);
    return newState;
  }
}

/// Global state kept across validations.
class GlobalState {
  final ValidationLogger runValidations = ValidationLogger();
  int resourcesValidated = 0;
  FhirPathCompilerCache? fpCompilerCache;

  void copyFrom(GlobalState other) {
    runValidations.copyFrom(other.runValidations);
    resourcesValidated = other.resourcesValidated;
    fpCompilerCache = other.fpCompilerCache;
  }
}

/// State kept for an individual instance being validated.
class InstanceState {
  String? resourceUrl;

  void copyFrom(InstanceState other) {
    resourceUrl = other.resourceUrl;
  }
}

/// State kept at a specific location during validation.
class LocationState {
  DefinitionPath definitionPath = DefinitionPath.start();
  InstancePath instanceLocation = InstancePath.start();

  void copyFrom(LocationState other) {
    definitionPath = other.definitionPath;
    instanceLocation = other.instanceLocation;
  }
}

/// Represents a logger for validation runs.
class ValidationLogger {
  void log(String message) {
    // Implementation for logging validation details
  }

  void copyFrom(ValidationLogger other) {
    // Copy logging details if necessary
  }
}

/// Cache for compiled FHIRPath expressions.
class FhirPathCompilerCache {
  // Implement caching mechanism
}

/// Represents a path in a definition tree.
class DefinitionPath {
  static DefinitionPath start() => DefinitionPath();

  DefinitionPath update(Function(DefinitionPath) updater) => updater(this);
}

/// Represents a path in an instance tree.
class InstancePath {
  static InstancePath start() => InstancePath();

  InstancePath update(Function(InstancePath) updater) => updater(this);
}
