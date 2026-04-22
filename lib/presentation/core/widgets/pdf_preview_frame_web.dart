// This file is the intentionally web-only implementation used by a
// conditional import to render embedded PDF previews in Flutter Web.
// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:charlie_shub_portfolio/presentation/core/utils/browser_facing_asset_url.dart';
import 'package:flutter/material.dart';

int _pdfPreviewCounter = 0;

/// Builds a lightweight embedded PDF preview for Flutter Web.
Widget buildPdfPreviewFrame({
  required String path,
  required double height,
  required VoidCallback onReady,
}) => _PdfPreviewFrameWeb(
  path: path,
  height: height,
  onReady: onReady,
);

String _registerPreviewView(
  String path, {
  required VoidCallback onReady,
}) {
  final viewType = 'pdf-preview-${_pdfPreviewCounter++}';
  final previewAssetUrl = resolveBrowserFacingAssetUrl(path);
  final previewUrl =
      '$previewAssetUrl#page=1&toolbar=0&navpanes=0&scrollbar=0&zoom=page-fit';

  ui_web.platformViewRegistry.registerViewFactory(
    viewType,
    (viewId) {
      var didReportReady = false;

      void reportReady() {
        if (didReportReady) {
          return;
        }

        didReportReady = true;
        onReady();
      }

      final frame = html.IFrameElement()
        ..src = previewUrl
        ..style.border = '0'
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.pointerEvents = 'none'
        ..tabIndex = -1
        ..setAttribute('loading', 'lazy');

      frame.onLoad.listen((_) {
        reportReady();
      });
      frame.onError.listen((_) {
        reportReady();
      });

      return frame;
    },
  );

  return viewType;
}

class _PdfPreviewFrameWeb extends StatefulWidget {
  const _PdfPreviewFrameWeb({
    required this.path,
    required this.height,
    required this.onReady,
  });

  final String path;
  final double height;
  final VoidCallback onReady;

  @override
  State<_PdfPreviewFrameWeb> createState() => _PdfPreviewFrameWebState();
}

class _PdfPreviewFrameWebState extends State<_PdfPreviewFrameWeb> {
  late String _viewType;
  bool _didNotifyReady = false;

  @override
  void initState() {
    super.initState();
    _viewType = _registerPreviewView(
      widget.path,
      onReady: widget.onReady,
    );
    _scheduleReadyNotification();
  }

  @override
  void didUpdateWidget(covariant _PdfPreviewFrameWeb oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.path != widget.path) {
      _didNotifyReady = false;
      _viewType = _registerPreviewView(
        widget.path,
        onReady: widget.onReady,
      );
      _scheduleReadyNotification();
    }
  }

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: SizedBox(
      height: widget.height,
      width: double.infinity,
      child: HtmlElementView(viewType: _viewType),
    ),
  );

  void _scheduleReadyNotification() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _didNotifyReady) {
        return;
      }

      _didNotifyReady = true;
      widget.onReady();
    });
  }
}
