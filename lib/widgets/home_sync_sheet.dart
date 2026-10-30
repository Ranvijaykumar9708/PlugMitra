import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

class HomeSyncSheet extends StatefulWidget {
  final AppState appState;

  const HomeSyncSheet({super.key, required this.appState});

  @override
  State<HomeSyncSheet> createState() => _HomeSyncSheetState();
}

class _HomeSyncSheetState extends State<HomeSyncSheet> {
  late bool _solarOnly;
  late bool _loadBalancing;
  late double _currentKw;

  @override
  void initState() {
    super.initState();
    _solarOnly = widget.appState.isSolarOnlyMode;
    _loadBalancing = widget.appState.homeLoadBalancing;
    _currentKw = widget.appState.homeCurrentKw;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
                  color: const Color(0xFFF59E0B).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.solar_power_rounded, color: Color(0xFFFBBF24), size: 24),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mitra Home-Sync™ IoT',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18),
                    ),
                    Text(
                      'Smart Home Wallbox & Rooftop Solar Automation',
                      style: TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.electricMint.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.electricMint),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.wifi, color: AppTheme.electricMint, size: 12),
                    SizedBox(width: 4),
                    Text('Online', style: TextStyle(color: AppTheme.electricMint, fontWeight: FontWeight.bold, fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Live Telemetry Grid
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Wallbox Hardware', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    Text(
                      widget.appState.homeWallboxModel,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ],
                ),
                const Divider(color: Colors.white10, height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMetricCol('☀️ Solar Yield', '${widget.appState.homeSolarYieldKw} kW', const Color(0xFFFBBF24)),
                    Container(height: 30, width: 1, color: Colors.white10),
                    _buildMetricCol('⚡ Wallbox Output', '${_currentKw.toStringAsFixed(1)} kW', AppTheme.electricMint),
                    Container(height: 30, width: 1, color: Colors.white10),
                    _buildMetricCol('🛡️ MCB Headroom', '4.5 kW Safe', Colors.lightBlueAccent),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Feature 1: Rooftop Solar-Only Mode
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _solarOnly ? const Color(0xFFF59E0B).withOpacity(0.12) : const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _solarOnly ? const Color(0xFFF59E0B) : Colors.white10),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B).withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.wb_sunny_rounded, color: Color(0xFFFBBF24), size: 20),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '100% Rooftop Solar-Only Charging',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      Text(
                        'Zero grid draw. Charges car exclusively from free surplus rooftop solar power (₹0 bill).',
                        style: TextStyle(color: Colors.white60, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _solarOnly,
                  activeColor: const Color(0xFFFBBF24),
                  activeTrackColor: const Color(0xFFF59E0B).withOpacity(0.4),
                  onChanged: (val) {
                    setState(() => _solarOnly = val);
                    widget.appState.toggleSolarOnlyMode(val);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Feature 2: Smart Dynamic Load Balancing (Anti-MCB Trip)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _loadBalancing ? AppTheme.primaryGreen.withOpacity(0.12) : const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _loadBalancing ? AppTheme.primaryGreen : Colors.white10),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.speed_rounded, color: AppTheme.electricMint, size: 20),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dynamic Smart Load Balancer',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      Text(
                        'Auto-throttles charger when home AC / geyser starts. Eliminates main MCB trips.',
                        style: TextStyle(color: Colors.white60, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _loadBalancing,
                  activeColor: AppTheme.electricMint,
                  activeTrackColor: AppTheme.primaryGreen.withOpacity(0.4),
                  onChanged: (val) {
                    setState(() => _loadBalancing = val);
                    widget.appState.toggleHomeLoadBalancing(val);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Manual Power Slider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Manual Output Current Limit', style: TextStyle(color: Colors.white70, fontSize: 12)),
              Text('${_currentKw.toStringAsFixed(1)} kW (16A / 230V)', style: const TextStyle(color: AppTheme.electricMint, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          Slider(
            value: _currentKw,
            min: 1.4,
            max: 7.4,
            divisions: 6,
            activeColor: AppTheme.electricMint,
            inactiveColor: Colors.white12,
            onChanged: (val) {
              setState(() => _currentKw = val);
              widget.appState.updateHomeCurrentKw(val);
            },
          ),
          const SizedBox(height: 10),

          // Done Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGreen,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Save Home-Sync Settings', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCol(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 11)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 15)),
      ],
    );
  }
}
