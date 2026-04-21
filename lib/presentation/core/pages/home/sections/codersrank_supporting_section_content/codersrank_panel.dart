part of '../codersrank_supporting_section_content.dart';

class _CodersRankPanel extends StatelessWidget {
  const _CodersRankPanel({
    required this.cardKey,
    required this.child,
  });

  final Key cardKey;
  final Widget child;

  @override
  Widget build(BuildContext context) => ContentCard(
    key: cardKey,
    child: child,
  );
}
