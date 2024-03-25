class CanonicalTypeSorter implements Comparator<CanonicalType> {
  @override
  int compare(CanonicalType o1, CanonicalType o2) {
    return o1.getValue().compareTo(o2.getValue());
  }
}
