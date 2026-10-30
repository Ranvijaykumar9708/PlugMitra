import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

class FleetMitraSheet extends StatefulWidget {
  final AppState appState;

  const FleetMitraSheet({super.key, required this.appState});

  @override
  State<FleetMitraSheet> createState() => _FleetMitraSheetState();
}

class _FleetMitraSheetState extends State<FleetMitraSheet> {
  final List<Map<String, dynamic>> _fleetVehicles = [
    {
      'name': 'Tata Ace EV Cargo #04',
      'plate': 'DL 01 EV 1004',
      'driver': 'Ramesh Kumar',
      'soc': 82,
      'status': 'In Transit (Gurugram Hub)',
      'isCharging': false,
    },
    {
      'name': 'Tata Ultra T.7 Heavy Truck',
      'plate': 'UP 16 EV 9081',
      'driver': 'Mohd. Salim',
      'soc': 38,
      'status': 'Charging at CyberCity Hub',
      'isCharging': true,
    },
    {
      'name': 'Euler HiLoad 3W Cargo',
      'plate': 'HR 26 EV 4412',
      'driver': 'Amit Verma',
      'soc': 64,
      'status': 'Idle at Delivery Depot',
      'isCharging': false,
    },
    {
      'name': 'Ather 450X Delivery #12',
      'plate': 'DL 04 EV 7721',
      'driver': 'Deepak Jha',
      'soc': 95,
      'status': 'Ready for Route',
      'isCharging': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Top Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.local_shipping_rounded, color: Colors.blueAccent, size: 24),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Fleet Mitra Enterprise',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Commercial Fleet & Multi-Driver Portal',
                          style: TextStyle(fontSize: 11, color: Colors.white60),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white54),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Corporate Fleet Wallet Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.2),
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
                        'CENTRAL FLEET FASTWALLET',
                        style: TextStyle(fontSize: 11, color: Colors.white70, fontWeight: FontWeight.w700, letterSpacing: 1),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text('28 Active EVs', style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '₹${widget.appState.fleetWalletBalance.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Added ₹10,000 Corporate Credit via NetBanking! ⚡'),
                                backgroundColor: Color(0xFF2563EB),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF1E3A8A),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text('Top Up Fleet Pool', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      OutlinedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Exported Consolidated Monthly GST Tax Sheet! 📊'),
                              backgroundColor: Color(0xFF1E293B),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white60),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('GST Report', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Live Fleet Fleet Telemetry List
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Live Fleet Roster',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white),
                ),
                TextButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Opening Commercial EV Registration Portal...'),
                        backgroundColor: Color(0xFF10B981),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add, size: 16, color: AppTheme.electricMint),
                  label: const Text('Add EV', style: TextStyle(color: AppTheme.electricMint, fontWeight: FontWeight.w700, fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 8),

            ..._fleetVehicles.map((v) {
              final isCharging = v['isCharging'] as bool;
              final soc = v['soc'] as int;

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.cardDark,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isCharging ? AppTheme.electricMint.withOpacity(0.5) : AppTheme.cardBorder,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isCharging ? AppTheme.primaryGreen.withOpacity(0.2) : const Color(0xFF1E293B),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isCharging ? Icons.bolt : Icons.local_shipping_outlined,
                        color: isCharging ? AppTheme.electricMint : Colors.white70,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            v['name'] as String,
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Colors.white),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${v['plate']} • Driver: ${v['driver']}',
                            style: const TextStyle(fontSize: 11, color: Colors.white60),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            v['status'] as String,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: isCharging ? AppTheme.electricMint : AppTheme.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '$soc%',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: soc > 50 ? AppTheme.electricMint : Colors.orange,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text('Battery', style: TextStyle(fontSize: 9, color: Colors.white54)),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
