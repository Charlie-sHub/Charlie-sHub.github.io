import 'package:charlie_shub_portfolio/presentation/core/theme/app_motion.dart';
import 'package:flutter/material.dart';

/// Wallpaper asset used by the home-page shell background.
const homeAppShellWallpaperAsset = 'assets/media/background_web.jpg';

/// Shared key for the sticky or inline home-page profile summary.
const homeProfileSummaryKey = ValueKey<String>('home-profile-summary');

/// Shared key for the main home-page content lane.
const homeMainContentKey = ValueKey<String>('home-main-content');

/// Initial reveal delay for the secondary home-page content stack.
final homeSubtleMotionDelay = Duration(
  milliseconds: AppMotion.durationFast.inMilliseconds ~/ 2,
);

/// Canonical anchor identifier for the about section.
const aboutSectionId = 'about';

/// Canonical anchor identifier for the projects section.
const projectsSectionId = 'projects';

/// Canonical anchor identifier for the certifications section.
const certificationsSectionId = 'certifications';

/// Canonical anchor identifier for the case studies section.
const caseStudiesSectionId = 'case-studies';

/// Canonical anchor identifier for the courses section.
const coursesSectionId = 'courses';

/// Canonical anchor identifier for the resume section.
const resumeSectionId = 'resume';
