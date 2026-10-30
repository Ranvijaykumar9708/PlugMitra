import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

class HighwayCorridorDialog extends StatefulWidget {
  final AppState appState;

  const HighwayCorridorDialog({super.key, required this.appState});

  @override
  State<HighwayCorridorDialog> createState() => _HighwayCorridorDialogState();
}

class _HighwayCorridorDialogState extends State<HighwayCorridorDialog> {
  int _selectedRouteIndex = 0;
  late bool _isCorridorActive;

  final List<Map<String, dynamic>> _routes = [
    {
      'name': 'Delhi – Mumbai Expressway (NE4)',
      'distance': '1,386 km',
      'duration': '17h 45m',
      'pitstops': 4,
      'headwind': '28 km/h Headwind',
      'temp': '39°C (High AC Drag)',
      'primaryHub': 'Dausa HyperHub (180 kW)',
      'fallbackHub': 'Lalsot Solar Oasis (120 kW) • Auto-Reserved',
    },
    {
      'name': 'Bengaluru – Hyderabad (NH 44)',
      'distance': '570 km',
      'duration': '7h 30m',
      'pitstops': 2,
      'headwind': '15 km/h Tailwind (+4% Regen)',
      'temp': '32°C (Optimal)',
      'primaryHub': 'Kurnool FastHub (120 kW)',
      'fallbackHub': 'Anantapur Food Court (60 kW) • Auto-Reserved',
    },
    {
      'name': 'Delhi – Agra Yamuna Expressway',
      'distance': '210 km',
      'duration': '2h 50m',
      'pitstops': 1,
      'headwind': '10 km/h Mild',
      'temp': '36°C (Moderate)',
      'primaryHub': 'Jewar Toll Plaza Hub (150 kW)',
      'fallbackHub': 'Mathura Highway Oasis (60 kW) • Auto-Reserved',
    },
  ];

  @override
  void initState() {
    super.initState();
    _isCorridorActive = widget.appState.isHighwayCorridorActive;
  }

  @override
  Widget build(BuildContext context) {
    final route = _routes[_selectedRouteIndex];

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: const Color(0xFF6366F1).withOpacity(0.4), width: 1.5),
        ),
        padding: const EdgeInsets.all(22),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.add_road_rounded, color: Color(0xFF818CF8), size: 26),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Highway Corridor Shield™',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18),
                        ),
                        Text(
                          'Inter-State Zero-Anxiety EV Cruise System',
                          style: TextStyle(color: Colors.white60, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white54),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Route Selector Tabs
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(_routes.length, (index) {
                    final isSel = _selectedRouteIndex == index;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(_routes[index]['name'] as String),
                        selected: isSel,
                        selectedColor: const Color(0xFF6366F1),
                        backgroundColor: const Color(0xFF1E293B),
                        labelStyle: TextStyle(
                          color: isSel ? Colors.white : Colors.white70,
                          fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                          fontSize: 11,
                        ),
                        onSelected: (val) {
                          if (val) setState(() => _selectedRouteIndex = index);
                        },
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 16),

              // Corridor Overview Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF312E81), Color(0xFF1E1B4B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF818CF8).withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          route['distance'] as String,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 24),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.electricMint.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppTheme.electricMint),
                          ),
                          child: const Text('20% Min Safety Buffer', style: TextStyle(color: AppTheme.electricMint, fontWeight: FontWeight.bold, fontSize: 10)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Drive Time: ${route['duration']} • ${route['pitstops']} Ultra-Fast DC Pitstops',
                      style: const TextStyle(color: Color(0xFFC7D2FE), fontSize: 12),
                    ),
                    const Divider(color: Colors.white12, height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSubMetric('💨 Aerodynamics', route['headwind'] as String),
                        _buildSubMetric('🌡️ Climate', route['temp'] as String),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Dynamic Fallback Hub Engine (Zero-Stranding Guarantee)
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
                    const Row(
                      children: [
                        Icon(Icons.alt_route_rounded, color: AppTheme.electricMint, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Dynamic Fallback Hub Intelligence',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.redAccent.withOpacity(0.4)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Planned: ${route['primaryHub']} (High Queue: 4 cars waiting)',
                              style: const TextStyle(color: Colors.white70, fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppTheme.primaryGreen),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_outline, color: AppTheme.electricMint, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Auto-Diverting to: ${route['fallbackHub']}',
                              style: const TextStyle(color: AppTheme.electricMint, fontWeight: FontWeight.bold, fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Cruise Mode Toggle Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final newState = !_isCorridorActive;
                    setState(() => _isCorridorActive = newState);
                    widget.appState.toggleHighwayCorridor(newState);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(newState
                            ? '🚀 Highway Corridor Shield Active! Dynamic auto-reroute enabled.'
                            : 'Highway Corridor Shield paused.'),
                        backgroundColor: AppTheme.primaryGreen,
                      ),
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isCorridorActive ? Colors.redAccent.withOpacity(0.9) : const Color(0xFF6366F1),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    _isCorridorActive ? 'Stop Corridor Cruise Shield' : 'Engage Highway Corridor Cruise Mode',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubMetric(String title, String val) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.white60, fontSize: 10)),
        const SizedBox(height: 2),
        Text(val, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
      ],
    );
  }
}
