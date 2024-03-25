// Enum definition
enum ConceptMapEquivalence {
  equivalent,
  equal,
  wider,
  subsumes,
  narrower,
  specializes,
  inexact,
  unmatched,
  disjoint,
  nullValue; // Dart does not allow 'NULL' as an identifier, using 'nullValue' instead
}

// Extension to add methods to the enum
extension ConceptMapEquivalenceExtension on ConceptMapEquivalence {
  String get code {
    switch (this) {
      case ConceptMapEquivalence.equivalent:
        return "equivalent";
      case ConceptMapEquivalence.equal:
        return "equal";
      case ConceptMapEquivalence.wider:
        return "wider";
      case ConceptMapEquivalence.subsumes:
        return "subsumes";
      case ConceptMapEquivalence.narrower:
        return "narrower";
      case ConceptMapEquivalence.specializes:
        return "specializes";
      case ConceptMapEquivalence.inexact:
        return "inexact";
      case ConceptMapEquivalence.unmatched:
        return "unmatched";
      case ConceptMapEquivalence.disjoint:
        return "disjoint";
      case ConceptMapEquivalence.nullValue:
        return "null";
      default:
        return "?";
    }
  }

  String get system {
    return "http://hl7.org/fhir/concept-map-equivalence";
  }

  String get definition {
    switch (this) {
      case ConceptMapEquivalence.equivalent:
        return "The definitions of the concepts mean the same thing (including when structural implications of meaning are considered) (i.e. extensionally identical).";
      case ConceptMapEquivalence.equal:
        return "The definitions of the concepts are exactly the same (i.e. only grammatical differences) and structural implications of meaning are identical or irrelevant (i.e. intentionally identical).";
      case ConceptMapEquivalence.wider:
        return "The target mapping is wider in meaning than the source concept.";
      case ConceptMapEquivalence.subsumes:
        return "The target mapping subsumes the meaning of the source concept (e.g. the source is-a target).";
      case ConceptMapEquivalence.narrower:
        return "The target mapping is narrower in meaning that the source concept. The sense in which the mapping is narrower SHALL be described in the comments in this case, and applications should be careful when attempting to use these mappings operationally.";
      case ConceptMapEquivalence.specializes:
        return "The target mapping specializes the meaning of the source concept (e.g. the target is-a source).";
      case ConceptMapEquivalence.inexact:
        return "The target mapping overlaps with the source concept, but both source and target cover additional meaning, or the definitions are imprecise and it is uncertain whether they have the same boundaries to their meaning. The sense in which the mapping is narrower SHALL be described in the comments in this case, and applications should be careful when attempting to use these mappings operationally.";
      case ConceptMapEquivalence.unmatched:
        return "There is no match for this concept in the destination concept system.";
      case ConceptMapEquivalence.disjoint:
        return "This is an explicit assertion that there is no mapping between the source and target concept.";
      case ConceptMapEquivalence.nullValue:
        return "null";
      default:
        return "?";
    }
  }

  String get display {
    switch (this) {
      case ConceptMapEquivalence.equivalent:
        return "Equivalent";
      case ConceptMapEquivalence.equal:
        return "Equal";
      case ConceptMapEquivalence.wider:
        return "Wider";
      case ConceptMapEquivalence.subsumes:
        return "Subsumes";
      case ConceptMapEquivalence.narrower:
        return "Narrower";
      case ConceptMapEquivalence.specializes:
        return "Specializes";
      case ConceptMapEquivalence.inexact:
        return "Inexact";
      case ConceptMapEquivalence.unmatched:
        return "Unmatched";
      case ConceptMapEquivalence.disjoint:
        return "Disjoint";
      case ConceptMapEquivalence.nullValue:
        return "null";
      default:
        return "?";
    }
  }

  // Dart does not support static methods in extensions, so fromCode must be implemented elsewhere or differently
}

// Factory class to mimic Java's EnumFactory functionality
// Note: Dart does not directly support this pattern. The factory could be adapted into a function or a class with a method to handle the conversion.
ConceptMapEquivalence? conceptMapEquivalenceFromCode(String? codeString) {
  if (codeString == null || codeString.isEmpty) {
    return null;
  }
  switch (codeString) {
    case "equivalent":
      return ConceptMapEquivalence.equivalent;
    case "equal":
      return ConceptMapEquivalence.equal;
    case "wider":
      return ConceptMapEquivalence.wider;
    case "subsumes":
      return ConceptMapEquivalence.subsumes;
    case "narrower":
      return ConceptMapEquivalence.narrower;
    case "specializes":
      return ConceptMapEquivalence.specializes;
    case "inexact":
      return ConceptMapEquivalence.inexact;
    case "unmatched":
      return ConceptMapEquivalence.unmatched;
    case "disjoint":
      return ConceptMapEquivalence.disjoint;
    default:
      throw ArgumentError("Unknown ConceptMapEquivalence code '$codeString'");
  }
}
