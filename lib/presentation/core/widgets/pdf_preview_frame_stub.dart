import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/text_widgets.dart';
import 'package:flutter/material.dart';

/// Builds a simple non-web fallback for the PDF preview surface.
Widget buildPdfPreviewFrame({
  required String path,
  required double height,
}) => SizedBox(
  height: height,
  width: double.infinity,
  child: const Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.picture_as_pdf_outlined),
        SizedBox(height: AppSpacing.size8),
        SupportingText(text: 'PDF preview'),
      ],
    ),
  ),
);
