import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/value_object.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/validators/validate_asset_path.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/validators/validate_string_max_length.dart';
import 'package:dartz/dartz.dart';

const _assetPathMaxLength = 160;

/// Validated repository path under `assets/media/`.
final class AssetPath extends ValueObject<String> {
  /// Creates a validated asset path.
  factory AssetPath(String input) => AssetPath._(
    validateStringMaxLength(input, maxLength: _assetPathMaxLength).fold(
      left,
      validateAssetPath,
    ),
  );

  const AssetPath._(this.value);

  @override
  final Either<ValueFailure<String>, String> value;
}
