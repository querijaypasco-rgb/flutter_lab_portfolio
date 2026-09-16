import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_state_provider.dart';

/// SettingsScreen is a [StatefulWidget] purely to manage the local
/// TextEditingController for the name field. The actual VALUE it edits
/// (userName) and the theme flag both live in the global
/// [AppStateProvider] — that's the piece that, once changed here,
/// is instantly reflected back on HomeScreen.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    final appState = context.read<AppStateProvider>();
    _nameController = TextEditingController(text: appState.userName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // watch() here so the switch/value stays in sync if changed elsewhere.
    final appState = context.watch<AppStateProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionHeader(
                icon: Icons.person_outline_rounded,
                label: 'Profile',
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Display name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline_rounded),
                ),
                // context.read (no rebuild triggered by reading) is used
                // inside callbacks — we only want to WRITE, not subscribe.
                onChanged: (value) =>
                    context.read<AppStateProvider>().updateUserName(value),
              ),
              const SizedBox(height: 8),
              Text(
                'This updates the greeting on your Home Dashboard instantly.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 32),
              const _SectionHeader(
                icon: Icons.palette_outlined,
                label: 'Appearance',
              ),
              const SizedBox(height: 14),
              // A simple flat row — icon, label, switch — matching the
              // rest of the app's minimalist look. Row + Expanded so it
              // never overflows on narrow widths.
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: theme.colorScheme.outlineVariant.withValues(
                      alpha: 0.6,
                    ),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      appState.isDarkMode
                          ? Icons.dark_mode_outlined
                          : Icons.wb_sunny_outlined,
                      size: 20,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        appState.isDarkMode
                            ? 'Dark theme enabled'
                            : 'Light theme enabled',
                        style: theme.textTheme.bodyLarge,
                      ),
                    ),
                    Switch(
                      value: appState.isDarkMode,
                      onChanged: (useDark) => appState.toggleTheme(useDark),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Small reusable section label with a leading icon — used to visually
/// separate "Profile" from "Appearance" without adding cards or shadows.
class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SectionHeader({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          label,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}