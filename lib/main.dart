import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/app_state_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppStateProvider(),
      child: const LabDashboardApp(),
    ),
  );
}

class LabDashboardApp extends StatelessWidget {
  const LabDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateProvider>();

    // Accent color — emerald green.
    const seedColor = Color(0xFF10B981);

    final lightScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
    );
    final darkScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.dark,
    );

    // A distinct type feel using only Flutter's built-in font system —
    // no external package required. Tighter letter-spacing and a
    // consistently bolder weight give it a different personality from
    // the plain default text theme.
    TextTheme buildTextTheme(Brightness brightness) {
      final base = ThemeData(brightness: brightness).textTheme;
      return base.copyWith(
        headlineMedium: base.headlineMedium?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        headlineSmall: base.headlineSmall?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
        titleLarge: base.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
        ),
        titleMedium: base.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: base.bodyLarge?.copyWith(
          letterSpacing: 0.1,
          height: 1.4,
        ),
        bodyMedium: base.bodyMedium?.copyWith(
          letterSpacing: 0.1,
          height: 1.4,
        ),
        labelLarge: base.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      );
    }

    return MaterialApp(
      title: 'Flutter Lab Dashboard',
      debugShowCheckedModeBanner: false,
      themeMode: appState.themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightScheme,
        scaffoldBackgroundColor: Colors.white,
        textTheme: buildTextTheme(Brightness.light),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: const Color(0xFFECFDF5),
          indicatorColor: seedColor.withValues(alpha: 0.18),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkScheme,
        textTheme: buildTextTheme(Brightness.dark),
        appBarTheme: const AppBarTheme(elevation: 0, centerTitle: false),
      ),
      routes: {
        '/': (context) => const HomeScreen(),
      },
      initialRoute: '/',
    );
  }
}