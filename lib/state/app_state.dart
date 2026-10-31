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
  bool _onlySolar = false;
  List<String> _selectedAmenities = [];

  // AutoCharge NFC & RFID
  bool _isAutoChargeEnabled = true;

  // 👑 PlugMitra Black / Gold VIP Club
  bool _isVipMember = false;
  String _vipTier = 'PlugMitra Black VIP';

  // 🚨 Mitra Rescue (On-Demand Mobile DC Charging Van SOS)
  bool _isRescueActive = false;
  Map<String, dynamic>? _activeRescue;

  // 🌙 Smart ToD (Time-of-Day) Off-Peak Charging Schedule
  bool _isScheduledChargeActive = false;
  String _scheduledChargeStartTime = '11:00 PM';

  // 🏢 Fleet Mitra Mode (Enterprise Fleet & Logistics Dashboard)
  bool _isFleetMode = false;
  double _fleetWalletBalance = 48500.0;

  // 💰 V2G (Vehicle-to-Grid) Reverse Monetization
  bool _isV2gActive = false;
  double _v2gEarningsToday = 420.0;
  final double _v2gExportRateKw = 11.0;

  // 🩺 Battery Doctor Diagnostic Telemetry
  final double _batterySohPercent = 98.2;
  final double _batteryTempCelsius = 28.5;
  final int _batteryCycleCount = 142;
  final String _batteryHealthRating = 'Pristine Condition (Class A+)';

  // 🔄 60-Second Battery Swap System
  int _availableSwapPacks = 9;

  // 🤖 Mitra Valet & RoboCharge Concierge
  bool _isValetActive = false;
  Map<String, dynamic>? _activeValetTask;

  // 🏡 Mitra Home-Sync & Rooftop Solar IoT
  bool _isSolarOnlyMode = false;
  bool _homeLoadBalancing = true;
  double _homeCurrentKw = 7.4;
  final String _homeWallboxModel = 'Tata Power EZ Home 7.4 kW';
  final double _homeSolarYieldKw = 5.2;

  // ☕ Bay Delivery & Highway Cafe Dine-In
  bool _hasActiveFoodOrder = false;
  Map<String, dynamic>? _activeFoodOrder;
  final String _loungeAccessPin = 'PIN-VIP-7709';

  // 🤝 Mitra P2P Community Charger Sharing (Airbnb for Chargers)
  bool _isP2pHostMode = false;
  final double _p2pEarnings = 12480.0;
  double _p2pRatePerUnit = 14.5;
  bool _p2pListingActive = true;

  // 🛡️ Mitra Shield: Monsoon Flood & Zero-Dep Battery Insurance
  final bool _isMitraShieldActive = true;
  final String _shieldPolicyId = 'PM-SHIELD-EV-9821-ZERO';
  final String _shieldPlanName = 'Monsoon Flood & Battery Zero-Dep Platinum';
  final List<Map<String, dynamic>> _shieldClaims = [];

  // 🛣️ Highway Corridor Shield (Zero-Anxiety Inter-State Cruise)
  bool _isHighwayCorridorActive = false;
  final String _activeCorridorName = 'Delhi - Mumbai Expressway (Green Corridor)';
  final int _corridorFallbackReservePercent = 20;

  // 🪙 Mitra Green Tokens & Carbon Credit Marketplace
  double _greenCarbonTokens = 1480.0; // 1 Token = ₹1.80
  final double _co2AvoidedKg = 1920.0;

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
  bool get onlySolar => _onlySolar;
  List<String> get selectedAmenities => _selectedAmenities;
  bool get isAutoChargeEnabled => _isAutoChargeEnabled;
  List<Map<String, dynamic>> get reportedIssues => _reportedIssues;

  // 👑 VIP Getters & Actions
  bool get isVipMember => _isVipMember;
  String get vipTier => _vipTier;
  double get vipDiscountMultiplier => _isVipMember ? 0.75 : 1.0; // 25% discount for VIPs

  void upgradeVipMembership({String tier = 'PlugMitra Black VIP'}) {
    _isVipMember = true;
    _vipTier = tier;
    notifyListeners();
  }

  void cancelVipMembership() {
    _isVipMember = false;
    notifyListeners();
  }

  // 🚨 Mitra Rescue SOS Getters & Actions
  bool get isRescueActive => _isRescueActive;
  Map<String, dynamic>? get activeRescue => _activeRescue;

  void dispatchRescueVan({
    required String locationAddress,
    required double targetBoostKwh,
    required String serviceType,
  }) {
    _isRescueActive = true;
    _activeRescue = {
      'vanId': 'VAN-DL-04-EV-901',
      'technicianName': 'Vikram Singh (Certified EV Specialist)',
      'phone': '+91 98112 34567',
      'location': locationAddress,
      'targetBoostKwh': targetBoostKwh,
      'serviceType': serviceType,
      'etaMinutes': 14,
      'batteryChargeKw': 30.0, // 30kW mobile DC rapid charger
      'status': 'En Route with 30kW Mobile DC Pack',
      'timestamp': DateTime.now().toIso8601String(),
    };
    notifyListeners();
  }

  void cancelRescueMission() {
    _isRescueActive = false;
    _activeRescue = null;
    notifyListeners();
  }

  // 🌙 Smart ToD Scheduled Charging
  bool get isScheduledChargeActive => _isScheduledChargeActive;
  String get scheduledChargeStartTime => _scheduledChargeStartTime;

  void toggleScheduledCharging(bool enable, {String? time}) {
    _isScheduledChargeActive = enable;
    if (time != null) _scheduledChargeStartTime = time;
    notifyListeners();
  }

  // 🏢 Fleet Mitra Mode
  bool get isFleetMode => _isFleetMode;
  double get fleetWalletBalance => _fleetWalletBalance;

  void toggleFleetMode(bool value) {
    _isFleetMode = value;
    notifyListeners();
  }

  void topUpFleetWallet(double amount) {
    _fleetWalletBalance += amount;
    notifyListeners();
  }

  void toggleSolarFilter() {
    _onlySolar = !_onlySolar;
    notifyListeners();
  }

  // 💰 V2G Getters & Actions
  bool get isV2gActive => _isV2gActive;
  double get v2gEarningsToday => _v2gEarningsToday;
  double get v2gExportRateKw => _v2gExportRateKw;

  void toggleV2g(bool value) {
    _isV2gActive = value;
    if (value) {
      _v2gEarningsToday += 18.50; // increment demo earnings
    }
    notifyListeners();
  }

  // 🩺 Battery Doctor Diagnostic Getters
  double get batterySohPercent => _batterySohPercent;
  double get batteryTempCelsius => _batteryTempCelsius;
  int get batteryCycleCount => _batteryCycleCount;
  String get batteryHealthRating => _batteryHealthRating;

  // 🔄 60-Second Battery Swap System
  int get availableSwapPacks => _availableSwapPacks;

  void performBatterySwap() {
    selectedVehicle.currentSocPercent = 100.0;
    if (_availableSwapPacks > 0) _availableSwapPacks--;
    notifyListeners();
  }

  // 🤖 Mitra Valet & RoboCharge Actions
  bool get isValetActive => _isValetActive;
  Map<String, dynamic>? get activeValetTask => _activeValetTask;

  void requestValetRoboCharge({required String location, required String vehicleName}) {
    _isValetActive = true;
    _activeValetTask = {
      'valetName': 'Suresh Mehta (Certified PlugMitra Valet Concierge)',
      'location': location,
      'vehicleName': vehicleName,
      'status': 'Car Parked & Connected to 60kW DC HyperGun',
      'targetSoc': 80,
      'keyHandoverPin': 'PM-VALET-9821',
      'photoVerified': true,
      'timestamp': DateTime.now().toIso8601String(),
    };
    notifyListeners();
  }

  void completeValetTask() {
    _isValetActive = false;
    _activeValetTask = null;
    notifyListeners();
  }

  // 🏡 Home-Sync Getters & Actions
  bool get isSolarOnlyMode => _isSolarOnlyMode;
  bool get homeLoadBalancing => _homeLoadBalancing;
  double get homeCurrentKw => _homeCurrentKw;
  String get homeWallboxModel => _homeWallboxModel;
  double get homeSolarYieldKw => _homeSolarYieldKw;

  void toggleSolarOnlyMode(bool value) {
    _isSolarOnlyMode = value;
    notifyListeners();
  }

  void toggleHomeLoadBalancing(bool value) {
    _homeLoadBalancing = value;
    notifyListeners();
  }

  void updateHomeCurrentKw(double kw) {
    _homeCurrentKw = kw;
    notifyListeners();
  }

  // ☕ Bay Delivery Getters & Actions
  bool get hasActiveFoodOrder => _hasActiveFoodOrder;
  Map<String, dynamic>? get activeFoodOrder => _activeFoodOrder;
  String get loungeAccessPin => _loungeAccessPin;

  void placeBayFoodOrder({
    required String cafeName,
    required List<String> items,
    required double totalAmount,
    required String bayNumber,
  }) {
    _hasActiveFoodOrder = true;
    _activeFoodOrder = {
      'orderId': 'BAY-FOOD-${DateTime.now().millisecondsSinceEpoch % 10000}',
      'cafeName': cafeName,
      'items': items,
      'totalAmount': totalAmount,
      'bayNumber': bayNumber,
      'status': 'Preparing fresh at highway kitchen',
      'etaMinutes': 8,
      'timestamp': DateTime.now().toIso8601String(),
    };
    notifyListeners();
  }

  void cancelBayFoodOrder() {
    _hasActiveFoodOrder = false;
    _activeFoodOrder = null;
    notifyListeners();
  }

  // 🤝 P2P Sharing Getters & Actions
  bool get isP2pHostMode => _isP2pHostMode;
  double get p2pEarnings => _p2pEarnings;
  double get p2pRatePerUnit => _p2pRatePerUnit;
  bool get p2pListingActive => _p2pListingActive;

  void toggleP2pHostMode(bool value) {
    _isP2pHostMode = value;
    notifyListeners();
  }

  void updateP2pRate(double rate) {
    _p2pRatePerUnit = rate;
    notifyListeners();
  }

  void toggleP2pListing(bool value) {
    _p2pListingActive = value;
    notifyListeners();
  }

  // 🛡️ Mitra Shield Insurance Getters & Actions
  bool get isMitraShieldActive => _isMitraShieldActive;
  String get shieldPolicyId => _shieldPolicyId;
  String get shieldPlanName => _shieldPlanName;
  List<Map<String, dynamic>> get shieldClaims => _shieldClaims;

  void submitShieldClaim({
    required String incidentType,
    required String description,
    required double estimatedDamageAmount,
  }) {
    _shieldClaims.add({
      'claimId': 'CLM-EV-${DateTime.now().millisecondsSinceEpoch % 100000}',
      'incidentType': incidentType,
      'description': description,
      'amount': estimatedDamageAmount,
      'status': 'Instant Pre-Approval Granted via Battery Doctor',
      'date': 'Today',
      'policyNumber': _shieldPolicyId,
    });
    notifyListeners();
  }

  // 🛣️ Highway Corridor Shield Getters & Actions
  bool get isHighwayCorridorActive => _isHighwayCorridorActive;
  String get activeCorridorName => _activeCorridorName;
  int get corridorFallbackReservePercent => _corridorFallbackReservePercent;

  void toggleHighwayCorridor(bool value) {
    _isHighwayCorridorActive = value;
    notifyListeners();
  }

  // 🪙 Mitra Green Tokens & Carbon Credit Marketplace Getters & Actions
  double get greenCarbonTokens => _greenCarbonTokens;
  double get co2AvoidedKg => _co2AvoidedKg;

  void sellCarbonTokensToCorporate(double tokensAmount) {
    if (tokensAmount <= _greenCarbonTokens) {
      _greenCarbonTokens -= tokensAmount;
      final earnings = tokensAmount * 1.80; // ₹1.80 per token
      _walletBalance += earnings;
      notifyListeners();
    }
  }

  void redeemTokens(double amount, String rewardName) {
    if (amount <= _greenCarbonTokens) {
      _greenCarbonTokens -= amount;
      notifyListeners();
    }
  }

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
      } else if (_selectedFilterChip.contains('Solar')) {
        if (!s.isSolarPowered) return false;
      }

      // 4. Advanced Filters
      if (_onlyAvailable && s.availablePorts <= 0) return false;
      if (_onlyPlugMitra && !s.isPlugMitraOwned) return false;
      if (_only24x7 && !s.isOpen24x7) return false;
      if (_onlySolar && !s.isSolarPowered) return false;
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

  void topUpWallet(double amount) => addWalletBalance(amount);

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
