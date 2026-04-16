// Shared token names are kept short and self-describing to avoid noisy
// boilerplate docs on every constant.
// ignore_for_file: public_member_api_docs

import 'package:charlie_shub_portfolio/presentation/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Centralizes CodersRank-specific sizing and CSS variable styling.
final class AppCodersRankTheme {
  const AppCodersRankTheme._();

  static const double widgetRowBreakpoint = 680;
  static const double rankWidgetHeight = 176;
  static const double rankWidgetCompactHeight = 248;
  static const double activityWidgetHeight = 236;
  static const double activityWidgetCompactHeight = 208;

  static double offstageSummaryWidth({
    required bool isCompact,
  }) => isCompact ? 420 : 720;

  static double offstageActivityWidth({
    required bool isCompact,
  }) => isCompact ? 720 : 960;

  static double rankWidgetHeightFor({
    required bool isCompact,
  }) => isCompact ? rankWidgetCompactHeight : rankWidgetHeight;

  static double activityWidgetHeightFor({
    required bool isCompact,
  }) => isCompact ? activityWidgetCompactHeight : activityWidgetHeight;

  static Map<String, String> summaryVariables({
    required bool isCompact,
  }) => <String, String>{
    '--bg-color': 'transparent',
    '--badge-bg-color': _cssColor(AppColors.coolAccentMuted),
    '--badge-text-color': _cssColor(AppColors.textPrimary),
    '--badges-padding': '0px',
    '--badge-padding': '8px 12px',
    '--badge-margin': '10px',
    '--badge-border-radius': '999px',
    '--badge-rank-font-size': '15px',
    '--badge-technology-font-size': '16px',
    '--badge-location-font-size': '14px',
    '--badge-icon-size': '26px',
    '--badge-border':
        '1px solid ${_cssColor(AppColors.coolAccent.withValues(alpha: 0.18))}',
    '--badge-box-shadow': 'none',
  };

  static Map<String, String> activityVariables({
    required bool isCompact,
  }) => <String, String>{
    '--bg-color-0': _cssColor(AppColors.surfaceSecondary),
    '--bg-color-1': _cssColor(AppColors.coolAccentSoft),
    '--bg-color-2': _cssColor(AppColors.coolAccentMuted),
    '--bg-color-3': _cssColor(AppColors.coolAccent.withValues(alpha: 0.58)),
    '--bg-color-4': _cssColor(AppColors.coolAccent),
    '--label-text-color': _cssColor(AppColors.textMuted),
    '--svg-width': isCompact ? '720px' : '1080px',
  };

  static String _cssColor(Color colorValue) {
    final value = colorValue.toARGB32();
    final hex = value.toRadixString(16).padLeft(8, '0').substring(2);

    return '#$hex';
  }
}
