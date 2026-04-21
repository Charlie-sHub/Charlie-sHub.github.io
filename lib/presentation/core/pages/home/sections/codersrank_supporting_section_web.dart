// ignore_for_file: avoid_web_libraries_in_flutter, document_ignores
// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:charlie_shub_portfolio/presentation/core/pages/home/sections/codersrank_supporting_section_config.dart';
import 'package:charlie_shub_portfolio/presentation/core/pages/home/sections/codersrank_supporting_section_content.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_codersrank_theme.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_layout.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

part 'codersrank_supporting_section/codersrank_supporting_section_web_widget.dart';

const _dataEventProvider = html.EventStreamProvider<html.Event>('data');
const _errorEventProvider = html.EventStreamProvider<html.Event>('error');

int _codersRankViewCounter = 0;

/// Builds the CodersRank section for Flutter Web.
Widget buildCodersRankSupportingSection({
  required ValueListenable<bool> shouldPrepare,
}) => _CodersRankSupportingSectionWeb(shouldPrepare: shouldPrepare);

enum _CodersRankRenderStatus {
  checking,
  visible,
  hidden,
}

class _CodersRankEmbedHandle {
  const _CodersRankEmbedHandle({
    required this.host,
    required this.element,
    required this.viewType,
  });

  final html.DivElement host;
  final html.Element element;
  final String viewType;
}
