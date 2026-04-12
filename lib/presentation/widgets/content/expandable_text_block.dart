import 'package:flutter/material.dart';

/// Displays long-form text with a simple read-more or show-less control.
class ExpandableTextBlock extends StatefulWidget {
  /// Creates an expandable text block.
  const ExpandableTextBlock({
    required this.text,
    this.style,
    this.collapsedMaxLines = 4,
    this.readMoreLabel = 'Read more',
    this.showLessLabel = 'Show less',
    this.textAlign,
    super.key,
  }) : assert(
         collapsedMaxLines > 0,
         'collapsedMaxLines must be greater than zero.',
       );

  /// The full text value to render.
  final String text;

  /// The text style used for the body copy.
  final TextStyle? style;

  /// The number of lines shown before expansion.
  final int collapsedMaxLines;

  /// The label shown when the content is collapsed.
  final String readMoreLabel;

  /// The label shown when the content is expanded.
  final String showLessLabel;

  /// The alignment applied to the text.
  final TextAlign? textAlign;

  @override
  State<ExpandableTextBlock> createState() => _ExpandableTextBlockState();
}

class _ExpandableTextBlockState extends State<ExpandableTextBlock> {
  bool _isExpanded = false;

  @override
  void didUpdateWidget(covariant ExpandableTextBlock oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.text != widget.text ||
        oldWidget.collapsedMaxLines != widget.collapsedMaxLines) {
      _isExpanded = false;
    }
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final textStyle = DefaultTextStyle.of(context).style.merge(widget.style);
      final shouldShowToggle = _shouldShowToggle(
        context,
        constraints: constraints,
        style: textStyle,
      );

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.text,
            maxLines: _isExpanded ? null : widget.collapsedMaxLines,
            overflow: _isExpanded
                ? TextOverflow.visible
                : TextOverflow.ellipsis,
            style: widget.style,
            textAlign: widget.textAlign,
          ),
          if (shouldShowToggle) ...[
            const SizedBox(height: 8),
            TextButton(
              onPressed: _toggleExpanded,
              style: TextButton.styleFrom(
                alignment: Alignment.centerLeft,
                minimumSize: Size.zero,
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
              child: Text(
                _isExpanded ? widget.showLessLabel : widget.readMoreLabel,
              ),
            ),
          ],
        ],
      );
    },
  );

  bool _shouldShowToggle(
    BuildContext context, {
    required BoxConstraints constraints,
    required TextStyle style,
  }) {
    if (!constraints.hasBoundedWidth) {
      return false;
    }

    final textPainter = TextPainter(
      maxLines: widget.collapsedMaxLines,
      text: TextSpan(
        text: widget.text,
        style: style,
      ),
      textAlign: widget.textAlign ?? TextAlign.start,
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
    )..layout(maxWidth: constraints.maxWidth);

    return textPainter.didExceedMaxLines;
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }
}
