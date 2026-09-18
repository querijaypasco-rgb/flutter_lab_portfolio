import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/network_provider.dart';

/// NetworkMonitorScreen is a [StatelessWidget]: it has no local state of
/// its own — every piece of data it shows (current network, request log)
/// comes from the global [NetworkProvider], which it watches via
/// context.watch(). Any change to that provider (a real connectivity
/// event, or a request changing status) rebuilds this screen instantly.
class NetworkMonitorScreen extends StatelessWidget {
  const NetworkMonitorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final network = context.watch<NetworkProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Network Monitor')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth > 600
                ? 600.0
                : constraints.maxWidth;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Real-time status dashboard.
                      _StatusCard(state: network.currentState),
                      const SizedBox(height: 24),

                      Text(
                        'Simulate a network request',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Starts a 3-second simulated dataset fetch. If the '
                        'network drops mid-request (e.g. toggling Wi-Fi '
                        'off), it is automatically queued and retried the '
                        'moment connectivity returns.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 14),
                      // Row + Expanded so the two buttons share the width
                      // evenly on any screen size instead of overflowing.
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: network.simulateRequest,
                              icon: const Icon(Icons.cloud_download_rounded),
                              label: const Text('Simulate Request'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          OutlinedButton(
                            onPressed: network.requestLog.isEmpty
                                ? null
                                : network.clearLog,
                            child: const Text('Clear Log'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),

                      Text(
                        'Request Queue',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),

                      if (network.requestLog.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            'No requests yet. Tap "Simulate Request" above.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        )
                      else
                        // ListView.builder + shrinkWrap: adapts to any
                        // number of log entries without overflowing the
                        // parent scroll view.
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: network.requestLog.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            return _RequestTile(
                              request: network.requestLog[index],
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Purely presentational — StatelessWidget — the live dashboard card
/// showing which interface is currently active.
class _StatusCard extends StatelessWidget {
  final NetworkState state;
  const _StatusCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final (icon, label, color) = switch (state) {
      NetworkState.wifi => (
          Icons.wifi_rounded,
          'Connected — Wi-Fi',
          Colors.green,
        ),
      NetworkState.cellular => (
          Icons.signal_cellular_alt_rounded,
          'Connected — Cellular',
          Colors.blue,
        ),
      NetworkState.offline => (
          Icons.wifi_off_rounded,
          'Offline',
          Colors.red,
        ),
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: color.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(16),
        color: color.withValues(alpha: 0.06),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          // Expanded so the status text wraps on narrow phones instead
          // of overflowing past the card's edge.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Active Network Interface',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// One row in the request queue/log — StatelessWidget, purely driven by
/// the QueuedRequest passed in.
class _RequestTile extends StatelessWidget {
  final QueuedRequest request;
  const _RequestTile({required this.request});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final (icon, label, color) = switch (request.status) {
      RequestStatus.inFlight => (
          Icons.sync_rounded,
          'In flight…',
          Colors.blue,
        ),
      RequestStatus.queued => (
          Icons.pause_circle_outline_rounded,
          'Queued — waiting for connection',
          Colors.orange,
        ),
      RequestStatus.retrying => (
          Icons.replay_rounded,
          'Retrying…',
          Colors.orange,
        ),
      RequestStatus.completed => (
          Icons.check_circle_outline_rounded,
          'Completed',
          Colors.green,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          // Expanded keeps the label from pushing the status chip off
          // screen on narrow widths.
          Expanded(
            child: Text(
              request.label,
              style: theme.textTheme.bodyLarge,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}