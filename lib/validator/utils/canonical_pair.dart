class CanonicalPair {
  final String? url;
  final String? version;

  CanonicalPair(String? target)
      : url = target != null && target.contains("|")
            ? target.substring(0, target.indexOf("|"))
            : target,
        version = target != null && target.contains("|")
            ? target.substring(target.indexOf("|") + 1)
            : null;
}
