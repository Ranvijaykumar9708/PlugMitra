import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/charging_session.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/charging_gauge.dart';

class LiveChargingScreen extends StatelessWidget {
  final AppState appState;

  const LiveChargingScreen({super.key, required this.appState});

  String _formatDuration(int totalSeconds) {
    final hours = (totalSeconds / 3600).floor();
    final minutes = ((totalSeconds % 3600) / 60).floor();
    final seconds = totalSeconds % 60;
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final session = appState.activeSession;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF0D1F17),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
            onPressed: () => appState.setTabIndex(0),
          ),
          centerTitle: true,
          title: const Text(
            'Charging in Progress',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
        body: SafeArea(
          child: session == null || session.status == SessionStatus.idle
              ? _buildIdleStandbyView(context)
              : _buildActiveTelemetryView(context, session),
        ),
      ),
    );
  }

  Widget _buildIdleStandbyView(BuildContext context) {
    final vehicle = appState.selectedVehicle;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: AppTheme.electricMint.withOpacity(0.12),
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.electricMint.withOpacity(0.3), width: 1.5),
              ),
              child: const Icon(
                Icons.ev_station_rounded,
                size: 46,
                color: AppTheme.electricMint,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Active Charging Session',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Connect your vehicle (${vehicle.fullName}) at any PlugMitra Hub or partner station to monitor live telemetry.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 28),

            // Vehicle Quick Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.chargingCard,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppTheme.chargingBorder),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.directions_car, color: AppTheme.electricMint, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vehicle.fullName,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.white),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Current SoC: ${vehicle.currentSocPercent.toInt()}% • ${vehicle.estimatedRemainingRangeKm.toInt()} km left',
                          style: const TextStyle(fontSize: 12, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Demo Instant Charge CTA
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  final station = appState.allStations.first;
                  final connector = station.connectors.first;
                  appState.startChargingSession(station: station, connector: connector);
                },
                icon: const Icon(Icons.bolt, color: Colors.black),
                label: const Text(
                  'Launch Demo 120kW Supercharge',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.electricMint,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => appState.setTabIndex(0),
              child: const Text(
                'Explore Nearby Chargers',
                style: TextStyle(color: AppTheme.electricMint, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔋 SCREEN 12: Live Charging Telemetry (Exact layout matching mockup board)
  Widget _buildActiveTelemetryView(BuildContext context, ChargingSession session) {
    final isCharging = session.status == SessionStatus.charging;
    final isPaused = session.status == SessionStatus.paused;
    final isDone = session.status == SessionStatus.completed;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 120),
      child: Column(
        children: [
          // Station & Connector Header Card (Screen 12)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.chargingCard,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.chargingBorder),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.electricMint.withOpacity(0.18),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isDone ? Icons.check_circle : (isPaused ? Icons.pause : Icons.bolt),
                    color: isDone ? AppTheme.electricMint : (isPaused ? AppTheme.amberBusy : AppTheme.electricMint),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        session.station.name,
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Colors.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${session.connector.name} • ${session.vehicle.fullName}',
                        style: const TextStyle(fontSize: 12, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDone
                        ? AppTheme.electricMint.withOpacity(0.2)
                        : (isPaused ? AppTheme.amberBusy.withOpacity(0.2) : AppTheme.electricMint.withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDone ? AppTheme.electricMint : (isPaused ? AppTheme.amberBusy : AppTheme.electricMint),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    isDone ? 'COMPLETE' : (isPaused ? 'PAUSED' : 'LIVE'),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: isDone ? AppTheme.electricMint : (isPaused ? AppTheme.amberBusy : AppTheme.electricMint),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Central Animated Charging Gauge (Screen 12)
          ChargingGauge(
            currentPercent: session.currentPercent,
            targetPercent: session.targetPercent,
            powerKw: session.currentPowerKw,
            isCharging: isCharging,
          ),
          const SizedBox(height: 16),

          // Time Remaining Banner
          if (isCharging)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.chargingBorder),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.timer_outlined, size: 16, color: AppTheme.electricMint),
                  const SizedBox(width: 6),
                  Text(
                    '~${session.remainingMinutes} mins remaining to ${session.targetPercent.toInt()}%',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.electricMint,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 20),

          // 💡 80% Sweet Spot Battery Protection Alert (Tesla/EV Standard)
          if (session.currentPercent >= 80.0 && isCharging) ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF132F22),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.electricMint.withOpacity(0.5)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.electricMint.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.shield_outlined, color: AppTheme.electricMint, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '80% Optimal Sweet-Spot Reached ⚡',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Charging speed tapers down after 80% to protect lithium battery cells. Unplugging now saves time & cost.',
                          style: TextStyle(fontSize: 11, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // 📊 3-Metric Summary Card (Exact Layout from Screen 12 of Mockup)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: BoxDecoration(
              color: AppTheme.chargingCard,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.chargingBorder),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryMetric(
                  value: '${session.energyDeliveredKwh.toStringAsFixed(1)} kWh',
                  label: 'Energy',
                ),
                Container(width: 1, height: 38, color: AppTheme.chargingBorder),
                _buildSummaryMetric(
                  value: _formatDuration(session.elapsedSeconds),
                  label: 'Time',
                ),
                Container(width: 1, height: 38, color: AppTheme.chargingBorder),
                _buildSummaryMetric(
                  value: '₹${session.totalCost.toStringAsFixed(0)}',
                  label: 'Estimated',
                  highlight: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ⚡ Additional Real-time Telemetry Grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.7,
            children: [
              _buildTelemetryCard(
                label: 'Charging Speed',
                value: '${session.currentPowerKw.toStringAsFixed(1)} kW',
                subtext: 'Peak ${session.connector.powerKw.toInt()} kW supported',
                icon: Icons.speed,
                accentColor: AppTheme.electricMint,
              ),
              _buildTelemetryCard(
                label: 'Voltage & Current',
                value: '${session.voltageVolts.toInt()}V • ${session.currentAmps.toInt()}A',
                subtext: 'DC Flow Stabilized',
                icon: Icons.electric_meter,
                accentColor: AppTheme.electricCyan,
              ),
              _buildTelemetryCard(
                label: 'Range Added',
                value: '+${((session.energyDeliveredKwh / session.vehicle.batteryCapacityKwh) * session.vehicle.rangeKm).toInt()} km',
                subtext: 'Battery range boosted',
                icon: Icons.battery_charging_full,
                accentColor: AppTheme.electricMint,
              ),
              _buildTelemetryCard(
                label: 'Thermal Status',
                value: '34°C Optimal',
                subtext: 'Active liquid cooling',
                icon: Icons.thermostat,
                accentColor: AppTheme.electricCyan,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 🌱 Clean Mobility Impact Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.chargingCard,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppTheme.electricMint.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.electricMint.withOpacity(0.18),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.eco, color: AppTheme.electricMint, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Clean Mobility Impact',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'You saved ${session.co2SavedKg.toStringAsFixed(2)} kg of CO₂ emission in this session.',
                        style: const TextStyle(fontSize: 12, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Target Limit Slider
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.chargingCard,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppTheme.chargingBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Target Charge Limit',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                    Text(
                      '${session.targetPercent.toInt()}%',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.electricMint,
                      ),
                    ),
                  ],
                ),
                SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: AppTheme.electricMint,
                    inactiveTrackColor: Colors.white.withOpacity(0.1),
                    thumbColor: AppTheme.electricMint,
                    overlayColor: AppTheme.electricMint.withOpacity(0.2),
                    trackHeight: 6,
                  ),
                  child: Slider(
                    value: session.targetPercent,
                    min: 50.0,
                    max: 100.0,
                    divisions: 10,
                    onChanged: (val) {
                      session.setTargetPercent(val);
                    },
                  ),
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('50% (Quick)', style: TextStyle(fontSize: 10, color: Colors.white60)),
                    Text('80% (Recommended)', style: TextStyle(fontSize: 10, color: AppTheme.electricMint, fontWeight: FontWeight.w700)),
                    Text('100% (Trip)', style: TextStyle(fontSize: 10, color: Colors.white60)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),

          // 🛑 Stop Charging & Pause Action Buttons (Screen 12 of Mockup)
          Row(
            children: [
              Expanded(
                flex: 2,
                child: OutlinedButton.icon(
                  onPressed: () {
                    session.pauseCharging();
                  },
                  icon: Icon(isPaused ? Icons.play_arrow : Icons.pause, size: 18, color: Colors.white),
                  label: Text(
                    isPaused ? 'Resume' : 'Pause',
                    style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppTheme.chargingBorder),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showStopConfirmationDialog(context, session);
                  },
                  icon: const Icon(Icons.stop_circle_outlined, size: 20, color: Colors.white),
                  label: const Text(
                    'Stop Charging',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD32F2F),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(color: Color(0xFFFF5252), width: 1.5),
                    ),
                    elevation: 4,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildSummaryMetric({
    required String value,
    required String label,
    bool highlight = false,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w900,
            color: highlight ? AppTheme.electricMint : Colors.white,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _showStopConfirmationDialog(BuildContext context, ChargingSession session) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF132A1E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: const BorderSide(color: AppTheme.chargingBorder),
          ),
          title: const Text('End Charging Session?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
          content: Text(
            'Vehicle SoC reached ${session.currentPercent.toStringAsFixed(0)}%.\nTotal energy delivered: ${session.energyDeliveredKwh.toStringAsFixed(2)} kWh\nTotal amount to settle: ₹${session.totalCost.toStringAsFixed(1)}',
            style: const TextStyle(color: Colors.white70, height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.white60)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                appState.stopActiveCharging();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Charging ended. Gun unlocked successfully! ⚡'),
                    backgroundColor: Color(0xFF132A1E),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.electricMint,
                foregroundColor: Colors.black,
              ),
              child: const Text('Confirm & Unlock', style: TextStyle(fontWeight: FontWeight.w800)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTelemetryCard({
    required String label,
    required String value,
    required String subtext,
    required IconData icon,
    required Color accentColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.chargingCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.chargingBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 11, color: Colors.white70, fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              Icon(icon, size: 16, color: accentColor),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          Text(
            subtext,
            style: TextStyle(fontSize: 10, color: accentColor, fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
