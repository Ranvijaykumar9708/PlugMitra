import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

class P2pSharingSheet extends StatefulWidget {
  final AppState appState;

  const P2pSharingSheet({super.key, required this.appState});

  @override
  State<P2pSharingSheet> createState() => _P2pSharingSheetState();
}

class _P2pSharingSheetState extends State<P2pSharingSheet> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late double _p2pRate;
  late bool _isListingActive;

  final List<Map<String, dynamic>> _nearbyP2pHosts = [
    {
      'host': 'Aarav Sharma (Verified Host)',
      'location': 'DLF Phase 5, Gurugram (Tower 8)',
      'distance': '350 m away',
      'charger': '11 kW Type-2 AC Wallbox',
      'price': 14.50,
      'rating': 4.9,
      'swapsCount': 34,
      'status': 'Available Now',
      'gateOtp': 'PM-DLF-4402',
    },
    {
      'host': 'Priya Sen (EV Ambassador)',
      'location': 'Magnolias Residences, Sector 42',
      'distance': '800 m away',
      'charger': '7.4 kW Type-2 / 16A 3-Pin',
      'price': 13.00,
      'rating': 5.0,
      'swapsCount': 52,
      'status': 'Available Now',
      'gateOtp': 'PM-MAG-9811',
    },
    {
      'host': 'Col. Rajesh Verma',
      'location': 'Sushant Lok 1, Block C',
      'distance': '1.2 km away',
      'charger': '7.4 kW Tata EZ Home',
      'price': 12.50,
      'rating': 4.8,
      'swapsCount': 19,
      'status': 'Booked till 9:00 PM',
      'gateOtp': 'PM-SUSH-3104',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _p2pRate = widget.appState.p2pRatePerUnit;
    _isListingActive = widget.appState.p2pListingActive;
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
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
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
                  color: const Color(0xFF10B981).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.handshake_rounded, color: Color(0xFF34D399), size: 24),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mitra P2P Community Sharing',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18),
                    ),
                    Text(
                      'Airbnb for Home EV Wallboxes & Residential Chargers',
                      style: TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Tabs
          Container(
            height: 40,
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
                Tab(text: '🏠 Host My Wallbox'),
                Tab(text: '📍 Nearby Community Hosts'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Tab views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildHostView(),
                _buildFindHostsView(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHostView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Earnings Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF064E3B), Color(0xFF065F46)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Passive Host Income', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    Icon(Icons.monetization_on_rounded, color: AppTheme.electricMint, size: 20),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '₹${widget.appState.p2pEarnings.toStringAsFixed(0)}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 28),
                ),
                const SizedBox(height: 4),
                const Text(
                  '86 kWh shared with 14 verified society neighbors this month',
                  style: TextStyle(color: Color(0xFFA7F3D0), fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Listing Active Switch
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Accepting Visiting Drivers', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                    Text('Visible on PlugMitra Community Map', style: TextStyle(color: Colors.white60, fontSize: 11)),
                  ],
                ),
                Switch(
                  value: _isListingActive,
                  activeColor: AppTheme.electricMint,
                  onChanged: (val) {
                    setState(() => _isListingActive = val);
                    widget.appState.toggleP2pListing(val);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Tariff Configurator
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('My Unit Tariff Rate', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                    Text('₹${_p2pRate.toStringAsFixed(1)} / kWh', style: const TextStyle(color: AppTheme.electricMint, fontWeight: FontWeight.w900, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Your DISCOM cost: ₹8.00/kWh • Net Profit: +₹6.50/kWh',
                  style: TextStyle(color: Colors.white60, fontSize: 11),
                ),
                Slider(
                  value: _p2pRate,
                  min: 9.0,
                  max: 20.0,
                  divisions: 22,
                  activeColor: AppTheme.electricMint,
                  inactiveColor: Colors.white12,
                  onChanged: (val) {
                    setState(() => _p2pRate = val);
                    widget.appState.updateP2pRate(val);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Smart Society Gate Pass Security
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white10),
            ),
            child: const Row(
              children: [
                Icon(Icons.shield_outlined, color: AppTheme.electricMint, size: 22),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Automated RWA Gate Security Pass',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      Text(
                        'Generates instant visitor entry QR token for apartment security guards. 100% verified KYC drivers.',
                        style: TextStyle(color: Colors.white60, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildFindHostsView() {
    return ListView.builder(
      itemCount: _nearbyP2pHosts.length,
      itemBuilder: (context, index) {
        final host = _nearbyP2pHosts[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 14,
                        backgroundColor: AppTheme.primaryGreen,
                        child: Icon(Icons.person, color: Colors.white, size: 16),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        host['host'] as String,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.electricMint.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '₹${(host['price'] as double).toStringAsFixed(2)}/kWh',
                      style: const TextStyle(color: AppTheme.electricMint, fontWeight: FontWeight.w900, fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '📍 ${host['location']} • ${host['distance']}',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                '🔌 ${host['charger']} • ⭐ ${host['rating']} (${host['swapsCount']} sessions)',
                style: const TextStyle(color: Colors.white60, fontSize: 11),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Gate PIN: ${host['gateOtp']}',
                    style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 11),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Gate Pass ${host['gateOtp']} booked for ${host['host']}!'),
                          backgroundColor: AppTheme.primaryGreen,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Book Bay Slot', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
