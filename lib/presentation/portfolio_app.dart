import 'package:charlie_shub_portfolio/presentation/pages/home_page.dart';
import 'package:charlie_shub_portfolio/presentation/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Root application widget for the portfolio site.
class PortfolioApp extends StatelessWidget {
  /// Creates the root application widget.
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const PortfolioHomePage(),
    theme: buildAppTheme(),
    title: 'Charlie Shub Portfolio',
  );
}
