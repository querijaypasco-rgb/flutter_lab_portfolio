import 'package:flutter/material.dart';

/// A simple, mostly-static detail screen — StatelessWidget is the right
/// choice since it displays fixed content and holds no interactive state.
class Activity1Screen extends StatelessWidget {
  const Activity1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Activity 1')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Flat icon illustration — a simple circular badge, in
              // keeping with the app's minimalist visual language (no
              // shadows, no gradients).
              Center(
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.colorScheme.outlineVariant,
                    ),
                  ),
                  child: Icon(
                    Icons.widgets_rounded,
                    size: 44,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Flutter Lab Portfolio App',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'September 08, 2026',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Objective',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Build a multi-screen Flutter application that serves as '
                'the master compilation app for laboratory activities, '
                'demonstrating navigation, responsive layout, and both '
                'stateless and stateful widget architecture.',
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 20),
              Text(
                'Key Concepts Covered',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const _IconList(
                items: [
                  (Icons.widgets_outlined, 'Declarative UI with StatelessWidget and StatefulWidget'),
                  (Icons.alt_route_rounded, 'Named/route-based navigation between screens'),
                  (Icons.view_column_outlined, 'Responsive layout using Column, Row, and Expanded'),
                  (Icons.hub_outlined, 'Global state management with Provider'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A bulleted list where each line has a small leading icon instead of a
/// plain dot — a lightweight illustration touch that keeps the flat,
/// minimalist look (no filled backgrounds, just outline icons).
class _IconList extends StatelessWidget {
  final List<(IconData, String)> items;
  const _IconList({required this.items});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    item.$1,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 1),
                      child: Text(item.$2, style: theme.textTheme.bodyLarge),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}