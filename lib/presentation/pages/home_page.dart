import 'package:charlie_shub_portfolio/presentation/sections/architecture_status_section.dart';
import 'package:charlie_shub_portfolio/presentation/sections/home_intro_section.dart';
import 'package:flutter/material.dart';

/// Current home page scaffold for the portfolio site.
class PortfolioHomePage extends StatelessWidget {
  /// Creates the current home page scaffold.
  const PortfolioHomePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 960),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeIntroSection(),
                SizedBox(height: 24),
                ArchitectureStatusSection(),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
