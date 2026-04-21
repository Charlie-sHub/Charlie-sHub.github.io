// This file is the intentionally web-only implementation used by a
// conditional import to render embedded PDF previews in Flutter Web.
// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';

part 'pdf_preview_frame/pdf_preview_frame_web_widget.dart';

int _pdfPreviewCounter = 0;

/// Builds a lightweight embedded PDF preview for Flutter Web.
Widget buildPdfPreviewFrame({
  required String path,
  required double height,
}) => _PdfPreviewFrameWeb(
  path: path,
  height: height,
);

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
