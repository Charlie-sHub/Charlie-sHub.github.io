import 'dart:async';

import 'package:charlie_shub_portfolio/application/content/content_cubit.dart';
import 'package:charlie_shub_portfolio/application/content/content_state.dart';
import 'package:charlie_shub_portfolio/application/content/content_status.dart';
import 'package:charlie_shub_portfolio/data/content/asset_content_repository.dart';
import 'package:charlie_shub_portfolio/domain/content/content_repository_interface.dart';
import 'package:charlie_shub_portfolio/presentation/core/pages/home/home_page.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_theme.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/content_load_completion_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Root application widget for the portfolio site.
class PortfolioApp extends StatelessWidget {
  /// Creates the root application widget.
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) =>
      RepositoryProvider<ContentRepositoryInterface>(
        create: (context) => AssetContentRepository(),
        child: BlocProvider(
          create: (context) {
            final contentCubit = ContentCubit(
              context.read<ContentRepositoryInterface>(),
            );

            unawaited(contentCubit.loadAllContent());

            return contentCubit;
          },
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: BlocSelector<ContentCubit, ContentState, bool>(
              selector: (state) =>
                  state.status != ContentStatus.initial &&
                  state.status != ContentStatus.loading,
              builder: (context, isContentLoadComplete) =>
                  ContentLoadCompletionScope(
                    isComplete: isContentLoadComplete,
                    child: PortfolioHomePage(
                      initialSectionId: Uri.base.fragment,
                    ),
                  ),
            ),
            theme: buildAppTheme(),
            themeMode: ThemeMode.light,
            title: 'Carlos Mendez',
          ),
        ),
      );
}
