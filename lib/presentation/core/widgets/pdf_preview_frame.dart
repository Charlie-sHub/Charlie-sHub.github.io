import 'package:charlie_shub_portfolio/presentation/core/widgets/pdf_preview_frame_stub.dart'
    if (dart.library.html) 'package:charlie_shub_portfolio/presentation/core/widgets/pdf_preview_frame_web.dart'
    as impl;
import 'package:flutter/widgets.dart';

/// Renders a lightweight in-page PDF preview where supported.
class PdfPreviewFrame extends StatelessWidget {
  /// Creates a PDF preview frame.
  const PdfPreviewFrame({
    required this.path,
    required this.height,
    super.key,
  });

  /// Relative repository path for the bundled PDF asset.
  final String path;

  /// Height of the preview frame.
  final double height;

  @override
  Widget build(BuildContext context) =>
      impl.buildPdfPreviewFrame(path: path, height: height);
}
