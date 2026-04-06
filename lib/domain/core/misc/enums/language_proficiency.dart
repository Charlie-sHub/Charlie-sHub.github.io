/// Resume language proficiency values plus an invalid fallback sentinel.
enum LanguageProficiency {
  /// Unknown or unsupported proficiency value from raw content.
  invalid('invalid'),

  /// Native speaker proficiency.
  native('Native'),

  /// CEFR A1 proficiency.
  a1('A1'),

  /// CEFR A2 proficiency.
  a2('A2'),

  /// CEFR B1 proficiency.
  b1('B1'),

  /// CEFR B2 proficiency.
  b2('B2'),

  /// CEFR C1 proficiency.
  c1('C1'),

  /// CEFR C2 proficiency.
  c2('C2'),
  ;

  const LanguageProficiency(this.jsonValue);

  /// Serialized value used in `assets/content/resume/resume.json`.
  final String jsonValue;

  /// Whether this proficiency is part of the supported public vocabulary.
  bool get isValid => this != LanguageProficiency.invalid;

  /// Supported serialized values for validated resume content.
  static List<String> get supportedJsonValues => values
      .where((proficiency) => proficiency.isValid)
      .map((proficiency) => proficiency.jsonValue)
      .toList(growable: false);

  /// Parses a resume language proficiency value from raw content.
  static LanguageProficiency fromString(String value) {
    for (final proficiency in values) {
      if (proficiency.jsonValue == value) {
        return proficiency;
      }
    }

    return LanguageProficiency.invalid;
  }
}
