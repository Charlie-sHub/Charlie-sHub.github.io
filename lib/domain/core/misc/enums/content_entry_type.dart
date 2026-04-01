/// Closed set of content document types used by `meta.type` in content JSON.
enum ContentEntryType {
  /// About-me content entry.
  aboutMe('about_me'),

  /// Security case study entry.
  caseStudy('case_study'),

  /// Certification entry.
  certificate('certificate'),

  /// Course entry.
  course('course'),

  /// Project entry.
  project('project'),

  /// Resume entry.
  resume('resume'),
  ;

  const ContentEntryType(this.jsonValue);

  /// Serialized value used in repository content files.
  final String jsonValue;

  /// Parses a repository content type value.
  static ContentEntryType? fromString(String value) {
    for (final entryType in values) {
      if (entryType.jsonValue == value) {
        return entryType;
      }
    }

    return null;
  }
}
