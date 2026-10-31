import 'package:flutter/material.dart';
import '../models/charging_session.dart';
import '../state/app_state.dart';

class ChargingViewModel extends ChangeNotifier {
  final AppState appState;

  ChargingViewModel({required this.appState}) {
    appState.addListener(_onAppStateChanged);
  }

  void _onAppStateChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    appState.removeListener(_onAppStateChanged);
    super.dispose();
  }

  // Getters
  ChargingSession? get activeSession => appState.activeSession;
  bool get hasActiveSession => activeSession != null;
  bool get isPaused => activeSession?.isPaused ?? false;
  double get currentSocPercent => activeSession?.currentPercent ?? appState.selectedVehicle.currentSocPercent;
  double get energyDeliveredKwh => activeSession?.energyDeliveredKwh ?? 0.0;
  double get currentSpeedKw => activeSession?.currentSpeedKw ?? 0.0;
  double get totalCost => activeSession?.totalCost ?? 0.0;
  int get elapsedSeconds => activeSession?.elapsedSeconds ?? 0;
  bool get isSweetSpotReached => currentSocPercent >= 80.0;

  // Actions
  void pauseCharging() {
    activeSession?.pauseCharging();
    notifyListeners();
  }

  void resumeCharging() {
    activeSession?.resumeCharging();
    notifyListeners();
  }

  void stopCharging() {
    appState.stopActiveCharging();
    notifyListeners();
  }
}
