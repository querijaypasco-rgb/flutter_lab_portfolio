import 'package:flutter/material.dart';

/// Activity2Screen is a [StatefulWidget] because it owns an interactive,
/// screen-local checklist. This state (which steps are checked) is only
/// meaningful here, so it lives in this widget's State object rather than
/// in the global Provider — a clean example of "local vs global" state.
class Activity2Screen extends StatefulWidget {
  const Activity2Screen({super.key});

  @override
  State<Activity2Screen> createState() => _Activity2ScreenState();
}

class _Activity2ScreenState extends State<Activity2Screen> {
  final List<String> _steps = const [
    'Review active network handover procedure',
    'Simulate cell handover between two nodes',
    'Log signal strength before and after handover',
    'Document failure/recovery scenarios',
  ];

  late final List<bool> _completed = List<bool>.filled(_steps.length, false);

  int get _completedCount => _completed.where((c) => c).length;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = _completedCount / _steps.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Activity 2')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Flat icon illustration — matches the badge style on
              // Activity 1, with an icon relevant to this activity's topic.
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
                    Icons.cell_tower_rounded,
                    size: 44,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Active Network & Handover Handling',
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
                    'September 11, 2026',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Row + Expanded keeps the progress bar filling available
              // width while the label stays a fixed size next to it.
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 10,
                        backgroundColor: theme.colorScheme.surfaceContainerHighest,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '$_completedCount/${_steps.length}',
                    style: theme.textTheme.labelLarge,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Checklist',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              // ListView.builder with shrinkWrap adapts to any number of
              // steps without overflowing the parent scroll view.
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _steps.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _completed[index],
                    title: Text(_steps[index]),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (checked) {
                      // setState is scoped to THIS screen only — it never
                      // touches global Provider state.
                      setState(() => _completed[index] = checked ?? false);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}