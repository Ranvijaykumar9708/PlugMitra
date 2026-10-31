import 'package:flutter/material.dart';
import '../models/station.dart';
import '../models/vehicle.dart';
import '../state/app_state.dart';

class DiscoverViewModel extends ChangeNotifier {
  final AppState appState;
  bool _isMapView = true;
  String _activeChip = 'All';

  DiscoverViewModel({required this.appState}) {
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
  bool get isMapView => _isMapView;
  String get activeChip => _activeChip;
  List<ChargingStation> get stations => appState.filteredStations;
  ChargingStation? get selectedStation => appState.selectedStation ?? (stations.isNotEmpty ? stations.first : null);
  EVVehicle get selectedVehicle => appState.selectedVehicle;
  bool get isVipMember => appState.isVipMember;

  // Actions
  void toggleViewMode() {
    _isMapView = !_isMapView;
    notifyListeners();
  }

  void setMapView(bool mapView) {
    if (_isMapView != mapView) {
      _isMapView = mapView;
      notifyListeners();
    }
  }

  void setChip(String chip) {
    _activeChip = chip;
    if (chip == 'All') {
      appState.setFilterChip('All');
    } else if (chip.contains('Fast DC') || chip.contains('फास्ट')) {
      appState.setFilterChip('Fast Charging');
    } else if (chip.contains('Available') || chip.contains('उपलब्ध')) {
      appState.setFilterChip('Available');
    } else if (chip.contains('Solar') || chip.contains('सोलर')) {
      appState.toggleSolarFilter();
      appState.setFilterChip(chip);
    } else {
      appState.setFilterChip(chip);
    }
    notifyListeners();
  }

  void setSearchQuery(String query) {
    appState.setSearchQuery(query);
  }

  void selectStation(ChargingStation station) {
    appState.selectStation(station);
  }
}
