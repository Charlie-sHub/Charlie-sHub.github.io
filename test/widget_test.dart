import 'package:charlie_shub_portfolio/presentation/core/app/portfolio_app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'renders the portfolio app shell without placeholder home scaffolding',
    (tester) async {
      await tester.pumpWidget(const PortfolioApp());
      await tester.pumpAndSettle();

      expect(find.text('Carlos Mendez'), findsAtLeastNWidgets(1));
      expect(find.text('About'), findsOneWidget);
      expect(find.text('Projects'), findsOneWidget);
      expect(find.text('Certifications'), findsOneWidget);
      expect(find.text('Theme Verification Only'), findsNothing);
      expect(find.text('Temporary Widget Showcase'), findsNothing);
      expect(find.text('Portfolio Overview'), findsNothing);
      expect(find.text('Current setup'), findsNothing);
    },
  );
}
