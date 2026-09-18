import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/app_state_provider.dart';
import 'providers/network_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppStateProvider()),
        ChangeNotifierProvider(create: (_) => NetworkProvider()),
      ],
      child: const LabDashboardApp(),
    ),
  );
}

/// Clean corporate palette: a muted slate-navy accent instead of a bright
/// saturated color, plain off-white/near-black surfaces, and restrained
/// typography. Defined as explicit ColorSchemes (not ColorScheme.fromSeed)
/// so the tones stay deliberately muted rather than vibrant.
class _CorporatePalette {
  static const primary = Color(0xFF2C3E50); // muted slate navy
  static const primaryLight = Color(0xFF7C93B3);
  static const background = Color(0xFFF5F6F8);
  static const surfaceDark = Color(0xFF1A2028);
  static const surfaceDarkAlt = Color(0xFF232B36);
  static const textDark = Color(0xFF1F2937);
  static const outline = Color(0xFFD7DBE0);
}

class LabDashboardApp extends StatelessWidget {
  const LabDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateProvider>();

    const lightScheme = ColorScheme.light(
      primary: _CorporatePalette.primary,
      onPrimary: Colors.white,
      secondary: _CorporatePalette.primaryLight,
      surface: Colors.white,
      onSurface: _CorporatePalette.textDark,
      surfaceContainerHighest: Color(0xFFEDEFF2),
      outline: _CorporatePalette.outline,
      outlineVariant: _CorporatePalette.outline,
      onSurfaceVariant: Color(0xFF5B6472),
      primaryContainer: Color(0xFFE4E9EF),
    );

    const darkScheme = ColorScheme.dark(
      primary: _CorporatePalette.primaryLight,
      onPrimary: Color(0xFF10151C),
      secondary: _CorporatePalette.primary,
      surface: _CorporatePalette.surfaceDarkAlt,
      onSurface: Color(0xFFE5E8EC),
      surfaceContainerHighest: Color(0xFF2B3440),
      outline: Color(0xFF3A4552),
      outlineVariant: Color(0xFF3A4552),
      onSurfaceVariant: Color(0xFF9AA4B2),
      primaryContainer: Color(0xFF2B3440),
    );

    TextTheme buildTextTheme(Brightness brightness) {
      final base = ThemeData(brightness: brightness).textTheme;
      return base.copyWith(
        headlineMedium: base.headlineMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: base.headlineSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        titleLarge: base.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        titleMedium: base.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        bodyLarge: base.bodyLarge?.copyWith(height: 1.45),
        bodyMedium: base.bodyMedium?.copyWith(height: 1.45),
        labelLarge: base.labelLarge?.copyWith(fontWeight: FontWeight.w600),
      );
    }

    return MaterialApp(
      title: 'Flutter Lab Dashboard',
      debugShowCheckedModeBanner: false,
      themeMode: appState.themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightScheme,
        scaffoldBackgroundColor: _CorporatePalette.background,
        textTheme: buildTextTheme(Brightness.light),
        appBarTheme: const AppBarTheme(
          backgroundColor: _CorporatePalette.background,
          foregroundColor: _CorporatePalette.textDark,
          elevation: 0,
          centerTitle: false,
        ),
        navigationBarTheme: const NavigationBarThemeData(
          backgroundColor: Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
        dividerColor: _CorporatePalette.outline,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkScheme,
        scaffoldBackgroundColor: _CorporatePalette.surfaceDark,
        textTheme: buildTextTheme(Brightness.dark),
        appBarTheme: const AppBarTheme(
          backgroundColor: _CorporatePalette.surfaceDark,
          elevation: 0,
          centerTitle: false,
        ),
        navigationBarTheme: const NavigationBarThemeData(
          backgroundColor: _CorporatePalette.surfaceDarkAlt,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
      ),
      routes: {
        '/': (context) => const HomeScreen(),
      },
      initialRoute: '/',
    );
  }
}