import 'package:charlie_shub_portfolio/presentation/portfolio_app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'renders the portfolio app shell with the real section scaffold',
    (tester) async {
      await tester.pumpWidget(const PortfolioApp());
      await tester.pump();

      expect(find.text('Charlie Shub'), findsOneWidget);
      expect(find.text('Projects'), findsOneWidget);
      expect(find.text('Certifications'), findsOneWidget);
      expect(find.text('Current setup'), findsOneWidget);
    },
  );
}
