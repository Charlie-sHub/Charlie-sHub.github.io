import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/text_widgets.dart';
import 'package:flutter/material.dart';

/// Builds a simple non-web fallback for the PDF preview surface.
Widget buildPdfPreviewFrame({
  required String path,
  required double height,
  required VoidCallback onReady,
}) => _PdfPreviewFrameStub(
  path: path,
  height: height,
  onReady: onReady,
);

class _PdfPreviewFrameStub extends StatefulWidget {
  const _PdfPreviewFrameStub({
    required this.path,
    required this.height,
    required this.onReady,
  });

  final String path;
  final double height;
  final VoidCallback onReady;

  @override
  State<_PdfPreviewFrameStub> createState() => _PdfPreviewFrameStubState();
}

class _PdfPreviewFrameStubState extends State<_PdfPreviewFrameStub> {
  bool _didNotifyReady = false;

  @override
  void initState() {
    super.initState();
    _scheduleReadyNotification();
  }

  @override
  void didUpdateWidget(covariant _PdfPreviewFrameStub oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.path != widget.path) {
      _didNotifyReady = false;
      _scheduleReadyNotification();
    }
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    height: widget.height,
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

  void _scheduleReadyNotification() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_didNotifyReady || !mounted) {
        return;
      }

      _didNotifyReady = true;
      widget.onReady();
    });
  }
}
