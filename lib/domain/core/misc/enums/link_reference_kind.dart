/// Presentation-oriented semantic hints for external links in structured
/// content.
enum LinkReferenceKind {
  /// Neutral external resource with no stronger semantic treatment.
  external('external'),

  /// GitHub profile or repository link.
  github('github'),

  /// LinkedIn profile link.
  linkedin('linkedin'),

  /// Self-link back to the portfolio site.
  portfolio('portfolio'),

  /// Repository link that is not specifically GitHub-branded.
  repository('repository'),

  /// Documentation or written technical reference.
  documentation('documentation'),

  /// Credential or proof surface such as a badge page.
  credential('credential'),

  /// Resume or CV document link.
  resume('resume'),
  ;

  const LinkReferenceKind(this.jsonValue);

  /// Serialized value used in structured content files.
  final String jsonValue;

  /// Parses a raw content value into a supported link kind.
  static LinkReferenceKind fromString(String? value) {
    if (value == null) {
      return LinkReferenceKind.external;
    }

    for (final kind in values) {
      if (kind.jsonValue == value) {
        return kind;
      }
    }

    return LinkReferenceKind.external;
  }
}
