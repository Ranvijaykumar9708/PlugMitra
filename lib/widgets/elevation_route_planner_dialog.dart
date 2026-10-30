import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

class ElevationRoutePlannerDialog extends StatefulWidget {
  final AppState appState;

  const ElevationRoutePlannerDialog({super.key, required this.appState});

  @override
  State<ElevationRoutePlannerDialog> createState() => _ElevationRoutePlannerDialogState();
}

class _ElevationRoutePlannerDialogState extends State<ElevationRoutePlannerDialog> {
  int _selectedRouteIndex = 0;
  double _cabinTemp = 22.0;

  final List<Map<String, dynamic>> _routes = [
    {
      'title': 'Delhi ➔ Manali (Himalayan NH44 / NH3)',
      'distance': '538 km',
      'elevation': '+1,850 m Peak Climb',
      'mountainDrag': '-28% Uphill Drag',
      'regenGain': '+14% Regen Restoration',
      'stops': [
        {'name': 'Karnal Haveli SuperHub', 'time': '18 min charge', 'target': '68%'},
        {'name': 'Mandi Hill Base 120kW', 'time': '22 min charge', 'target': '82%'},
      ],
      'arrivalReserve': '24% SoC',
    },
    {
      'title': 'Mumbai ➔ Goa (Western Ghats Express)',
      'distance': '584 km',
      'elevation': '+640 m Khandala Ghat',
      'mountainDrag': '-18% Ghat Climb',
      'regenGain': '+11% Downhill Regen',
      'stops': [
        {'name': 'Pune Expressway Food Mall', 'time': '20 min charge', 'target': '75%'},
        {'name': 'Kolhapur Green Hub', 'time': '25 min charge', 'target': '80%'},
      ],
      'arrivalReserve': '29% SoC',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final route = _routes[_selectedRouteIndex];
    final vehicle = widget.appState.selectedVehicle;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(18),
                decoration: const BoxDecoration(
                  color: Color(0xFF0F172A),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.electricMint.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.terrain_rounded, color: AppTheme.electricMint, size: 24),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AI Elevation Route Planner',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Tesla-Grade Mountain & Climate Telemetry',
                            style: TextStyle(fontSize: 11, color: Colors.white60),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white54),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Route Selector Tabs
                    Row(
                      children: [
                        Expanded(
                          child: _buildRouteTab(0, 'Delhi ➔ Manali'),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildRouteTab(1, 'Mumbai ➔ Goa'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Route Summary Box
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.borderLight),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            route['title'] as String,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildMetricChip(Icons.straighten, route['distance'] as String, 'Distance'),
                              _buildMetricChip(Icons.landscape, route['elevation'] as String, 'Climb'),
                              _buildMetricChip(Icons.battery_charging_full, route['arrivalReserve'] as String, 'Reserve'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Elevation Gradient & Regen Bar
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFBFDBFE)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.show_chart, color: Color(0xFF2563EB), size: 24),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Terrain Impact on ${vehicle.fullName}',
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF1E3A8A)),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${route['mountainDrag']} on steep climbs • ${route['regenGain']} recovered on downhill descents.',
                                  style: const TextStyle(fontSize: 11, color: Color(0xFF3B82F6), height: 1.3),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Cabin AC Load Slider
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Cabin AC Setpoint',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                        ),
                        Text(
                          '${_cabinTemp.toInt()}°C (Summer Load)',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppTheme.primaryGreen),
                        ),
                      ],
                    ),
                    Slider(
                      value: _cabinTemp,
                      min: 18.0,
                      max: 26.0,
                      divisions: 8,
                      activeColor: AppTheme.primaryGreen,
                      onChanged: (val) => setState(() => _cabinTemp = val),
                    ),
                    const SizedBox(height: 10),

                    // Recommended Pitstops
                    const Text(
                      'AI Calculated Optimal Pitstops',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
                    ),
                    const SizedBox(height: 10),
                    ...(route['stops'] as List<Map<String, String>>).map((stop) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.borderLight),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(color: AppTheme.lightGreenBg, shape: BoxShape.circle),
                              child: const Icon(Icons.ev_station, color: AppTheme.primaryGreen, size: 18),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(stop['name']!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                                  Text(stop['time']!, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.lightGreenBg,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Target ${stop['target']}',
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppTheme.primaryGreen),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 16),

                    // Launch Navigation Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('🗺️ Synced elevation route to GPS with 2 planned charging pitstops!'),
                              backgroundColor: AppTheme.primaryGreen,
                            ),
                          );
                        },
                        icon: const Icon(Icons.navigation_rounded, size: 18),
                        label: const Text('Start EV Guided Highway Trip', style: TextStyle(fontWeight: FontWeight.w800)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
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

  Widget _buildRouteTab(int index, String title) {
    final isSelected = _selectedRouteIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedRouteIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryGreen : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              color: isSelected ? Colors.white : AppTheme.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricChip(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 18, color: AppTheme.primaryGreen),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
        Text(label, style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary)),
      ],
    );
  }
}
