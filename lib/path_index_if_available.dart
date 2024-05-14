int? pathIndexIfAvailable(String path) {
  /// We check this non-list to ensure that it's not actually a list
  /// that we've broken down by indexand ensure that it ends in an index
  final lastOpenBracket = path.lastIndexOf('[') + 1;
  final lastClosedBracket = path.lastIndexOf(']');
  return lastOpenBracket == 0 ||
          lastClosedBracket == -1 ||
          lastClosedBracket != path.length - 1
      ? null
      : int.tryParse(path.substring(lastOpenBracket, lastClosedBracket));
}
