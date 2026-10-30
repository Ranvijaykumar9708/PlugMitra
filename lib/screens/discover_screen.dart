import 'package:flutter/material.dart';
import '../models/station.dart';
import '../models/vehicle.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/advanced_filter_sheet.dart';
import '../widgets/map_preview_widget.dart';
import '../widgets/station_card.dart';
import '../widgets/trip_planner_dialog.dart';
import '../widgets/vip_membership_sheet.dart';
import '../widgets/mitra_rescue_sheet.dart';
import '../widgets/voice_copilot_sheet.dart';
import '../widgets/battery_swap_sheet.dart';
import '../widgets/elevation_route_planner_dialog.dart';
import '../widgets/battery_doctor_dialog.dart';
import '../widgets/valet_robocharge_sheet.dart';
import '../widgets/home_sync_sheet.dart';
import '../widgets/p2p_sharing_sheet.dart';
import '../widgets/highway_corridor_dialog.dart';
import '../widgets/carbon_marketplace_sheet.dart';
import 'station_detail_sheet.dart';

class DiscoverScreen extends StatefulWidget {
  final AppState appState;

  const DiscoverScreen({super.key, required this.appState});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  final List<String> _quickChips = [
    'All',
    'Available',
    'Fast Charging',
    '🔄 Battery Swap',
    '🗺️ Mountain Elevation',
    '🩺 Battery Doctor',
    '🤖 Valet Concierge',
    '🏡 Home Sync',
    '🤝 P2P Sharing',
    '🛣️ Highway Corridor',
    '🪙 Green Tokens',
    '🚨 Mitra Rescue SOS',
    '☀️ 100% Solar',
    '🛣️ Plan Trip',
    '⭐ PlugMitra Hubs',
    'Truck Bay',
  ];
  bool _isMapView = true; // Toggle between Screen 6 (Map) & Screen 7 (List)

  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.92);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _openStationDetail(ChargingStation station) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StationDetailSheet(
          station: station,
          appState: widget.appState,
          onBookSlot: () {
            Navigator.of(context).pop();
            widget.appState.setTabIndex(1); // Jump to Booking tab
          },
          onStartCharging: () {
            Navigator.of(context).pop();
            widget.appState.startChargingSession(
              station: station,
              connector: station.connectors.first,
            );
          },
        );
      },
    );
  }

  void _onPinSelected(ChargingStation station, List<ChargingStation> stations) {
    widget.appState.selectStation(station);
    final idx = stations.indexWhere((s) => s.id == station.id);
    if (idx != -1 && _pageController.hasClients) {
      _pageController.animateToPage(
        idx,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.appState;
    final stations = state.filteredStations;
    final selectedStation = state.selectedStation ?? (stations.isNotEmpty ? stations.first : null);

    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top App Bar / Search Header (Matching Screen 6 & 7 in UI Board)
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App Bar Row: Logo & View Switcher (Map / List)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: AppTheme.lightGreenBg,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.bolt, color: AppTheme.primaryGreen, size: 20),
                          ),
                          const SizedBox(width: 8),
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Plug',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    color: AppTheme.textPrimary,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Mitra',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    color: AppTheme.primaryGreen,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // 👑 VIP Club Access
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => VipMembershipSheet(appState: widget.appState),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                          decoration: BoxDecoration(
                            color: widget.appState.isVipMember ? const Color(0xFFFFD700).withOpacity(0.18) : AppTheme.lightGreenBg,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: widget.appState.isVipMember ? const Color(0xFFFFD700) : AppTheme.primaryGreen.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.workspace_premium,
                                size: 15,
                                color: widget.appState.isVipMember ? const Color(0xFFD97706) : AppTheme.primaryGreen,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                widget.appState.isVipMember ? 'VIP' : 'Black VIP',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: widget.appState.isVipMember ? const Color(0xFFD97706) : AppTheme.primaryGreen,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // View Switcher: Map vs List (Matching Screen 6 & Screen 7)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppTheme.borderLight),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildViewToggleItem(
                              title: 'Map',
                              icon: Icons.map,
                              isActive: _isMapView,
                              onTap: () => setState(() => _isMapView = true),
                            ),
                            _buildViewToggleItem(
                              title: 'List',
                              icon: Icons.format_list_bulleted,
                              isActive: !_isMapView,
                              onTap: () => setState(() => _isMapView = false),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Search Bar with Filter Icon (Matching Screen 6)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.borderLight),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14),
                          child: Icon(Icons.search, color: AppTheme.textMuted, size: 22),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _searchCtrl,
                            onChanged: (val) => state.setSearchQuery(val),
                            style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
                            decoration: const InputDecoration(
                              hintText: 'Search charging stations, hubs...',
                              hintStyle: TextStyle(color: AppTheme.textMuted, fontSize: 14),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                        if (_searchCtrl.text.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.clear, size: 18, color: AppTheme.textMuted),
                            onPressed: () {
                              _searchCtrl.clear();
                              state.setSearchQuery('');
                            },
                          ),
                        IconButton(
                          icon: const Icon(Icons.mic, color: AppTheme.primaryGreen, size: 20),
                          tooltip: 'Voice Search',
                          onPressed: () => _showVoiceSearchDialog(context, state),
                        ),
                        GestureDetector(
                          onTap: () => _openAdvancedFilters(context),
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: (state.filterConnector != null || state.minPowerKw > 0 || state.onlyAvailable || state.onlyPlugMitra || state.only24x7 || state.selectedAmenities.isNotEmpty)
                                  ? AppTheme.primaryGreen
                                  : AppTheme.lightGreenBg,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.tune,
                              color: (state.filterConnector != null || state.minPowerKw > 0 || state.onlyAvailable || state.onlyPlugMitra || state.only24x7 || state.selectedAmenities.isNotEmpty)
                                  ? Colors.white
                                  : AppTheme.primaryGreen,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Filter Chips: All, Available, Fast Charging (Matching Screen 6 & 7)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _quickChips.map((chip) {
                        final isSelected = state.selectedFilterChip == chip;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () {
                              if (chip.contains('Plan')) {
                                showDialog(
                                  context: context,
                                  builder: (_) => TripPlannerDialog(appState: widget.appState),
                                );
                              } else if (chip.contains('Rescue') || chip.contains('SOS')) {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (_) => MitraRescueSheet(appState: widget.appState),
                                );
                              } else if (chip.contains('Swap')) {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (_) => BatterySwapSheet(appState: widget.appState),
                                );
                              } else if (chip.contains('Mountain') || chip.contains('Elevation')) {
                                showDialog(
                                  context: context,
                                  builder: (_) => ElevationRoutePlannerDialog(appState: widget.appState),
                                );
                              } else if (chip.contains('Doctor')) {
                                showDialog(
                                  context: context,
                                  builder: (_) => BatteryDoctorDialog(appState: widget.appState),
                                );
                              } else if (chip.contains('Valet')) {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (_) => ValetRobochargeSheet(appState: widget.appState),
                                );
                              } else if (chip.contains('Home') || chip.contains('Sync')) {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (_) => HomeSyncSheet(appState: widget.appState),
                                );
                              } else if (chip.contains('P2P') || chip.contains('Sharing')) {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (_) => P2pSharingSheet(appState: widget.appState),
                                );
                              } else if (chip.contains('Corridor')) {
                                showDialog(
                                  context: context,
                                  builder: (_) => HighwayCorridorDialog(appState: widget.appState),
                                );
                              } else if (chip.contains('Tokens') || chip.contains('Green')) {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (_) => CarbonMarketplaceSheet(appState: widget.appState),
                                );
                              } else if (chip.contains('Solar')) {
                                state.toggleSolarFilter();
                                state.setFilterChip(chip);
                              } else {
                                state.setFilterChip(chip);
                              }
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                              decoration: BoxDecoration(
                                color: isSelected ? AppTheme.primaryGreen : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected ? AppTheme.primaryGreen : AppTheme.borderLight,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: AppTheme.primaryGreen.withOpacity(0.3),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Text(
                                chip,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : AppTheme.textSecondary,
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            // Main Content Area: Screen 6 (Map View) or Screen 7 (Nearby Stations List)
            Expanded(
              child: _isMapView
                  ? _buildMapScreenView(stations, selectedStation)
                  : _buildListScreenView(stations),
            ),
          ],
        ),
      ),
    );
  }

  // 🗺️ SCREEN 6: Home (Map) Layout with Swipeable Carousel for ALL Stations
  Widget _buildMapScreenView(List<ChargingStation> stations, ChargingStation? selectedStation) {
    if (stations.isEmpty) {
      return const Center(
        child: Text('No charging stations found matching filter'),
      );
    }

    final previewStation = selectedStation ?? stations.first;

    return Stack(
      children: [
        // Vector Map spanning the view
        Positioned.fill(
          child: MapPreviewWidget(
            stations: stations,
            selectedStation: previewStation,
            onSelectStation: (station) {
              _onPinSelected(station, stations);
            },
          ),
        ),

        // Swipeable Station Carousel (Floating ABOVE bottom navigation bar at bottom: 86)
        Positioned(
          left: 0,
          right: 0,
          bottom: 86,
          height: 168,
          child: Column(
            children: [
              // Navigation / Counter Pill Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Vehicle Quick Switcher Pill (Screen 6)
                    GestureDetector(
                      onTap: () => _openVehicleSwitcher(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.borderLight),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              widget.appState.selectedVehicle.category == VehicleCategory.twoWheeler
                                  ? Icons.two_wheeler
                                  : widget.appState.selectedVehicle.category == VehicleCategory.commercialTruck
                                      ? Icons.local_shipping
                                      : Icons.directions_car,
                              size: 14,
                              color: AppTheme.primaryGreen,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '${widget.appState.selectedVehicle.model.split(" ").first} (${widget.appState.selectedVehicle.currentSocPercent.toInt()}%)',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 2),
                            const Icon(Icons.arrow_drop_down, size: 16, color: AppTheme.textSecondary),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _isMapView = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.borderLight),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'View All List',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primaryGreen,
                              ),
                            ),
                            SizedBox(width: 3),
                            Icon(Icons.arrow_forward_ios, size: 10, color: AppTheme.primaryGreen),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),

              // Horizontal Swipeable Carousel of Station Cards
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: stations.length,
                  onPageChanged: (index) {
                    widget.appState.selectStation(stations[index]);
                  },
                  itemBuilder: (context, index) {
                    final station = stations[index];
                    return _buildStationCarouselCard(station);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStationCarouselCard(ChargingStation station) {
    final hasAvailable = station.availablePorts > 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: station.isPlugMitraOwned ? AppTheme.borderGreen : AppTheme.borderLight,
          width: station.isPlugMitraOwned ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top Mini Row: Operator Badge & Guns Free
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: station.isPlugMitraOwned
                      ? AppTheme.lightGreenBg
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      station.isPlugMitraOwned ? Icons.stars : Icons.verified,
                      size: 11,
                      color: station.isPlugMitraOwned ? AppTheme.primaryGreen : AppTheme.textSecondary,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      station.isPlugMitraOwned ? 'PlugMitra Official Hub' : station.operator,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: station.isPlugMitraOwned ? AppTheme.primaryGreen : AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: hasAvailable ? AppTheme.lightGreenBg : const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${station.availablePorts}/${station.totalPorts} Guns Free',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: hasAvailable ? AppTheme.primaryGreen : AppTheme.coralRed,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Main Row: Thumbnail + Info + View Button
          InkWell(
            onTap: () => _openStationDetail(station),
            borderRadius: BorderRadius.circular(10),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 48,
                    height: 48,
                    color: AppTheme.lightGreenBg,
                    child: const Icon(Icons.ev_station, color: AppTheme.primaryGreen, size: 26),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        station.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            '${station.distanceKm} km',
                            style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                          ),
                          const Text(' • ', style: TextStyle(color: AppTheme.textMuted)),
                          Text(
                            '₹${station.effectiveMemberTariff.toStringAsFixed(0)}/kWh',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          if (station.isPlugMitraOwned) ...[
                            const SizedBox(width: 3),
                            const Text(
                              '(15% Off)',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primaryGreen,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${station.isFastCharger ? "DC Fast" : "AC"} (${station.maxSpeedKw.toInt()} kW)',
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('View', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                      SizedBox(width: 2),
                      Icon(Icons.chevron_right, color: Colors.white, size: 14),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 📋 SCREEN 7: Station List ("Nearby Stations")
  Widget _buildListScreenView(List<ChargingStation> stations) {
    if (stations.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.ev_station_outlined, size: 48, color: AppTheme.textMuted),
            SizedBox(height: 12),
            Text(
              'No EV stations found',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 15),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(18, 6, 18, 100),
      itemCount: stations.length,
      itemBuilder: (context, index) {
        final station = stations[index];
        return StationCard(
          station: station,
          onTap: () => _openStationDetail(station),
          onBookSlot: () {
            widget.appState.selectStation(station);
            widget.appState.setTabIndex(1);
          },
          onQuickCharge: () {
            widget.appState.startChargingSession(
              station: station,
              connector: station.connectors.first,
            );
          },
        );
      },
    );
  }

  Widget _buildViewToggleItem({
    required String title,
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.lightGreenBg : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 14,
              color: isActive ? AppTheme.primaryGreen : AppTheme.textMuted,
            ),
            const SizedBox(width: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? AppTheme.primaryGreen : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showVoiceSearchDialog(BuildContext context, AppState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => VoiceCopilotSheet(appState: widget.appState),
    );
  }

  void _openAdvancedFilters(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AdvancedFilterSheet(appState: widget.appState),
    );
  }

  void _openVehicleSwitcher(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.borderLight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Switch Garage Vehicle',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 4),
              const Text(
                'Chargers and compatible ports will dynamically adapt to the active EV.',
                style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 16),
              ...widget.appState.vehicles.asMap().entries.map((entry) {
                final index = entry.key;
                final veh = entry.value;
                final isSelected = widget.appState.selectedVehicleIndex == index;

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.lightGreenBg : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? AppTheme.primaryGreen : AppTheme.borderLight,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.primaryGreen : Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        veh.category == VehicleCategory.twoWheeler
                            ? Icons.two_wheeler
                            : veh.category == VehicleCategory.commercialTruck
                                ? Icons.local_shipping
                                : Icons.electric_car,
                        color: isSelected ? Colors.white : AppTheme.primaryGreen,
                        size: 22,
                      ),
                    ),
                    title: Text(
                      veh.fullName,
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                    ),
                    subtitle: Text(
                      '${veh.registrationNumber} • ${veh.connectorType} • ${veh.currentSocPercent.toInt()}% SoC',
                      style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle, color: AppTheme.primaryGreen, size: 22)
                        : const Icon(Icons.radio_button_off, color: AppTheme.textMuted, size: 22),
                    onTap: () {
                      widget.appState.selectVehicle(index);
                      Navigator.of(ctx).pop();
                    },
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
