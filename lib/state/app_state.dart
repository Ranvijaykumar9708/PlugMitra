import 'package:flutter/material.dart';
import '../models/station.dart';
import '../models/vehicle.dart';
import '../models/charging_session.dart';

class AppState extends ChangeNotifier {
  final List<ChargingStation> _stations = List.from(ChargingStation.sampleStations);
  final List<EVVehicle> _vehicles = List.from(EVVehicle.defaultGarage);
  int _selectedVehicleIndex = 0;

  ChargingSession? _activeSession;
  final List<BookingRecord> _bookings = [];
  double _walletBalance = 1850.0;
  int _currentTabIndex = 0;

  // Filters
  String _searchQuery = '';
  String _selectedFilterChip = 'All';
  VehicleCategory? _selectedCategoryFilter;
  ChargingStation? _selectedStation;

  // Advanced Filters
  String? _filterConnector;
  double _minPowerKw = 0.0;
  bool _onlyAvailable = false;
  bool _onlyPlugMitra = false;
  bool _only24x7 = false;
  List<String> _selectedAmenities = [];

  // AutoCharge NFC & RFID
  bool _isAutoChargeEnabled = true;

  // Community Issues
  final List<Map<String, dynamic>> _reportedIssues = [];

  AppState() {
    // Seed initial demo booking
    _bookings.add(
      BookingRecord(
        bookingId: 'PM-DEL-8921',
        stationName: 'PlugMitra HyperHub DLF',
        stationAddress: 'Cyber City, Phase 2, Gurugram',
        connectorName: 'Gun 1 (CCS-2) • 120 kW',
        slotTime: '05:30 PM - 06:15 PM',
        date: 'Today',
        vehicleName: 'Tata Nexon EV Long Range',
        estimatedCost: 390.0,
        qrToken: 'PM-8921-VALID-EV',
      ),
    );
  }

  // Getters
  List<ChargingStation> get allStations => _stations;
  List<EVVehicle> get vehicles => _vehicles;
  EVVehicle get selectedVehicle => _vehicles[_selectedVehicleIndex];
  int get selectedVehicleIndex => _selectedVehicleIndex;
  ChargingSession? get activeSession => _activeSession;
  List<BookingRecord> get bookings => _bookings;
  double get walletBalance => _walletBalance;
  int get currentTabIndex => _currentTabIndex;
  String get searchQuery => _searchQuery;
  String get selectedFilterChip => _selectedFilterChip;
  VehicleCategory? get selectedCategoryFilter => _selectedCategoryFilter;
  ChargingStation? get selectedStation => _selectedStation;

  String? get filterConnector => _filterConnector;
  double get minPowerKw => _minPowerKw;
  bool get onlyAvailable => _onlyAvailable;
  bool get onlyPlugMitra => _onlyPlugMitra;
  bool get only24x7 => _only24x7;
  List<String> get selectedAmenities => _selectedAmenities;
  bool get isAutoChargeEnabled => _isAutoChargeEnabled;
  List<Map<String, dynamic>> get reportedIssues => _reportedIssues;

  void toggleAutoCharge(bool value) {
    _isAutoChargeEnabled = value;
    notifyListeners();
  }

  void reportStationIssue(String stationName, String issueType, String notes) {
    _reportedIssues.add({
      'station': stationName,
      'issue': issueType,
      'notes': notes,
      'timestamp': DateTime.now().toIso8601String(),
    });
    notifyListeners();
  }

  void setAdvancedFilters({
    String? connector,
    double? minPowerKw,
    bool? onlyAvailable,
    bool? onlyPlugMitra,
    bool? only24x7,
    List<String>? amenities,
  }) {
    _filterConnector = connector;
    if (minPowerKw != null) _minPowerKw = minPowerKw;
    if (onlyAvailable != null) _onlyAvailable = onlyAvailable;
    if (onlyPlugMitra != null) _onlyPlugMitra = onlyPlugMitra;
    if (only24x7 != null) _only24x7 = only24x7;
    if (amenities != null) _selectedAmenities = amenities;
    notifyListeners();
  }

  void selectStation(ChargingStation? station) {
    _selectedStation = station;
    notifyListeners();
  }

  List<ChargingStation> get filteredStations {
    return _stations.where((s) {
      // 1. Vehicle Category Filter (2W, 3W, 4W, Truck)
      if (_selectedCategoryFilter != null) {
        if (!s.supportsCategory(_selectedCategoryFilter!)) {
          return false;
        }
      }

      // 2. Search Query
      final matchesSearch = _searchQuery.isEmpty ||
          s.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s.city.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s.operator.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s.address.toLowerCase().contains(_searchQuery.toLowerCase());

      if (!matchesSearch) return false;

      // 3. Feature Chips
      if (_selectedFilterChip == 'Fast (>50kW)' || _selectedFilterChip == 'Fast Charging') {
        if (s.maxSpeedKw < 50) return false;
      } else if (_selectedFilterChip == 'Available Now' || _selectedFilterChip == 'Available') {
        if (s.availablePorts <= 0) return false;
      } else if (_selectedFilterChip == '24/7 Open') {
        if (!s.isOpen24x7) return false;
      } else if (_selectedFilterChip == 'Heavy Truck Bay' || _selectedFilterChip == 'Truck Bay') {
        if (!s.hasHeavyTruckBay) return false;
      } else if (_selectedFilterChip.contains('PlugMitra Hubs')) {
        if (!s.isPlugMitraOwned) return false;
      }

      // 4. Advanced Filters
      if (_onlyAvailable && s.availablePorts <= 0) return false;
      if (_onlyPlugMitra && !s.isPlugMitraOwned) return false;
      if (_only24x7 && !s.isOpen24x7) return false;
      if (_minPowerKw > 0.0 && s.maxSpeedKw < _minPowerKw) return false;
      if (_filterConnector != null && !s.connectors.any((c) => c.type.toLowerCase().contains(_filterConnector!.toLowerCase()))) {
        return false;
      }
      if (_selectedAmenities.isNotEmpty && !_selectedAmenities.every((a) => s.amenities.contains(a))) {
        return false;
      }

      return true;
    }).toList();
  }

  void setTabIndex(int index) {
    _currentTabIndex = index;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setFilterChip(String chip) {
    _selectedFilterChip = chip;
    notifyListeners();
  }

  void setCategoryFilter(VehicleCategory? category) {
    _selectedCategoryFilter = category;
    notifyListeners();
  }

  void selectVehicle(int index) {
    if (index >= 0 && index < _vehicles.length) {
      _selectedVehicleIndex = index;
      // Auto align filter with user's selected vehicle
      _selectedCategoryFilter = _vehicles[index].category;
      notifyListeners();
    }
  }

  void addNewVehicle(EVVehicle vehicle) {
    _vehicles.add(vehicle);
    _selectedVehicleIndex = _vehicles.length - 1;
    _selectedCategoryFilter = vehicle.category;
    notifyListeners();
  }

  void addWalletBalance(double amount) {
    _walletBalance += amount;
    notifyListeners();
  }

  void startChargingSession({
    required ChargingStation station,
    required ConnectorInfo connector,
    double targetPercent = 85.0,
  }) {
    _activeSession?.dispose();
    _activeSession = ChargingSession(
      id: 'session-${DateTime.now().millisecondsSinceEpoch}',
      station: station,
      connector: connector,
      vehicle: selectedVehicle,
      initialPercent: selectedVehicle.currentSocPercent,
      targetPercent: targetPercent,
    );
    _activeSession!.addListener(() {
      notifyListeners();
    });
    _activeSession!.startCharging();
    _currentTabIndex = 3; // Switch to Live Charging screen (Tab 3 in 5-tab layout)
    notifyListeners();
  }

  void stopActiveCharging() {
    if (_activeSession != null) {
      final cost = _activeSession!.totalCost;
      if (_walletBalance >= cost) {
        _walletBalance -= cost;
      }
      _activeSession!.stopCharging();
      notifyListeners();
    }
  }

  void dismissCompletedSession() {
    _activeSession?.dispose();
    _activeSession = null;
    _currentTabIndex = 0;
    notifyListeners();
  }

  void createBooking({
    required ChargingStation station,
    required ConnectorInfo connector,
    required String slotTime,
    required double estimatedCost,
  }) {
    final booking = BookingRecord(
      bookingId: 'PM-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      stationName: station.name,
      stationAddress: station.address,
      connectorName: '${connector.name} • ${connector.powerKw.toInt()} kW',
      slotTime: slotTime,
      date: 'Today',
      vehicleName: selectedVehicle.fullName,
      estimatedCost: estimatedCost,
      qrToken: 'PM-QR-${DateTime.now().millisecondsSinceEpoch}',
    );

    _bookings.insert(0, booking);
    notifyListeners();
  }
}
