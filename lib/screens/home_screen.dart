import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_state_provider.dart';
import '../widgets/activity_card.dart';
import 'activity1_screen.dart';
import 'activity2_screen.dart';
import 'settings_screen.dart';

/// HomeScreen is a [StatefulWidget] because it owns one piece of local,
/// screen-specific UI state: which bottom-nav tab is selected. That state
/// has nothing to do with the rest of the app, so it does NOT belong in
/// the global provider — a good illustration of local vs. global state.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onNavTap(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SettingsScreen()),
      ).then((_) => setState(() => _selectedIndex = 0));
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.dashboard_rounded, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              'Dashboard',
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              tooltip: 'Toggle theme',
              style: IconButton.styleFrom(
                backgroundColor: theme.colorScheme.primaryContainer
                    .withValues(alpha: 0.4),
                shape: const CircleBorder(),
              ),
              icon: Icon(
                appState.isDarkMode
                    ? Icons.dark_mode_rounded
                    : Icons.wb_sunny_rounded,
              ),
              onPressed: () => appState.toggleTheme(!appState.isDarkMode),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth > 600
                ? 600.0
                : constraints.maxWidth;
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello! ${appState.userName}',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Your Flutter laboratory activities in one place.',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 28),
                      Text(
                        'Laboratory Activities',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ActivityCard(
                        activityLabel: 'Activity 1',
                        title: 'Flutter Lab Portfolio App',
                        date: 'September 08, 2026',
                        onViewActivity: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const Activity1Screen(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ActivityCard(
                        activityLabel: 'Activity 2',
                        title: 'Active Network & Handover Handling',
                        date: 'September 11, 2026',
                        onViewActivity: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const Activity2Screen(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onNavTap,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}