import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

/// The three states the dashboard cares about. connectivity_plus can
/// report more granular results (ethernet, bluetooth, vpn, etc.) but for
/// this activity we only distinguish Wi-Fi, Cellular, and Offline.
enum NetworkState { wifi, cellular, offline }

/// Lifecycle of one simulated request, shown in the UI's request log.
enum RequestStatus { inFlight, queued, retrying, completed }

/// A single simulated "fetch a large dataset" request.
class QueuedRequest {
  final String id;
  final String label;
  RequestStatus status;

  QueuedRequest({
    required this.id,
    required this.label,
    this.status = RequestStatus.inFlight,
  });
}

/// NetworkProvider is GLOBAL state (a ChangeNotifier, same pattern as
/// AppStateProvider) so both the Network Monitor screen — and, later,
/// any other screen — can react to live connectivity changes.
///
/// Responsibilities:
/// 1. Subscribe to the real device connectivity stream (Network Stream
///    Listener requirement).
/// 2. Expose the current NetworkState for the real-time dashboard.
/// 3. Simulate a long-running request; if the connection drops mid-flight,
///    catch it and queue the request instead of crashing (Request
///    Queuing System requirement).
/// 4. When connectivity is restored, automatically retry every queued
///    request (Graceful Recovery requirement).
class NetworkProvider extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  NetworkState _currentState = NetworkState.offline;
  NetworkState get currentState => _currentState;

  final List<QueuedRequest> _requestLog = [];
  List<QueuedRequest> get requestLog => List.unmodifiable(_requestLog);

  int _requestCounter = 0;

  NetworkProvider() {
    _init();
  }

  Future<void> _init() async {
    // Read the current state once on startup...
    final initial = await _connectivity.checkConnectivity();
    _applyResults(initial);

    // ...then keep listening for every future change. This is the
    // "Network Stream Listener" requirement: connectivity_plus pushes a
    // new event every time the active interface changes (Wi-Fi turned
    // off, cellular kicks in, airplane mode, etc.).
    _subscription = _connectivity.onConnectivityChanged.listen(_applyResults);
  }

  void _applyResults(List<ConnectivityResult> results) {
    final previousState = _currentState;

    if (results.contains(ConnectivityResult.wifi)) {
      _currentState = NetworkState.wifi;
    } else if (results.contains(ConnectivityResult.mobile)) {
      _currentState = NetworkState.cellular;
    } else {
      _currentState = NetworkState.offline;
    }

    // notifyListeners() is what makes the dashboard update in real time —
    // any widget watching this provider rebuilds immediately.
    notifyListeners();

    // Graceful Recovery: the moment we transition FROM offline TO a
    // stable connection, automatically resume any queued requests.
    final justReconnected =
        previousState == NetworkState.offline && _currentState != NetworkState.offline;
    if (justReconnected) {
      _retryQueuedRequests();
    }
  }

  /// Simulates fetching a large dataset. If the network drops while the
  /// "request" is in flight, it's caught and moved to the queue instead
  /// of throwing an unhandled exception.
  Future<void> simulateRequest() async {
    _requestCounter++;
    final request = QueuedRequest(
      id: 'req-$_requestCounter',
      label: 'Fetch dataset #$_requestCounter',
    );
    _requestLog.insert(0, request);
    notifyListeners();

    await _runRequest(request);
  }

  Future<void> _runRequest(QueuedRequest request) async {
    try {
      // Simulate real network latency for a "large" download.
      await Future.delayed(const Duration(seconds: 3));

      // If connectivity dropped at any point during the simulated
      // transfer (including mid-handover), treat this as a failed
      // request rather than letting it silently "succeed".
      if (_currentState == NetworkState.offline) {
        throw const _ConnectionLostException();
      }

      request.status = RequestStatus.completed;
    } on _ConnectionLostException {
      // Catch it — queue instead of crash.
      request.status = RequestStatus.queued;
    }
    notifyListeners();
  }

  Future<void> _retryQueuedRequests() async {
    final queued =
        _requestLog.where((r) => r.status == RequestStatus.queued).toList();
    for (final request in queued) {
      request.status = RequestStatus.retrying;
      notifyListeners();
      await _runRequest(request);
    }
  }

  void clearLog() {
    _requestLog.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

class _ConnectionLostException implements Exception {
  const _ConnectionLostException();
}