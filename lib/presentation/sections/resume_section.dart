import 'package:charlie_shub_portfolio/application/content/content_cubit.dart';
import 'package:charlie_shub_portfolio/application/content/content_state.dart';
import 'package:charlie_shub_portfolio/application/content/content_status.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/entity_validation.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/resume.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/resume_education_item.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/resume_experience_item.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/resume_language_item.dart';
import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/content/external_link_list.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/content/labeled_tag_group_card.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/content/metadata_row.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/content/validated_bullet_list.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/content/validated_placeholder.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/content/validated_text.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/core/content_block.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/core/content_card.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/core/section_container.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/core/text_widgets.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/feedback/app_failure_card.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/feedback/field_failure_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Renders the resume section from loaded structured content.
class ResumeSection extends StatelessWidget {
  /// Creates a resume section.
  const ResumeSection({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<ContentCubit, ContentState>(
    builder: (context, state) => SectionContainer(
      heading: const SectionHeadingText(
        text: 'Resume',
      ),
      children: _buildSectionChildren(state),
    ),
  );

  List<Widget> _buildSectionChildren(ContentState state) =>
      state.resumeOption.fold(
        () => <Widget>[
          SupportingText(
            text: state.status == ContentStatus.failure
                ? 'Resume content could not be requested because content '
                      'loading was interrupted.'
                : 'Loading resume content...',
          ),
        ],
        (sectionLoad) => sectionLoad.fold(
          (failure) => <Widget>[
            AppFailureCard(
              failure: failure,
              title: 'Resume section unavailable',
            ),
          ],
          (resume) => <Widget>[
            _ResumeOverviewCard(resume: resume),
            const SizedBox(height: 16),
            ContentBlock(
              title: 'Core skills',
              spacing: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildSkillGroups(resume),
              ),
            ),
            const SizedBox(height: 16),
            ContentBlock(
              title: 'Professional experience',
              spacing: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildExperienceItems(resume),
              ),
            ),
            const SizedBox(height: 16),
            ContentBlock(
              title: 'Education',
              spacing: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildEducationItems(resume),
              ),
            ),
            const SizedBox(height: 16),
            ContentBlock(
              title: 'Languages',
              spacing: 12,
              child: _ResumeLanguagesCard(languages: resume.languages),
            ),
          ],
        ),
      );

  List<Widget> _buildSkillGroups(Resume resume) {
    final collectionFailure = collectionFailureOrNull(
      resume.coreSkills,
      minLength: 1,
    );

    if (collectionFailure != null) {
      return <Widget>[
        FieldFailureWidget(
          failure: collectionFailure,
        ),
      ];
    }

    final widgets = <Widget>[];

    for (var index = 0; index < resume.coreSkills.length; index++) {
      final group = resume.coreSkills[index];
      widgets.add(
        LabeledTagGroupCard(
          label: group.label,
          items: group.items,
          collectionFailure: collectionFailureOrNull(
            group.items,
            minLength: 1,
          ),
        ),
      );

      if (index < resume.coreSkills.length - 1) {
        widgets.add(const SizedBox(height: 12));
      }
    }

    return widgets;
  }

  List<Widget> _buildExperienceItems(Resume resume) {
    final collectionFailure = collectionFailureOrNull(
      resume.professionalExperience,
      minLength: 1,
    );

    if (collectionFailure != null) {
      return <Widget>[
        FieldFailureWidget(
          failure: collectionFailure,
        ),
      ];
    }

    final widgets = <Widget>[];

    for (var index = 0; index < resume.professionalExperience.length; index++) {
      widgets.add(
        _ResumeExperienceCard(
          item: resume.professionalExperience[index],
        ),
      );

      if (index < resume.professionalExperience.length - 1) {
        widgets.add(const SizedBox(height: 12));
      }
    }

    return widgets;
  }

  List<Widget> _buildEducationItems(Resume resume) {
    final collectionFailure = collectionFailureOrNull(
      resume.education,
      minLength: 1,
    );

    if (collectionFailure != null) {
      return <Widget>[
        FieldFailureWidget(
          failure: collectionFailure,
        ),
      ];
    }

    final widgets = <Widget>[];

    for (var index = 0; index < resume.education.length; index++) {
      widgets.add(
        _ResumeEducationCard(
          item: resume.education[index],
        ),
      );

      if (index < resume.education.length - 1) {
        widgets.add(const SizedBox(height: 12));
      }
    }

    return widgets;
  }
}

class _ResumeOverviewCard extends StatelessWidget {
  const _ResumeOverviewCard({
    required this.resume,
  });

  final Resume resume;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ContentCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ValidatedText(
            field: resume.name,
            style: textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          ValidatedText(
            field: resume.location,
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          ValidatedText(
            field: resume.summary,
            style: textTheme.bodyLarge,
          ),
          if (resume.resumePdfPath != null) ...[
            const SizedBox(height: 16),
            ValidatedPlaceholder(
              path: resume.resumePdfPath!,
              labelBuilder: _buildResumeLabel,
              height: 140,
              icon: Icons.description_outlined,
            ),
          ],
          const SizedBox(height: 16),
          ContentBlock(
            title: 'Contact links',
            child: ExternalLinkList(
              links: resume.contactLinks,
              collectionFailure: collectionFailureOrNull(
                resume.contactLinks,
                minLength: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _buildResumeLabel(String value) =>
      'Resume document available: ${value.split('/').last}';
}

class _ResumeExperienceCard extends StatelessWidget {
  const _ResumeExperienceCard({
    required this.item,
  });

  final ResumeExperienceItem item;

  @override
  Widget build(BuildContext context) {
    final timelineFailure = ongoingTimelineFailureOrNull(
      startDate: item.startDate,
      endDate: item.endDate,
      isOngoing: item.isOngoing,
    );

    return ContentCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ValidatedText(
            field: item.title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          if (item.organization != null) ...[
            const SizedBox(height: 8),
            ValidatedText(
              field: item.organization!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
          const SizedBox(height: 12),
          MetadataRow(
            items: [
              MetadataItemData(
                label: 'Location',
                value: item.location,
              ),
              MetadataItemData(
                label: 'Started',
                value: item.startDate,
              ),
              if (item.endDate != null)
                MetadataItemData(
                  label: 'Ended',
                  value: item.endDate!,
                ),
            ],
          ),
          if (item.isOngoing) ...const [
            SizedBox(height: 12),
            SupportingText(text: 'In progress'),
          ],
          if (timelineFailure != null) ...[
            const SizedBox(height: 12),
            FieldFailureWidget(failure: timelineFailure),
          ],
          const SizedBox(height: 16),
          ContentBlock(
            title: 'Highlights',
            child: ValidatedBulletList(
              items: item.highlights,
              collectionFailure: collectionFailureOrNull(
                item.highlights,
                minLength: 1,
              ),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResumeEducationCard extends StatelessWidget {
  const _ResumeEducationCard({
    required this.item,
  });

  final ResumeEducationItem item;

  @override
  Widget build(BuildContext context) {
    final dateFailure = dateRangeFailureOrNull(
      startDate: item.startDate,
      endDate: item.endDate,
    );

    return ContentCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ValidatedText(
            field: item.title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ValidatedText(
            field: item.institution,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          MetadataRow(
            items: [
              MetadataItemData(
                label: 'Location',
                value: item.location,
              ),
              MetadataItemData(
                label: 'Started',
                value: item.startDate,
              ),
              MetadataItemData(
                label: 'Ended',
                value: item.endDate,
              ),
            ],
          ),
          if (dateFailure != null) ...[
            const SizedBox(height: 12),
            FieldFailureWidget(failure: dateFailure),
          ],
        ],
      ),
    );
  }
}

class _ResumeLanguagesCard extends StatelessWidget {
  const _ResumeLanguagesCard({
    required this.languages,
  });

  final List<ResumeLanguageItem> languages;

  @override
  Widget build(BuildContext context) {
    final collectionFailure = collectionFailureOrNull(
      languages,
      minLength: 1,
    );

    if (collectionFailure != null) {
      return FieldFailureWidget(
        failure: collectionFailure,
      );
    }

    final widgets = <Widget>[];

    for (var index = 0; index < languages.length; index++) {
      widgets.add(
        _ResumeLanguageRow(item: languages[index]),
      );

      if (index < languages.length - 1) {
        widgets.add(const SizedBox(height: 12));
      }
    }

    return ContentCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      ),
    );
  }
}

class _ResumeLanguageRow extends StatelessWidget {
  const _ResumeLanguageRow({
    required this.item,
  });

  final ResumeLanguageItem item;

  @override
  Widget build(BuildContext context) {
    final proficiencyFailure = item.proficiency.isValid
        ? null
        : ValueFailure<String>.invalidResumeLanguageProficiency(
            failedValue: item.proficiency.jsonValue,
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ValidatedText(
          field: item.language,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 4),
        if (proficiencyFailure == null)
          SupportingText(text: item.proficiency.jsonValue)
        else
          FieldFailureWidget(failure: proficiencyFailure),
      ],
    );
  }
}
