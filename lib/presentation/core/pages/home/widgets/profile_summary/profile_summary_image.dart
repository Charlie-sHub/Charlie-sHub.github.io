import 'package:charlie_shub_portfolio/domain/core/validation/objects/asset_path.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_layout.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/field_failure_widget.dart';
import 'package:flutter/material.dart';

const _profileSummaryImageKey = ValueKey<String>('profile-summary-image');

/// Profile image shown inside the compact home-page profile summary.
class ProfileSummaryImage extends StatelessWidget {
  /// Creates the profile-summary image widget.
  const ProfileSummaryImage({
    required this.path,
    super.key,
  });

  /// Validated asset path for the rendered profile image.
  final AssetPath path;

  @override
  Widget build(BuildContext context) => path.value.fold(
    (failure) => SizedBox.square(
      key: _profileSummaryImageKey,
      dimension: AppLayout.homeProfileSummaryImageSize,
      child: FieldFailureWidget(
        failure: failure,
      ),
    ),
    (value) => SizedBox.square(
      key: _profileSummaryImageKey,
      dimension: AppLayout.homeProfileSummaryImageSize,
      child: Image.asset(
        value,
        fit: BoxFit.cover,
      ),
    ),
  );
}
