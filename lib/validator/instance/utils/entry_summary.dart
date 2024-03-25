class EntrySummary {

    Element entry;
    Element resource;
    List<EntrySummary> targets = new ArrayList<>();
    private int index;






   EntrySummary(int i, Element entry, Element resource) {
      this.index = i;
      this.entry = entry;
      this.resource = resource;
    }

    String dbg() {
      return ""+index+"="+ entry.getChildValue("fullUrl")+" | "+resource.getIdBase() + "("+resource.fhirType()+")";
    }

   String getIndex() {
      return Integer.toString(index);
    }
}