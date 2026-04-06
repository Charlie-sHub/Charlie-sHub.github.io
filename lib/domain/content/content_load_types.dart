import 'package:charlie_shub_portfolio/domain/core/failures/app_failure.dart';
import 'package:dartz/dartz.dart';

/// Result for one item inside a multi-entry content section.
///
/// A `Right` contains the loaded domain entity. A `Left` contains an item-local
/// load failure such as a missing file or malformed JSON payload.
typedef SectionItemLoad<T> = Either<AppFailure, T>;

/// Result for a multi-entry content section load.
///
/// The outer `Left` is reserved for broader section-level failures such as a
/// broken or missing manifest. The outer `Right` contains ordered item results,
/// where each item may have loaded successfully or failed locally.
typedef MultiEntrySectionLoad<T> = Either<AppFailure, List<SectionItemLoad<T>>>;
