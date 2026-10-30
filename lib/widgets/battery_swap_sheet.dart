import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

class BatterySwapSheet extends StatefulWidget {
  final AppState appState;

  const BatterySwapSheet({super.key, required this.appState});

  @override
  State<BatterySwapSheet> createState() => _BatterySwapSheetState();
}

class _BatterySwapSheetState extends State<BatterySwapSheet> {
  bool _isSwapping = false;
  int _swapStep = 0;

  void _startSwapSimulation() {
    setState(() {
      _isSwapping = true;
      _swapStep = 1;
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!mounted) return;
      setState(() => _swapStep = 2);
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (!mounted) return;
        setState(() => _swapStep = 3);
        Future.delayed(const Duration(milliseconds: 1200), () {
          if (!mounted) return;
          widget.appState.performBatterySwap();
          setState(() {
            _swapStep = 4;
            _isSwapping = false;
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final vehicle = widget.appState.selectedVehicle;

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

            // Title Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.electricMint.withOpacity(0.18),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.sync_rounded, color: AppTheme.electricMint, size: 24),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '60-Second Battery Swap',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Automated BaaS Exchange Cabinet',
                          style: TextStyle(fontSize: 12, color: Colors.white60),
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

            // Cabinet Location & Readiness
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.cardDark,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.electricMint.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Cabinet #08 • Cyber Hub Gurugram',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGreen.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text('ONLINE • 60s', style: TextStyle(fontSize: 10, color: AppTheme.electricMint, fontWeight: FontWeight.w800)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildCabinetMetric('Packs Ready', '${widget.appState.availableSwapPacks}/10', Icons.battery_charging_full),
                      _buildCabinetMetric('Swap Time', '58 Secs', Icons.timer),
                      _buildCabinetMetric('Fee', '₹95 / pack', Icons.savings_outlined),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Compatible with Ather 450, Ola S1, Mahindra Treo, Euler & Tata Ace EV.',
                    style: TextStyle(fontSize: 11, color: Colors.white60),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Visual Cabinet Grid (10 Battery Slots)
            const Text(
              'Live Cabinet Battery Bay',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
            ),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 10,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                childAspectRatio: 1.1,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, idx) {
                final isCharged = idx < widget.appState.availableSwapPacks;
                return Container(
                  decoration: BoxDecoration(
                    color: isCharged ? AppTheme.primaryGreen.withOpacity(0.15) : Colors.white10,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isCharged ? AppTheme.electricMint.withOpacity(0.5) : Colors.white12,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isCharged ? Icons.battery_full : Icons.battery_alert,
                        size: 20,
                        color: isCharged ? AppTheme.electricMint : Colors.white30,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '#${idx + 1}',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: isCharged ? Colors.white : Colors.white38,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // Swap Progress or Action
            if (_isSwapping) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.cardDark,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.electricMint),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.electricMint),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _swapStep == 1
                                ? '1/3 Depositing depleted battery...'
                                : _swapStep == 2
                                    ? '2/3 Authenticating BaaS Account...'
                                    : '3/3 Ejecting 100% fresh pack from Slot 7...',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
                          ),
                          const SizedBox(height: 2),
                          const Text('Automated robotic door opening', style: TextStyle(fontSize: 11, color: AppTheme.electricMint)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ] else if (_swapStep == 4) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF065F46),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: AppTheme.electricMint, size: 26),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Battery Swapped in 52 Seconds! ⚡',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white),
                          ),
                          Text(
                            '${vehicle.fullName} battery is now 100% full!',
                            style: const TextStyle(fontSize: 11, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isSwapping ? null : _startSwapSimulation,
                icon: const Icon(Icons.qr_code_scanner, color: Colors.black, size: 20),
                label: Text(
                  _swapStep == 4 ? 'Swap Again' : 'Scan QR & Swap Battery (60 Secs)',
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.electricMint,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCabinetMetric(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.electricMint, size: 20),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.white54)),
      ],
    );
  }
}
