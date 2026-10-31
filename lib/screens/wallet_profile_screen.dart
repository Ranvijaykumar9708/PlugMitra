import 'package:flutter/material.dart';
import '../models/vehicle.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'profile_setup_screen.dart';
import '../widgets/tax_invoice_dialog.dart';
import '../widgets/vip_membership_sheet.dart';
import '../widgets/mitra_rescue_sheet.dart';
import '../widgets/fleet_mitra_sheet.dart';
import '../widgets/tariff_scheduler_dialog.dart';
import '../widgets/battery_doctor_dialog.dart';
import '../widgets/battery_swap_sheet.dart';
import '../widgets/valet_robocharge_sheet.dart';
import '../widgets/v2g_monetization_sheet.dart';
import '../widgets/carbon_marketplace_sheet.dart';
import '../widgets/mitra_shield_dialog.dart';
import '../widgets/home_sync_sheet.dart';
import '../widgets/p2p_sharing_sheet.dart';
import '../widgets/highway_corridor_dialog.dart';
import '../widgets/common/language_switcher_dialog.dart';

class WalletProfileScreen extends StatefulWidget {
  final AppState appState;

  const WalletProfileScreen({super.key, required this.appState});

  @override
  State<WalletProfileScreen> createState() => _WalletProfileScreenState();
}

class _WalletProfileScreenState extends State<WalletProfileScreen> {
  int _selectedHistoryFilter = 1; // 0: All, 1: Completed, 2: Upcoming
  int _activeTopTab = 0; // 0: Charging History (Screen 14), 1: Wallet & Garage
  double _dailyCommuteKm = 40.0;

  // Mock history records matching Screen 14 of the mockup board
  final List<Map<String, dynamic>> _mockHistory = [
    {
      'station': 'GreenCharge Station',
      'date': '24 Oct 2026 • 24.8 kWh',
      'amount': '₹356.00',
      'status': 'Completed',
    },
    {
      'station': 'ChargePoint Hub',
      'date': '18 Oct 2026 • 18.2 kWh',
      'amount': '₹280.00',
      'status': 'Completed',
    },
    {
      'station': 'EV Power Zone',
      'date': '12 Oct 2026 • 32.1 kWh',
      'amount': '₹510.00',
      'status': 'Completed',
    },
    {
      'station': 'ElectroSpot',
      'date': '05 Oct 2026 • 15.6 kWh',
      'amount': '₹235.00',
      'status': 'Completed',
    },
  ];

  void _showTopUpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Top Up Mitra Wallet', style: TextStyle(fontWeight: FontWeight.w800)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Instant wallet balance for frictionless RFID tap & plug charging across India.',
                style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [500, 1000, 2000].map((amt) {
                  return ElevatedButton(
                    onPressed: () {
                      widget.appState.addWalletBalance(amt.toDouble());
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Added ₹$amt via UPI AutoPay! ⚡'),
                          backgroundColor: AppTheme.primaryGreen,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.lightGreenBg,
                      foregroundColor: AppTheme.primaryGreen,
                      side: const BorderSide(color: AppTheme.primaryGreen),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: Text('₹$amt', style: const TextStyle(fontWeight: FontWeight.w700)),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: AppTheme.textSecondary)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final vehicle = widget.appState.selectedVehicle;

    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          _activeTopTab == 0 ? 'Charging History' : 'Profile & Wallet',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.language_rounded, color: AppTheme.primaryGreen),
            tooltip: 'Language / भाषा',
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const LanguageSwitcherDialog(),
              );
            },
          ),
          IconButton(
            icon: Icon(
              _activeTopTab == 0 ? Icons.account_circle_outlined : Icons.history,
              color: AppTheme.primaryGreen,
            ),
            tooltip: _activeTopTab == 0 ? 'Switch to Profile' : 'Switch to History',
            onPressed: () {
              setState(() {
                _activeTopTab = _activeTopTab == 0 ? 1 : 0;
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: _activeTopTab == 0 ? _buildHistoryScreen() : _buildProfileWalletScreen(vehicle),
      ),
    );
  }

  // 📋 SCREEN 14: Charging History (Exact replica from design board)
  Widget _buildHistoryScreen() {
    return Column(
      children: [
        // Filter Tabs: All | Completed | Upcoming
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 10),
          child: Row(
            children: [
              _buildFilterTab(0, 'All'),
              const SizedBox(width: 8),
              _buildFilterTab(1, 'Completed'),
              const SizedBox(width: 8),
              _buildFilterTab(2, 'Upcoming'),
            ],
          ),
        ),

        // History List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(18, 6, 18, 100),
            itemCount: _mockHistory.length,
            itemBuilder: (context, index) {
              final item = _mockHistory[index];
              return InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => TaxInvoiceDialog(historyItem: item),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.borderLight),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Green Bolt Icon Circle (Screen 14)
                      Container(
                        width: 44,
                        height: 44,
                        decoration: const BoxDecoration(
                          color: AppTheme.lightGreenBg,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.bolt, color: AppTheme.primaryGreen, size: 24),
                      ),
                      const SizedBox(width: 14),

                      // Station Name & Date
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['station'] as String,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              item['date'] as String,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              item['amount'] as String,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Status Pill & View Invoice prompt
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.lightGreenBg,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              item['status'] as String,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primaryGreen,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.receipt_long, size: 12, color: AppTheme.primaryGreen),
                              SizedBox(width: 3),
                              Text(
                                'Invoice',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primaryGreen,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterTab(int index, String label) {
    final isSelected = _selectedHistoryFilter == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedHistoryFilter = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryGreen : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.primaryGreen : AppTheme.borderLight,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }

  // 👤 SCREEN 5 / Wallet & EV Garage Management
  Widget _buildProfileWalletScreen(EVVehicle vehicle) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Wallet Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryGreen.withOpacity(0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'PlugMitra FastWallet',
                      style: TextStyle(fontSize: 13, color: Colors.white70, fontWeight: FontWeight.w600),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.flash_on, size: 12, color: Colors.white),
                          SizedBox(width: 2),
                          Text('Auto-Pay Ready', style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  '₹${widget.appState.walletBalance.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _showTopUpDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppTheme.primaryGreen,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Add Money via UPI', style: TextStyle(fontWeight: FontWeight.w800)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 👑 PlugMitra Black VIP Club Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: widget.appState.isVipMember ? const Color(0xFFFFD700) : Colors.white12,
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.workspace_premium, color: Color(0xFFFFD700), size: 22),
                        const SizedBox(width: 8),
                        Text(
                          widget.appState.isVipMember ? 'PlugMitra Black VIP Active' : 'Join PlugMitra Black VIP Club',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD700).withOpacity(0.18),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        widget.appState.isVipMember ? '25% OFF' : 'UPGRADE',
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFFFFD700)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  widget.appState.isVipMember
                      ? 'Enjoy 25% super-tariff discount, 3-hour priority reservations, and executive lounge access.'
                      : 'Unlock 25% tariff savings across India, executive lounges & laser-engraved metal RFID card.',
                  style: const TextStyle(fontSize: 12, color: Colors.white70, height: 1.3),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => VipMembershipSheet(appState: widget.appState),
                      ).then((_) => setState(() {}));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFD700),
                      foregroundColor: Colors.black,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      widget.appState.isVipMember ? 'Manage VIP Membership' : 'Join PlugMitra Black VIP',
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ⚡ Elite Services Quick Bar: Fleet Mitra & Mitra Rescue SOS & ToD Saver
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => FleetMitraSheet(appState: widget.appState),
                    );
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppTheme.borderLight),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.local_shipping_outlined, color: Colors.blueAccent, size: 16),
                        SizedBox(width: 4),
                        Text(
                          'Fleet Mitra',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: AppTheme.textPrimary),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => MitraRescueSheet(appState: widget.appState),
                    );
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppTheme.borderLight),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.emergency_outlined, color: Colors.redAccent, size: 16),
                        SizedBox(width: 4),
                        Text(
                          'Rescue SOS',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: AppTheme.textPrimary),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => TariffSchedulerDialog(appState: widget.appState),
                    );
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppTheme.borderLight),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.nightlight_round, color: AppTheme.primaryGreen, size: 16),
                        SizedBox(width: 4),
                        Text(
                          'ToD Saver',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: AppTheme.textPrimary),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ⚡ V2G Grid Sell Earnings Banner
          InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => V2gMonetizationSheet(appState: widget.appState),
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.electricMint.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.bolt_rounded, color: AppTheme.electricMint, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'V2G Grid Monetization',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.electricMint,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                '₹18.50/kWh',
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 9),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Sell excess battery power back to grid & earn up to ₹420/day',
                          style: TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white54, size: 14),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 💎 Section 1: Smart Mobility & Hardware
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Smart Mobility & IoT', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
              Text('Next-Gen', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.primaryGreen)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildProfileServiceCard(
                icon: Icons.sync_rounded,
                iconColor: AppTheme.electricMint,
                title: '60s Swap Bay',
                subtitle: 'Instant 100% SoC pack',
                onTap: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => BatterySwapSheet(appState: widget.appState),
                ),
              ),
              const SizedBox(width: 8),
              _buildProfileServiceCard(
                icon: Icons.car_rental_rounded,
                iconColor: const Color(0xFFC084FC),
                title: 'Valet Concierge',
                subtitle: 'Charge to 80% & park',
                onTap: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => ValetRobochargeSheet(appState: widget.appState),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildProfileServiceCard(
                icon: Icons.solar_power_rounded,
                iconColor: const Color(0xFFF59E0B),
                title: 'Home-Sync Solar',
                subtitle: 'Rooftop solar IoT',
                onTap: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => HomeSyncSheet(appState: widget.appState),
                ),
              ),
              const SizedBox(width: 8),
              _buildProfileServiceCard(
                icon: Icons.handshake_rounded,
                iconColor: const Color(0xFF10B981),
                title: 'P2P Wallbox Host',
                subtitle: 'Rent home charger',
                onTap: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => P2pSharingSheet(appState: widget.appState),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 🛡️ Section 2: Health & Protection
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Battery Health & Protection', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
              Text('Certified', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF0284C7))),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildProfileServiceCard(
                icon: Icons.health_and_safety_rounded,
                iconColor: AppTheme.primaryGreen,
                title: 'Battery Doctor',
                subtitle: '98.2% SoH OEM Audit',
                onTap: () => showDialog(
                  context: context,
                  builder: (_) => BatteryDoctorDialog(appState: widget.appState),
                ),
              ),
              const SizedBox(width: 8),
              _buildProfileServiceCard(
                icon: Icons.shield_rounded,
                iconColor: const Color(0xFF0284C7),
                title: 'Mitra Shield',
                subtitle: 'Monsoon Zero-Dep',
                onTap: () => showDialog(
                  context: context,
                  builder: (_) => MitraShieldDialog(appState: widget.appState),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildProfileServiceCard(
                icon: Icons.eco_rounded,
                iconColor: const Color(0xFF10B981),
                title: '${widget.appState.greenCarbonTokens.toStringAsFixed(0)} Tokens',
                subtitle: 'Trade & FASTag store',
                onTap: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => CarbonMarketplaceSheet(appState: widget.appState),
                ),
              ),
              const SizedBox(width: 8),
              _buildProfileServiceCard(
                icon: Icons.add_road_rounded,
                iconColor: const Color(0xFF818CF8),
                title: 'Highway Corridor',
                subtitle: 'Expressway fallback',
                onTap: () => showDialog(
                  context: context,
                  builder: (_) => HighwayCorridorDialog(appState: widget.appState),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Active Vehicle Box & Switcher
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Active Vehicle', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
              TextButton.icon(
                onPressed: () => _openVehicleSwitcher(context),
                icon: const Icon(Icons.swap_horiz_rounded, size: 18, color: AppTheme.primaryGreen),
                label: const Text('Switch EV', style: TextStyle(fontWeight: FontWeight.w700, color: AppTheme.primaryGreen, fontSize: 13)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.borderLight),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(color: AppTheme.lightGreenBg, shape: BoxShape.circle),
                  child: Icon(
                    vehicle.category == VehicleCategory.twoWheeler
                        ? Icons.two_wheeler
                        : vehicle.category == VehicleCategory.commercialTruck
                            ? Icons.local_shipping
                            : Icons.electric_car,
                    color: AppTheme.primaryGreen,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(vehicle.fullName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                      const SizedBox(height: 2),
                      Text('${vehicle.registrationNumber} • ${vehicle.batteryCapacityKwh.toInt()} kWh • ${vehicle.connectorType}', style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.tune_rounded, size: 20, color: AppTheme.textSecondary),
                  tooltip: 'Vehicle Specs',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const ProfileSetupScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 💳 Virtual PlugMitra Tap-to-Charge RFID Card
          const Text('Virtual RFID & Plug & Charge', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.4), width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryGreen.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.bolt, color: AppTheme.electricMint, size: 18),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'PlugMitra Keycard',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const Icon(Icons.contactless_rounded, color: AppTheme.electricMint, size: 26),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'PM-RFID-8921-IN',
                  style: TextStyle(
                    fontFamily: 'Courier',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 3,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'LINKED VEHICLE',
                          style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: Colors.white54, letterSpacing: 0.8),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          vehicle.fullName,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: _simulateRfidTap,
                      icon: const Icon(Icons.sensors_rounded, size: 16),
                      label: const Text('Tap to Charge', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.electricMint,
                        foregroundColor: Colors.black,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // AutoCharge (ISO 15118 Plug & Charge) Toggle
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.borderLight),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: widget.appState.isAutoChargeEnabled ? AppTheme.lightGreenBg : const Color(0xFFF1F5F9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.electric_bolt_rounded,
                    color: widget.appState.isAutoChargeEnabled ? AppTheme.primaryGreen : AppTheme.textMuted,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'AutoCharge (Plug & Charge)',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.appState.isAutoChargeEnabled
                            ? 'Plug gun into car to authenticate automatically.'
                            : 'Enable seamless charging without QR scanning.',
                        style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                      ),
                    ],
                  ),
                ),
                Switch.adaptive(
                  value: widget.appState.isAutoChargeEnabled,
                  activeColor: AppTheme.primaryGreen,
                  onChanged: (val) {
                    widget.appState.toggleAutoCharge(val);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(val
                            ? 'AutoCharge enabled for ${vehicle.fullName}! ⚡'
                            : 'AutoCharge disabled.'),
                        backgroundColor: val ? AppTheme.primaryGreen : AppTheme.cardDark,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),

          // ⚡ Petrol vs. EV Fuel Savings & Green Impact Calculator
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.borderLight),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: AppTheme.lightGreenBg,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.savings_outlined, color: AppTheme.primaryGreen, size: 20),
                        ),
                        const SizedBox(width: 10),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'EV vs Petrol Savings',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            Text(
                              'Real-time cost & carbon calculator',
                              style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.lightGreenBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Save 83%',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.primaryGreen,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Commute Slider
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Daily Commute',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      '${_dailyCommuteKm.round()} km / day',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.primaryGreen,
                      ),
                    ),
                  ],
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppTheme.primaryGreen,
                    inactiveTrackColor: AppTheme.lightGreenBg,
                    thumbColor: AppTheme.primaryGreen,
                    overlayColor: AppTheme.primaryGreen.withOpacity(0.12),
                    trackHeight: 4,
                  ),
                  child: Slider(
                    value: _dailyCommuteKm,
                    min: 10,
                    max: 120,
                    divisions: 22,
                    onChanged: (val) {
                      setState(() => _dailyCommuteKm = val);
                    },
                  ),
                ),
                const SizedBox(height: 12),

                // Metrics comparison row
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppTheme.borderLight),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Petrol Cost/Mo',
                              style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '₹${(_dailyCommuteKm * 30 * 7.50).round()}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFFE53935),
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text('₹7.50 / km', style: TextStyle(fontSize: 10, color: AppTheme.textMuted)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppTheme.borderLight),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'PlugMitra EV/Mo',
                              style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '₹${(_dailyCommuteKm * 30 * 1.25).round()}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.primaryGreen,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text('₹1.25 / km', style: TextStyle(fontSize: 10, color: AppTheme.textMuted)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.lightGreenBg,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'You Pocket/Mo',
                              style: TextStyle(fontSize: 11, color: AppTheme.primaryGreen, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '₹${(_dailyCommuteKm * 30 * 6.25).round()}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: AppTheme.primaryGreen,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text('Pure Profit', style: TextStyle(fontSize: 10, color: AppTheme.primaryGreen)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Green impact banner
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.forest_rounded, color: Color(0xFF2E7D32), size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Annual Savings: ₹${((_dailyCommuteKm * 30 * 6.25) * 12).round()}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1B5E20),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Reduces ${(_dailyCommuteKm * 30 * 0.14).toStringAsFixed(0)} kg CO₂/mo (≈ ${((_dailyCommuteKm * 30 * 0.14) / 1.8).round()} trees/year)',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF2E7D32),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 🛠️ Reported Station Issues (Crowdsourced EV Community)
          if (widget.appState.reportedIssues.isNotEmpty) ...[
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'My Reported Station Issues',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${widget.appState.reportedIssues.length} Active',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.deepOrange),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...widget.appState.reportedIssues.reversed.map((issue) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.borderLight),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.report_problem_rounded, color: Colors.orange, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            issue['stationName'] as String,
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppTheme.textPrimary),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${issue['category']}: ${issue['description']}',
                            style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Under Review',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
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
                'Select vehicle to adapt charging rates, range, and compatible guns.',
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
                      setState(() {});
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

  void _simulateRfidTap() {
    final nav = Navigator.of(context, rootNavigator: true);
    final messenger = ScaffoldMessenger.of(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF0F172A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: AppTheme.primaryGreen.withOpacity(0.5)),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.contactless_rounded,
                  color: AppTheme.electricMint,
                  size: 48,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'RFID Keycard Detected',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'Card: PM-RFID-8921-IN\nHandshake with OCPP 2.0.1 Charger...',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.white70, height: 1.4),
              ),
              const SizedBox(height: 22),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.electricMint),
              ),
              const SizedBox(height: 14),
            ],
          ),
        );
      },
    );

    Future.delayed(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      nav.pop(); // close dialog
      final vehicle = widget.appState.selectedVehicle;
      final station = widget.appState.allStations.firstWhere(
        (s) => s.supportsCategory(vehicle.category),
        orElse: () => widget.appState.allStations.first,
      );
      final connector = station.connectors.firstWhere(
        (c) => c.compatibleCategories.contains(vehicle.category) && c.isAvailable,
        orElse: () => station.connectors.first,
      );

      widget.appState.startChargingSession(
        station: station,
        connector: connector,
      );
      widget.appState.setTabIndex(3); // Switch to live charging screen
      messenger.showSnackBar(
        SnackBar(
          content: Text('⚡ RFID Authenticated! Charging ${vehicle.fullName} at ${station.name}'),
          backgroundColor: AppTheme.primaryGreen,
        ),
      );
    });
  }

  Widget _buildProfileServiceCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.borderLight),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11, color: AppTheme.textPrimary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 9, color: AppTheme.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

