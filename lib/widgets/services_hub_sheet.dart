import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'battery_swap_sheet.dart';
import 'elevation_route_planner_dialog.dart';
import 'battery_doctor_dialog.dart';
import 'valet_robocharge_sheet.dart';
import 'mitra_rescue_sheet.dart';
import 'tariff_scheduler_dialog.dart';
import 'home_sync_sheet.dart';
import 'p2p_sharing_sheet.dart';
import 'highway_corridor_dialog.dart';
import 'carbon_marketplace_sheet.dart';
import 'mitra_shield_dialog.dart';
import 'v2g_monetization_sheet.dart';

class ServicesHubSheet extends StatefulWidget {
  final AppState appState;

  const ServicesHubSheet({super.key, required this.appState});

  @override
  State<ServicesHubSheet> createState() => _ServicesHubSheetState();
}

class _ServicesHubSheetState extends State<ServicesHubSheet> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.88),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primaryGreen, AppTheme.electricMint],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.auto_awesome, color: Colors.black, size: 22),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mitra Services & Innovation Hub',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18),
                    ),
                    Text(
                      '12 Next-Gen EV Mobility & Smart Energy Solutions',
                      style: TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Category Tabs
          Container(
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: AppTheme.primaryGreen,
                borderRadius: BorderRadius.circular(10),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white60,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              tabs: const [
                Tab(text: '⚡ Charging & Power'),
                Tab(text: '🛡️ Care & Rescue'),
                Tab(text: '💎 Smart & Earn'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildChargingTab(context),
                _buildCareTab(context),
                _buildSmartTab(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChargingTab(BuildContext context) {
    return ListView(
      children: [
        _buildServiceTile(
          context: context,
          icon: Icons.sync_rounded,
          iconColor: AppTheme.electricMint,
          title: '60-Second Battery Swap',
          subtitle: 'Instant battery pack replacement at automated cabinet. Zero queue waiting.',
          badge: 'Ready in 60s',
          badgeColor: AppTheme.electricMint,
          onTap: () {
            Navigator.pop(context);
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => BatterySwapSheet(appState: widget.appState),
            );
          },
        ),
        _buildServiceTile(
          context: context,
          icon: Icons.solar_power_rounded,
          iconColor: const Color(0xFFFBBF24),
          title: 'Mitra Home-Sync™ Solar IoT',
          subtitle: 'Charge EV exclusively from free rooftop solar. Smart dynamic load balancer.',
          badge: '₹0 Solar Bill',
          badgeColor: const Color(0xFFFBBF24),
          onTap: () {
            Navigator.pop(context);
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => HomeSyncSheet(appState: widget.appState),
            );
          },
        ),
        _buildServiceTile(
          context: context,
          icon: Icons.nightlight_round,
          iconColor: const Color(0xFF818CF8),
          title: 'ToD Smart Off-Peak Scheduler',
          subtitle: 'Plug gun now, charging starts automatically at off-peak rates (11 PM - 6 AM).',
          badge: 'Save ₹340',
          badgeColor: const Color(0xFF818CF8),
          onTap: () {
            Navigator.pop(context);
            showDialog(
              context: context,
              builder: (_) => TariffSchedulerDialog(appState: widget.appState),
            );
          },
        ),
        _buildServiceTile(
          context: context,
          icon: Icons.terrain_rounded,
          iconColor: const Color(0xFF38BDF8),
          title: 'AI Mountain Elevation Planner',
          subtitle: 'Computes hill climb drag (-28%) and downhill regenerative energy harvest (+14%).',
          badge: 'Tesla-Grade',
          badgeColor: const Color(0xFF38BDF8),
          onTap: () {
            Navigator.pop(context);
            showDialog(
              context: context,
              builder: (_) => ElevationRoutePlannerDialog(appState: widget.appState),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCareTab(BuildContext context) {
    return ListView(
      children: [
        _buildServiceTile(
          context: context,
          icon: Icons.emergency_rounded,
          iconColor: Colors.redAccent,
          title: 'Mitra Rescue SOS (Mobile DC Van)',
          subtitle: 'Stranded with 0% battery? 30kW mobile DC rapid charger dispatched to your GPS.',
          badge: '14 Mins ETA',
          badgeColor: Colors.redAccent,
          onTap: () {
            Navigator.pop(context);
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => MitraRescueSheet(appState: widget.appState),
            );
          },
        ),
        _buildServiceTile(
          context: context,
          icon: Icons.health_and_safety_rounded,
          iconColor: const Color(0xFF34D399),
          title: 'Battery Doctor™ Diagnostics',
          subtitle: 'OEM-grade 98.2% State of Health (SoH) test & certified resale audit report.',
          badge: '+₹1,20,000 Resale',
          badgeColor: const Color(0xFF34D399),
          onTap: () {
            Navigator.pop(context);
            showDialog(
              context: context,
              builder: (_) => BatteryDoctorDialog(appState: widget.appState),
            );
          },
        ),
        _buildServiceTile(
          context: context,
          icon: Icons.shield_rounded,
          iconColor: const Color(0xFF0284C7),
          title: 'Mitra Shield™ Zero-Dep Insurance',
          subtitle: 'Monsoon urban flood & battery pack seal breach cover with ₹0 deductible.',
          badge: 'Platinum Cover',
          badgeColor: const Color(0xFF0284C7),
          onTap: () {
            Navigator.pop(context);
            showDialog(
              context: context,
              builder: (_) => MitraShieldDialog(appState: widget.appState),
            );
          },
        ),
        _buildServiceTile(
          context: context,
          icon: Icons.car_rental_rounded,
          iconColor: const Color(0xFFC084FC),
          title: 'Mitra Valet & RoboCharge Concierge',
          subtitle: '5-star hotel & luxury mall drop-off. We charge to 80% and safely park your car.',
          badge: 'VIP Service',
          badgeColor: const Color(0xFFC084FC),
          onTap: () {
            Navigator.pop(context);
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => ValetRobochargeSheet(appState: widget.appState),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSmartTab(BuildContext context) {
    return ListView(
      children: [
        _buildServiceTile(
          context: context,
          icon: Icons.bolt_rounded,
          iconColor: AppTheme.electricMint,
          title: 'V2G (Vehicle-to-Grid) Monetization',
          subtitle: 'Sell surplus EV battery power to the grid at peak rate (₹18.50/kWh).',
          badge: 'Earn ₹420/day',
          badgeColor: AppTheme.electricMint,
          onTap: () {
            Navigator.pop(context);
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => V2gMonetizationSheet(appState: widget.appState),
            );
          },
        ),
        _buildServiceTile(
          context: context,
          icon: Icons.handshake_rounded,
          iconColor: const Color(0xFF10B981),
          title: 'Mitra P2P Community Wallbox Sharing',
          subtitle: 'Airbnb for EV chargers: Monetize your idle home charger when away at office.',
          badge: 'Host Earnings',
          badgeColor: const Color(0xFF10B981),
          onTap: () {
            Navigator.pop(context);
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => P2pSharingSheet(appState: widget.appState),
            );
          },
        ),
        _buildServiceTile(
          context: context,
          icon: Icons.add_road_rounded,
          iconColor: const Color(0xFF818CF8),
          title: 'Highway Corridor Shield Cruise',
          subtitle: 'Inter-state expressway journey: Auto-reroutes to backup hub if primary has queue.',
          badge: 'Zero Anxiety',
          badgeColor: const Color(0xFF818CF8),
          onTap: () {
            Navigator.pop(context);
            showDialog(
              context: context,
              builder: (_) => HighwayCorridorDialog(appState: widget.appState),
            );
          },
        ),
        _buildServiceTile(
          context: context,
          icon: Icons.eco_rounded,
          iconColor: const Color(0xFF34D399),
          title: 'Green Carbon Tokens & ESG Market',
          subtitle: 'Earn 1 token per 1 kWh solar charging. Sell to corporate ESG buyers for cash.',
          badge: '1 Token = ₹1.80',
          badgeColor: const Color(0xFF34D399),
          onTap: () {
            Navigator.pop(context);
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => CarbonMarketplaceSheet(appState: widget.appState),
            );
          },
        ),
      ],
    );
  }

  Widget _buildServiceTile({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String badge,
    required Color badgeColor,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: badgeColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: badgeColor.withOpacity(0.5)),
                          ),
                          child: Text(
                            badge,
                            style: TextStyle(color: badgeColor, fontWeight: FontWeight.w800, fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(color: Colors.white60, fontSize: 11, height: 1.3),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white38, size: 14),
            ],
          ),
        ),
      ),
    );
  }
}
