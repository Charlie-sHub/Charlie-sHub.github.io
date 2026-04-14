// ignore_for_file: avoid_web_libraries_in_flutter, document_ignores
// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:charlie_shub_portfolio/presentation/core/pages/home/sections/codersrank_supporting_section_content.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_codersrank_theme.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_layout.dart';
import 'package:flutter/material.dart';

const _codersRankUsername = 'charlie-shub';
const _registrationPollInterval = Duration(milliseconds: 150);
const _registrationTimeout = Duration(seconds: 8);
const _renderTimeout = Duration(seconds: 8);

const _dataEventProvider = html.EventStreamProvider<html.Event>('data');
const _errorEventProvider = html.EventStreamProvider<html.Event>('error');

int _codersRankViewCounter = 0;

/// Builds the CodersRank section for Flutter Web.
Widget buildCodersRankSupportingSection() =>
    const _CodersRankSupportingSectionWeb();

enum _CodersRankRenderStatus {
  checking,
  visible,
  hidden,
}

enum _CodersRankWidgetSlot {
  rank,
  activity,
}

class _CodersRankSupportingSectionWeb extends StatefulWidget {
  const _CodersRankSupportingSectionWeb();

  @override
  State<_CodersRankSupportingSectionWeb> createState() =>
      _CodersRankSupportingSectionWebState();
}

class _CodersRankSupportingSectionWebState
    extends State<_CodersRankSupportingSectionWeb> {
  late final _CodersRankEmbedHandle _rankHandle;
  late final _CodersRankEmbedHandle _activityHandle;

  final List<StreamSubscription<html.Event>> _subscriptions =
      <StreamSubscription<html.Event>>[];

  Timer? _renderPollTimer;
  Timer? _renderTimeoutTimer;
  _CodersRankRenderStatus _status = _CodersRankRenderStatus.checking;
  bool _rankReady = false;
  bool _activityReady = false;

  @override
  void initState() {
    super.initState();
    _rankHandle = _createRankHandle();
    _activityHandle = _createActivityHandle();
    unawaited(_prepareEmbeds());
  }

  @override
  void dispose() {
    _cancelReadinessTracking();
    _rankHandle.host.remove();
    _activityHandle.host.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isCompact =
        MediaQuery.sizeOf(context).width <
        AppCodersRankTheme.widgetRowBreakpoint;
    final isVisible = _status == _CodersRankRenderStatus.visible;

    _applyCssVariables(
      _rankHandle.element,
      AppCodersRankTheme.summaryVariables(isCompact: isCompact),
    );
    _applyCssVariables(
      _activityHandle.element,
      AppCodersRankTheme.activityVariables(isCompact: isCompact),
    );
    _syncOffstageWidths(isCompact: isCompact);

    if (isVisible) {
      _syncVisibleHostStyling(_rankHandle);
      _syncVisibleHostStyling(_activityHandle);

      return CodersRankSupportingSectionContent(
        isVisible: true,
        rankWidget: _buildWidgetView(
          viewType: _rankHandle.viewType,
          height: AppCodersRankTheme.rankWidgetHeightFor(
            isCompact: isCompact,
          ),
        ),
        activityWidget: _buildWidgetView(
          viewType: _activityHandle.viewType,
          height: AppCodersRankTheme.activityWidgetHeightFor(
            isCompact: isCompact,
          ),
        ),
      );
    } else {
      return const CodersRankSupportingSectionContent(isVisible: false);
    }
  }

  Future<void> _prepareEmbeds() async {
    final widgetsRegistered = await _waitForWidgetRegistration();

    if (!mounted) {
      return;
    }

    if (widgetsRegistered) {
      _attachHostsOffstage();
      _listenForWidgetLifecycle(_CodersRankWidgetSlot.rank, _rankHandle);
      _listenForWidgetLifecycle(
        _CodersRankWidgetSlot.activity,
        _activityHandle,
      );
      _renderPollTimer = Timer.periodic(
        _registrationPollInterval,
        (_) => _checkRenderHeuristics(),
      );
      _renderTimeoutTimer = Timer(_renderTimeout, _handleRenderTimeout);
      _checkRenderHeuristics();
    } else {
      _hideSection();
    }
  }

  _CodersRankEmbedHandle _createActivityHandle() {
    final isCompact = _isCompactViewport();
    final host = _createHostElement();
    final element = html.document.createElement('codersrank-activity')
      ..setAttribute('username', _codersRankUsername)
      ..setAttribute('legend', 'false')
      ..setAttribute('labels', '')
      ..setAttribute('tooltip', '')
      ..setAttribute('step', '5');

    _applyCssVariables(
      element,
      AppCodersRankTheme.activityVariables(isCompact: isCompact),
    );
    host.append(element);

    return _CodersRankEmbedHandle(
      host: host,
      element: element,
      viewType: _registerHostView(host),
    );
  }

  _CodersRankEmbedHandle _createRankHandle() {
    final isCompact = _isCompactViewport();
    final host = _createHostElement();
    final element = html.document.createElement('codersrank-summary')
      ..setAttribute('username', _codersRankUsername)
      ..setAttribute('show-header', 'false');

    _applyCssVariables(
      element,
      AppCodersRankTheme.summaryVariables(isCompact: isCompact),
    );
    host.append(element);

    return _CodersRankEmbedHandle(
      host: host,
      element: element,
      viewType: _registerHostView(host),
    );
  }

  bool _customElementIsRegistered(String tagName) {
    final registry = html.window.customElements;
    final definition = registry?.get(tagName);

    return definition != null;
  }

  void _attachHostsOffstage() {
    _attachHostOffstage(
      _rankHandle.host,
      width: AppCodersRankTheme.offstageSummaryWidth(
        isCompact: _isCompactViewport(),
      ),
    );
    _attachHostOffstage(
      _activityHandle.host,
      width: AppCodersRankTheme.offstageActivityWidth(
        isCompact: _isCompactViewport(),
      ),
    );
  }

  void _attachHostOffstage(
    html.DivElement host, {
    required double width,
  }) {
    final body = html.document.body;

    if (body != null) {
      host.style
        ..position = 'fixed'
        ..left = '-10000px'
        ..top = '0'
        ..width = '${width}px'
        ..visibility = 'hidden'
        ..pointerEvents = 'none'
        ..opacity = '0';

      if (!identical(host.parent, body)) {
        body.append(host);
      }
    } else {
      _hideSection();
    }
  }

  Widget _buildWidgetView({
    required String viewType,
    required double height,
  }) => ClipRect(
    child: SizedBox(
      height: height,
      width: double.infinity,
      child: HtmlElementView(viewType: viewType),
    ),
  );

  void _checkRenderHeuristics() {
    if (_status == _CodersRankRenderStatus.checking) {
      if (!_rankReady && _looksRendered(_rankHandle, minHeight: 56)) {
        _markReady(_CodersRankWidgetSlot.rank);
      }

      if (!_activityReady && _looksRendered(_activityHandle, minHeight: 120)) {
        _markReady(_CodersRankWidgetSlot.activity);
      }
    }
  }

  void _handleRenderTimeout() {
    if (_status == _CodersRankRenderStatus.checking) {
      _hideSection();
    }
  }

  void _listenForWidgetLifecycle(
    _CodersRankWidgetSlot slot,
    _CodersRankEmbedHandle handle,
  ) {
    _subscriptions.addAll(<StreamSubscription<html.Event>>[
      _dataEventProvider.forTarget(handle.element).listen((_) {
        _markReady(slot);
      }),
      _errorEventProvider.forTarget(handle.element).listen((_) {
        _hideSection();
      }),
    ]);
  }

  bool _looksRendered(
    _CodersRankEmbedHandle handle, {
    required double minHeight,
  }) {
    final rect = handle.host.getBoundingClientRect();
    final hostHasSize = rect.height >= minHeight;

    return hostHasSize;
  }

  void _markReady(_CodersRankWidgetSlot slot) {
    if (_status == _CodersRankRenderStatus.checking) {
      if (slot == _CodersRankWidgetSlot.rank) {
        _rankReady = true;
      } else {
        _activityReady = true;
      }

      if (_rankReady && _activityReady) {
        _showSection();
      }
    }
  }

  void _showSection() {
    _cancelReadinessTracking();
    _rankHandle.host.remove();
    _activityHandle.host.remove();

    if (mounted) {
      setState(() {
        _status = _CodersRankRenderStatus.visible;
      });
    }
  }

  void _hideSection() {
    _cancelReadinessTracking();
    _rankHandle.host.remove();
    _activityHandle.host.remove();

    if (mounted) {
      setState(() {
        _status = _CodersRankRenderStatus.hidden;
      });
    }
  }

  void _cancelReadinessTracking() {
    _renderPollTimer?.cancel();
    _renderTimeoutTimer?.cancel();

    for (final subscription in _subscriptions) {
      unawaited(subscription.cancel());
    }
    _subscriptions.clear();
  }

  html.DivElement _createHostElement() => html.DivElement()
    ..style.width = '100%'
    ..style.height = '100%'
    ..style.overflow = 'hidden'
    ..style.display = 'block';

  String _registerHostView(html.DivElement host) {
    final viewType = 'codersrank-view-${_codersRankViewCounter++}';

    ui_web.platformViewRegistry.registerViewFactory(
      viewType,
      (_) => host,
    );

    return viewType;
  }

  bool _isCompactViewport() {
    final viewportWidth =
        html.window.innerWidth?.toDouble() ??
        html.document.documentElement?.clientWidth.toDouble() ??
        AppLayout.maxContentWidth;

    return viewportWidth < AppCodersRankTheme.widgetRowBreakpoint;
  }

  void _syncOffstageWidths({
    required bool isCompact,
  }) {
    if (_status == _CodersRankRenderStatus.checking) {
      _rankHandle.host.style.width =
          '${AppCodersRankTheme.offstageSummaryWidth(isCompact: isCompact)}px';
      _activityHandle.host.style.width =
          '${AppCodersRankTheme.offstageActivityWidth(isCompact: isCompact)}px';
    }
  }

  void _syncVisibleHostStyling(_CodersRankEmbedHandle handle) {
    handle.host.style
      ..position = 'static'
      ..left = 'auto'
      ..top = 'auto'
      ..width = '100%'
      ..height = '100%'
      ..visibility = 'visible'
      ..pointerEvents = 'auto'
      ..opacity = '1';
  }

  Future<bool> _waitForWidgetRegistration() async {
    final deadline = DateTime.now().add(_registrationTimeout);
    var widgetsRegistered = _requiredWidgetsAreRegistered();

    while (!widgetsRegistered && DateTime.now().isBefore(deadline)) {
      await Future<void>.delayed(_registrationPollInterval);
      widgetsRegistered = _requiredWidgetsAreRegistered();
    }

    return widgetsRegistered;
  }

  bool _requiredWidgetsAreRegistered() =>
      _customElementIsRegistered('codersrank-summary') &&
      _customElementIsRegistered('codersrank-activity');

  void _applyCssVariables(
    html.Element element,
    Map<String, String> variables,
  ) {
    for (final entry in variables.entries) {
      element.style.setProperty(entry.key, entry.value);
    }

    element.style
      ..display = 'block'
      ..width = '100%';
  }
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
