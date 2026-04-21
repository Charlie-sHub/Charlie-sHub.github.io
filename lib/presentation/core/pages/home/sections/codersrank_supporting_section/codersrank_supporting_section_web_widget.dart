part of '../codersrank_supporting_section_web.dart';

class _CodersRankSupportingSectionWeb extends StatefulWidget {
  const _CodersRankSupportingSectionWeb({
    required this.shouldPrepare,
  });

  final ValueListenable<bool> shouldPrepare;

  @override
  State<_CodersRankSupportingSectionWeb> createState() =>
      _CodersRankSupportingSectionWebState();
}

class _CodersRankSupportingSectionWebState
    extends State<_CodersRankSupportingSectionWeb> {
  late final _CodersRankEmbedHandle _rankHandle;

  final List<StreamSubscription<html.Event>> _subscriptions =
      <StreamSubscription<html.Event>>[];

  Completer<bool>? _registrationCompleter;
  Timer? _registrationPollTimer;
  Timer? _registrationTimeoutTimer;
  Timer? _renderPollTimer;
  Timer? _renderTimeoutTimer;
  _CodersRankRenderStatus _status = _CodersRankRenderStatus.checking;
  bool _hasStartedPreparing = false;

  @override
  void initState() {
    super.initState();
    _rankHandle = _createRankHandle();
    widget.shouldPrepare.addListener(_handlePreparationSignalChanged);
    _handlePreparationSignalChanged();
  }

  @override
  void didUpdateWidget(covariant _CodersRankSupportingSectionWeb oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.shouldPrepare == widget.shouldPrepare) {
      return;
    }

    oldWidget.shouldPrepare.removeListener(_handlePreparationSignalChanged);
    widget.shouldPrepare.addListener(_handlePreparationSignalChanged);
    _handlePreparationSignalChanged();
  }

  @override
  void dispose() {
    widget.shouldPrepare.removeListener(_handlePreparationSignalChanged);
    _cancelRegistrationWait();
    _cancelReadinessTracking();
    _rankHandle.host.remove();
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
    _syncOffstageWidth(isCompact: isCompact);

    if (isVisible) {
      _syncVisibleHostStyling(_rankHandle);

      return CodersRankSupportingSectionContent(
        isVisible: true,
        rankWidget: _buildWidgetView(
          viewType: _rankHandle.viewType,
          height: AppCodersRankTheme.rankWidgetHeightFor(
            isCompact: isCompact,
          ),
        ),
      );
    } else {
      return const CodersRankSupportingSectionContent(isVisible: false);
    }
  }

  Future<void> _prepareEmbed() async {
    final scriptRequested = _ensureWidgetScriptRequested();
    if (!scriptRequested) {
      _hideSection();

      return;
    }

    final widgetRegistered = await _waitForWidgetRegistration();

    if (!mounted) {
      return;
    }

    if (widgetRegistered) {
      _attachHostOffstage(
        _rankHandle.host,
        width: AppCodersRankTheme.offstageSummaryWidth(
          isCompact: _isCompactViewport(),
        ),
      );
      _listenForWidgetLifecycle(_rankHandle);
      _renderPollTimer = Timer.periodic(
        CodersRankSupportingSectionConfig.registrationPollInterval,
        (_) => _checkRenderHeuristics(),
      );
      _renderTimeoutTimer = Timer(
        CodersRankSupportingSectionConfig.renderTimeout,
        _handleRenderTimeout,
      );
      _checkRenderHeuristics();
    } else {
      _hideSection();
    }
  }

  void _handlePreparationSignalChanged() {
    if (_hasStartedPreparing || !widget.shouldPrepare.value) {
      return;
    }

    _hasStartedPreparing = true;
    unawaited(_prepareEmbed());
  }

  _CodersRankEmbedHandle _createRankHandle() {
    final isCompact = _isCompactViewport();
    final host = _createHostElement();
    final element =
        html.document.createElement(
            CodersRankSupportingSectionConfig.summaryTagName,
          )
          ..setAttribute('username', CodersRankSupportingSectionConfig.username)
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

  bool _ensureWidgetScriptRequested() {
    if (_customElementIsRegistered(
      CodersRankSupportingSectionConfig.summaryTagName,
    )) {
      return true;
    }

    final head = html.document.head;
    if (head == null) {
      return false;
    }

    if (html.document.getElementById(
          CodersRankSupportingSectionConfig.summaryScriptId,
        ) ==
        null) {
      final script = html.ScriptElement()
        ..id = CodersRankSupportingSectionConfig.summaryScriptId
        ..src = CodersRankSupportingSectionConfig.summaryScriptUrl
        ..defer = true;

      head.append(script);
    }

    return true;
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
    if (_status == _CodersRankRenderStatus.checking &&
        _looksRendered(_rankHandle, minHeight: 56)) {
      _showSection();
    }
  }

  void _handleRenderTimeout() {
    if (_status == _CodersRankRenderStatus.checking) {
      _hideSection();
    }
  }

  void _listenForWidgetLifecycle(_CodersRankEmbedHandle handle) {
    _subscriptions.addAll(<StreamSubscription<html.Event>>[
      _dataEventProvider.forTarget(handle.element).listen((_) {
        _showSection();
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

    return rect.height >= minHeight;
  }

  void _showSection() {
    if (_status != _CodersRankRenderStatus.checking) {
      return;
    }

    _cancelReadinessTracking();
    _rankHandle.host.remove();

    if (mounted) {
      setState(() {
        _status = _CodersRankRenderStatus.visible;
      });
    }
  }

  void _hideSection() {
    _cancelReadinessTracking();
    _rankHandle.host.remove();

    if (mounted) {
      setState(() {
        _status = _CodersRankRenderStatus.hidden;
      });
    }
  }

  void _cancelReadinessTracking() {
    _renderPollTimer?.cancel();
    _renderPollTimer = null;
    _renderTimeoutTimer?.cancel();
    _renderTimeoutTimer = null;

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

  void _syncOffstageWidth({
    required bool isCompact,
  }) {
    if (_status == _CodersRankRenderStatus.checking) {
      _rankHandle.host.style.width =
          '${AppCodersRankTheme.offstageSummaryWidth(isCompact: isCompact)}px';
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
    final isRegistered = _customElementIsRegistered(
      CodersRankSupportingSectionConfig.summaryTagName,
    );

    if (isRegistered) {
      return true;
    }

    final existingCompleter = _registrationCompleter;
    if (existingCompleter != null) {
      return existingCompleter.future;
    }

    final completer = Completer<bool>();
    _registrationCompleter = completer;

    void complete({
      required bool didRegister,
    }) {
      if (completer.isCompleted) {
        return;
      }

      _registrationPollTimer?.cancel();
      _registrationPollTimer = null;
      _registrationTimeoutTimer?.cancel();
      _registrationTimeoutTimer = null;
      _registrationCompleter = null;
      completer.complete(didRegister);
    }

    void checkRegistration() {
      if (!mounted) {
        complete(didRegister: false);

        return;
      }

      if (_customElementIsRegistered(
        CodersRankSupportingSectionConfig.summaryTagName,
      )) {
        complete(didRegister: true);
      }
    }

    _registrationPollTimer = Timer.periodic(
      CodersRankSupportingSectionConfig.registrationPollInterval,
      (_) => checkRegistration(),
    );
    _registrationTimeoutTimer = Timer(
      CodersRankSupportingSectionConfig.registrationTimeout,
      () => complete(
        didRegister: _customElementIsRegistered(
          CodersRankSupportingSectionConfig.summaryTagName,
        ),
      ),
    );

    checkRegistration();

    return completer.future;
  }

  void _cancelRegistrationWait() {
    _registrationPollTimer?.cancel();
    _registrationPollTimer = null;
    _registrationTimeoutTimer?.cancel();
    _registrationTimeoutTimer = null;

    final completer = _registrationCompleter;
    _registrationCompleter = null;

    if (completer != null && !completer.isCompleted) {
      completer.complete(false);
    }
  }

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
