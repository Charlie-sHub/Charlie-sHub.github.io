// This file is the intentionally web-only implementation used by a
// conditional import to render embedded PDF previews in Flutter Web.
// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';

int _pdfPreviewCounter = 0;

/// Builds a lightweight embedded PDF preview for Flutter Web.
Widget buildPdfPreviewFrame({
  required String path,
  required double height,
}) => _PdfPreviewFrameWeb(
  path: path,
  height: height,
);

class _PdfPreviewFrameWeb extends StatefulWidget {
  const _PdfPreviewFrameWeb({
    required this.path,
    required this.height,
  });

  final String path;
  final double height;

  @override
  State<_PdfPreviewFrameWeb> createState() => _PdfPreviewFrameWebState();
}

class _PdfPreviewFrameWebState extends State<_PdfPreviewFrameWeb> {
  late String _viewType;

  @override
  void initState() {
    super.initState();
    _viewType = _registerPreviewView(widget.path);
  }

  @override
  void didUpdateWidget(covariant _PdfPreviewFrameWeb oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.path != widget.path) {
      _viewType = _registerPreviewView(widget.path);
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
}

String _registerPreviewView(String path) {
  final viewType = 'pdf-preview-${_pdfPreviewCounter++}';
  final previewUrl =
      '$path#page=1&toolbar=0&navpanes=0&scrollbar=0&zoom=page-fit';

  ui_web.platformViewRegistry.registerViewFactory(
    viewType,
    (viewId) => html.IFrameElement()
      ..src = previewUrl
      ..style.border = '0'
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.pointerEvents = 'none'
      ..tabIndex = -1
      ..setAttribute('loading', 'lazy'),
  );

  return viewType;
}
