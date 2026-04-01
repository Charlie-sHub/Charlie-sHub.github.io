/// Observed closed vocabulary for resume language proficiency values.
enum ResumeLanguageProficiency {
  /// Native speaker proficiency.
  native('Native'),

  /// CEFR C2 proficiency.
  c2('C2'),

  /// CEFR B1 proficiency.
  b1('B1'),
  ;

  const ResumeLanguageProficiency(this.jsonValue);

  /// Serialized value used in `assets/content/resume/resume.json`.
  final String jsonValue;

  /// Parses a resume language proficiency value.
  static ResumeLanguageProficiency? fromString(String value) {
    for (final proficiency in values) {
      if (proficiency.jsonValue == value) {
        return proficiency;
      }
    }

    return null;
  }
}
