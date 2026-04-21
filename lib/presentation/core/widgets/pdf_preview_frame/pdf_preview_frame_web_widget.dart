part of '../pdf_preview_frame_web.dart';

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
