import 'package:charlie_shub_portfolio/presentation/portfolio_app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'shows the first-pass portfolio home page',
    (tester) async {
      await tester.pumpWidget(const PortfolioApp());

      expect(find.text('Charlie Shub'), findsOneWidget);
      expect(
        find.text('Portfolio site rebuild in progress.'),
        findsOneWidget,
      );
      expect(find.text('Current setup'), findsOneWidget);
    },
  );
}
