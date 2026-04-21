import 'package:charlie_shub_portfolio/application/content/content_status.dart';
import 'package:charlie_shub_portfolio/domain/content/content_load_types.dart';
import 'package:charlie_shub_portfolio/domain/core/failures/app_failure.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/app_failure_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/text_widgets.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';

/// Builds the repeated loading and failure states for single-entry sections.
List<Widget> buildSingleEntrySectionChildren<T>({
  required ContentStatus overallStatus,
  required Option<Either<AppFailure, T>> sectionOption,
  required String loadingMessage,
  required String interruptedLoadingMessage,
  required String unavailableTitle,
  required List<Widget> Function(T data) loadedBuilder,
}) => sectionOption.fold(
  () => <Widget>[
    SectionSupportingText(
      text: overallStatus == ContentStatus.failure
          ? interruptedLoadingMessage
          : loadingMessage,
    ),
  ],
  (sectionLoad) => sectionLoad.fold(
    (failure) => <Widget>[
      AppFailureCard(
        failure: failure,
        title: unavailableTitle,
      ),
    ],
    loadedBuilder,
  ),
);

/// Builds the repeated loading, failure, and empty states for selector-driven
/// sections while leaving the selector body explicit in each section widget.
List<Widget> buildSelectorSectionChildren<T>({
  required ContentStatus overallStatus,
  required Option<Either<AppFailure, List<SectionItemLoad<T>>>> sectionOption,
  required String loadingMessage,
  required String interruptedLoadingMessage,
  required String unavailableTitle,
  required String emptyMessage,
  required Widget Function(List<SectionItemLoad<T>> items) selectorBuilder,
}) => sectionOption.fold(
  () => <Widget>[
    SectionSupportingText(
      text: overallStatus == ContentStatus.failure
          ? interruptedLoadingMessage
          : loadingMessage,
    ),
  ],
  (sectionLoad) => sectionLoad.fold(
    (failure) => <Widget>[
      AppFailureCard(
        failure: failure,
        title: unavailableTitle,
      ),
    ],
    (items) {
      if (items.isEmpty) {
        return <Widget>[
          SectionSupportingText(
            text: emptyMessage,
          ),
        ];
      } else {
        return <Widget>[
          selectorBuilder(items),
        ];
      }
    },
  ),
);

/// Prefers the first successfully loaded item inside a selector section.
int preferredSuccessfulSectionItemIndex<T>(List<SectionItemLoad<T>> items) {
  final successfulIndex = items.indexWhere((item) => item.isRight());

  if (successfulIndex == -1) {
    return 0;
  }

  return successfulIndex;
}
