import 'package:charlie_shub_portfolio/domain/content/content_load_types.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/certification.dart';
import 'package:charlie_shub_portfolio/presentation/content/certifications/widgets/certification_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/app_failure_card.dart';
import 'package:flutter/material.dart';

/// Renders one certification entry while keeping item failures local.
class CertificationEntryDetail extends StatelessWidget {
  /// Creates a certification entry detail widget.
  const CertificationEntryDetail({
    required this.item,
    super.key,
  });

  /// The certification load item to render.
  final SectionItemLoad<Certification> item;

  @override
  Widget build(BuildContext context) => item.fold(
    (failure) => AppFailureCard(
      failure: failure,
      title: 'Certification entry unavailable',
    ),
    (certification) => CertificationCard(
      certification: certification,
    ),
  );
}
