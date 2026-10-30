import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

class TripPlannerDialog extends StatefulWidget {
  final AppState appState;

  const TripPlannerDialog({super.key, required this.appState});

  @override
  State<TripPlannerDialog> createState() => _TripPlannerDialogState();
}

class _TripPlannerDialogState extends State<TripPlannerDialog> {
  String _selectedDestination = 'Jaipur (via NH-48 Express)';
  final List<Map<String, dynamic>> _routes = [
    {
      'destination': 'Jaipur (via NH-48 Express)',
      'distanceKm': 270,
      'duration': '4 hrs 15 min',
      'stopStation': 'PlugMitra Highway Fleet & Mega Hub',
      'stopLocation': 'Manesar NH-48 Toll Plaza (48 km)',
      'chargeTime': '24 mins (to 85%)',
      'chargerSpeed': '150 kW DC Fast',
      'evCost': 340,
      'petrolCost': 1950,
    },
    {
      'destination': 'Agra (via Yamuna Expressway)',
      'distanceKm': 210,
      'duration': '3 hrs 10 min',
      'stopStation': 'PlugMitra SuperHub Jewar Expressway',
      'stopLocation': 'Mile 68, Yamuna Expressway (65 km)',
      'chargeTime': '18 mins (to 80%)',
      'chargerSpeed': '120 kW DC Fast',
      'evCost': 290,
      'petrolCost': 1580,
    },
    {
      'destination': 'Chandigarh (via NH-44 GT Road)',
      'distanceKm': 250,
      'duration': '4 hrs 00 min',
      'stopStation': 'PlugMitra Grand Trunk Hub Murthal',
      'stopLocation': 'Murthal Highway Oasis (52 km)',
      'chargeTime': '20 mins (to 85%)',
      'chargerSpeed': '180 kW Hyper Gun',
      'evCost': 320,
      'petrolCost': 1850,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final vehicle = widget.appState.selectedVehicle;
    final currentRoute = _routes.firstWhere(
      (r) => r['destination'] == _selectedDestination,
      orElse: () => _routes.first,
    );

    final savings = (currentRoute['petrolCost'] as int) - (currentRoute['evCost'] as int);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
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
                        child: const Icon(Icons.alt_route, color: AppTheme.primaryGreen, size: 22),
                      ),
                      const SizedBox(width: 10),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Smart EV Trip Planner',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          Text(
                            'AI-Assisted Range & Charger Optimizer',
                            style: TextStyle(fontSize: 11, color: AppTheme.textSecondary, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF1F5F9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, size: 18, color: AppTheme.textSecondary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1, color: AppTheme.borderLight),
              const SizedBox(height: 14),

              // Origin & Destination Selector
              const Text('Trip Destination', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.borderLight),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedDestination,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.primaryGreen),
                    items: _routes.map((r) {
                      return DropdownMenuItem<String>(
                        value: r['destination'] as String,
                        child: Text(
                          r['destination'] as String,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _selectedDestination = val);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Active Vehicle Range Status
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.lightGreenBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.electric_car, color: AppTheme.primaryGreen, size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${vehicle.fullName} • ${vehicle.currentSocPercent.toInt()}% Battery',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
                          ),
                          Text(
                            'Estimated Range: ${vehicle.estimatedRemainingRangeKm.toInt()} km (Need 1 highway stop)',
                            style: const TextStyle(fontSize: 11, color: AppTheme.primaryGreen, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Visual Route Timeline
              const Text('Calculated Charging Route', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
              const SizedBox(height: 10),

              _buildTimelineStep(
                icon: Icons.my_location,
                iconColor: const Color(0xFF0284C7),
                title: 'Start: Current Location (Delhi NCR)',
                subtitle: 'Depart at ${vehicle.currentSocPercent.toInt()}% SoC',
                isFirst: true,
              ),
              _buildTimelineStep(
                icon: Icons.ev_station,
                iconColor: AppTheme.primaryGreen,
                title: 'Charging Stop: ${currentRoute['stopStation']}',
                subtitle: '${currentRoute['stopLocation']} • Charge ${currentRoute['chargeTime']} on ${currentRoute['chargerSpeed']}',
                isHighlight: true,
              ),
              _buildTimelineStep(
                icon: Icons.flag,
                iconColor: AppTheme.amberRating,
                title: 'Destination: ${_selectedDestination.split('(').first}',
                subtitle: 'Arrive safely with ~38% reserve battery (${currentRoute['distanceKm']} km total)',
                isLast: true,
              ),
              const SizedBox(height: 14),

              // Savings Comparison Banner
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.borderLight),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Trip EV Electricity', style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                        Text('₹${currentRoute['evCost']}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppTheme.primaryGreen)),
                      ],
                    ),
                    const VerticalDivider(width: 1),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Petrol Car Cost', style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                        Text('₹${currentRoute['petrolCost']}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textSecondary, decoration: TextDecoration.lineThrough)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.lightGreenBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Save ₹$savings',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppTheme.primaryGreen),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Action Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Route set to $_selectedDestination! Reserved bay at ${currentRoute['stopStation']} ⚡'),
                        backgroundColor: AppTheme.primaryGreen,
                      ),
                    );
                  },
                  icon: const Icon(Icons.navigation, size: 18),
                  label: const Text('Start Trip & Reserve Bay', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineStep({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    bool isFirst = false,
    bool isLast = false,
    bool isHighlight = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(color: iconColor, width: isHighlight ? 2 : 1),
              ),
              child: Icon(icon, size: 16, color: iconColor),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 34,
                color: const Color(0xFFCBD5E1),
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isHighlight ? FontWeight.w800 : FontWeight.w700,
                    color: isHighlight ? AppTheme.primaryGreen : AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
