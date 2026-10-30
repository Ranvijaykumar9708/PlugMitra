import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

class V2gMonetizationSheet extends StatefulWidget {
  final AppState appState;

  const V2gMonetizationSheet({super.key, required this.appState});

  @override
  State<V2gMonetizationSheet> createState() => _V2gMonetizationSheetState();
}

class _V2gMonetizationSheetState extends State<V2gMonetizationSheet> {
  bool _isV2hHomeBackup = true;

  @override
  Widget build(BuildContext context) {
    final isV2gActive = widget.appState.isV2gActive;
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

            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00E599), Color(0xFF00D2FF)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.currency_rupee_rounded, color: Colors.black, size: 24),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'V2G Grid Monetization',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Earn Money by Feeding Power to Grid',
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

            // Live Earnings Telemetry Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF064E3B), Color(0xFF065F46)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppTheme.electricMint.withOpacity(0.4)),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.electricMint.withOpacity(0.12),
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
                        'TODAY\'S V2G INCOME',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white70, letterSpacing: 1),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          isV2gActive ? 'FEEDING GRID ⚡' : 'STANDBY',
                          style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '₹${widget.appState.v2gEarningsToday.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMetricColumn('Grid Buyback Rate', '₹18.50/kWh', Colors.white),
                      _buildMetricColumn('Export Power', '11.0 kW AC', AppTheme.electricMint),
                      _buildMetricColumn('Reserve Limit', '40% Min SoC', Colors.white70),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Bi-Directional V2G Switch
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.cardDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.cardBorder),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isV2gActive ? AppTheme.primaryGreen.withOpacity(0.2) : Colors.white10,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.swap_vertical_circle,
                      color: isV2gActive ? AppTheme.electricMint : Colors.white54,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Peak Hour Grid Export',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Sell surplus battery energy to Discom during 6 PM - 10 PM peak hours.',
                          style: const TextStyle(fontSize: 11, color: Colors.white60),
                        ),
                      ],
                    ),
                  ),
                  Switch.adaptive(
                    value: isV2gActive,
                    activeColor: AppTheme.electricMint,
                    onChanged: (val) {
                      widget.appState.toggleV2g(val);
                      setState(() {});
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(val
                              ? '⚡ V2G Feed-in Active: Selling power at ₹18.50/kWh!'
                              : 'V2G Power Export paused.'),
                          backgroundColor: val ? AppTheme.primaryGreen : AppTheme.cardDark,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // V2H Home Backup Switch
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.cardDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.cardBorder),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _isV2hHomeBackup ? Colors.blue.withOpacity(0.2) : Colors.white10,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.home_outlined,
                      color: _isV2hHomeBackup ? Colors.lightBlueAccent : Colors.white54,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'V2H Emergency Home Backup',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Powers your house AC, lights & fridge for 48 hours during grid blackouts.',
                          style: TextStyle(fontSize: 11, color: Colors.white60),
                        ),
                      ],
                    ),
                  ),
                  Switch.adaptive(
                    value: _isV2hHomeBackup,
                    activeColor: Colors.lightBlueAccent,
                    onChanged: (val) {
                      setState(() => _isV2hHomeBackup = val);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Vehicle Source Box
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'POWER SOURCE',
                        style: TextStyle(fontSize: 10, color: Colors.white54, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        vehicle.fullName,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ],
                  ),
                  Text(
                    '${vehicle.currentSocPercent.toInt()}% Battery Available',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppTheme.electricMint),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricColumn(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: color)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.white60)),
      ],
    );
  }
}
