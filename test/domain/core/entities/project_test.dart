import 'package:charlie_shub_portfolio/domain/core/entities/project.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/project_link.dart';
import 'package:charlie_shub_portfolio/domain/core/misc/enums/content_entry_type.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/asset_path.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/non_empty_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/single_line_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/slug.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/title.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/url_value.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/year_month.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'Project',
    () {
      test(
        'is valid for a schema-aligned project shape',
        () {
          final project = Project(
            slug: Slug('pami'),
            sourcePath: SingleLineText('projects/pami/project_notes.md'),
            startDate: YearMonth('2024-12'),
            isOngoing: true,
            title: Title('PAMi'),
            summary: NonEmptyText('Location-aware exchange platform'),
            galleryImagePaths: <AssetPath>[
              AssetPath('assets/media/content/projects/pami/hero.png'),
            ],
            roleAndScope: NonEmptyText(
              'Engineering work itself is the main proof',
            ),
            productContext: NonEmptyText('Nearby exchange platform'),
            stack: <SingleLineText>[SingleLineText('Flutter and Dart')],
            implementation: NonEmptyText(
              'Layered architecture with shared core utilities',
            ),
            outcomes: <NonEmptyText>[
              NonEmptyText('Engineering quality is the portfolio proof'),
            ],
            links: <ProjectLink>[
              ProjectLink(
                label: SingleLineText('Demo'),
                url: UrlValue('https://example.com/demo'),
              ),
            ],
          );

          expect(project.isValid, isTrue);
          expect(project.contentEntryType, ContentEntryType.project);
        },
      );

      test(
        'is invalid when a required list is empty',
        () {
          final project = Project(
            slug: Slug('pami'),
            sourcePath: SingleLineText('projects/pami/project_notes.md'),
            startDate: YearMonth('2024-12'),
            isOngoing: true,
            title: Title('PAMi'),
            summary: NonEmptyText('Location-aware exchange platform'),
            roleAndScope: NonEmptyText(
              'Engineering work itself is the main proof',
            ),
            productContext: NonEmptyText('Nearby exchange platform'),
            stack: const <SingleLineText>[],
            implementation: NonEmptyText(
              'Layered architecture with shared core utilities',
            ),
            outcomes: <NonEmptyText>[
              NonEmptyText('Engineering quality is the portfolio proof'),
            ],
          );

          expect(project.isValid, isFalse);
          expect(project.failureOption.isSome(), isTrue);
        },
      );
    },
  );
}
