enum Source {
  exampleValidator,
  profileValidator,
  resourceValidator,
  instanceValidator,
  template,
  schema,
  schematron,
  publisher,
  linkChecker,
  ontology,
  profileComparer,
  terminologyEngine,
  questionnaireResponseValidator,
  ipaValidator;

  @override
  String toString() => this.toString().split('.').last;
}
