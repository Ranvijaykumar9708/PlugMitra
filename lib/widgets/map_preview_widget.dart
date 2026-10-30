import 'package:flutter/material.dart';
import '../models/station.dart';
import '../theme/app_theme.dart';

class MapPreviewWidget extends StatefulWidget {
  final List<ChargingStation> stations;
  final Function(ChargingStation) onSelectStation;
  final ChargingStation? selectedStation;

  const MapPreviewWidget({
    super.key,
    required this.stations,
    required this.onSelectStation,
    this.selectedStation,
  });

  @override
  State<MapPreviewWidget> createState() => _MapPreviewWidgetState();
}

class _MapPreviewWidgetState extends State<MapPreviewWidget> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFE8EEF5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Light Vector Map Simulation (Parks, Roads, River)
            Positioned.fill(
              child: CustomPaint(
                painter: _LightMapPainter(),
              ),
            ),

            // Top Status Badge
            Positioned(
              top: 14,
              left: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.borderLight),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppTheme.primaryGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'Live Charger Map',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Re-center / GPS Button
            Positioned(
              top: 14,
              right: 14,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.borderLight),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.my_location,
                  size: 18,
                  color: AppTheme.primaryGreen,
                ),
              ),
            ),

            // User Location (Blue Pulse Dot)
            Positioned(
              left: 140,
              top: 150,
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 28 + (_pulseController.value * 20),
                        height: 28 + (_pulseController.value * 20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF0284C7).withOpacity(0.3 * (1 - _pulseController.value)),
                        ),
                      ),
                      Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0284C7),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2.5),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x660284C7),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Station Pins plotted across the map (Emerald Pins with Lightning Bolt)
            ...widget.stations.asMap().entries.map((entry) {
              final index = entry.key;
              final station = entry.value;

              final positions = [
                const Offset(50, 75),   // GreenCharge Station (Noida)
                const Offset(240, 70),  // ChargePoint Hub (Noida Sec 18)
                const Offset(270, 200), // EV Power Zone (Greater Noida)
                const Offset(60, 220),  // ElectroSpot (Gurugram)
                const Offset(160, 130), // PlugMitra CyberCity SuperHub
                const Offset(120, 270), // PlugMitra Highway Fleet Hub
                const Offset(280, 135), // PlugMitra GreenPark BKC
                const Offset(65, 140),  // PlugMitra TechHub Indiranagar
                const Offset(210, 260), // Tata Power EZ Charge
                const Offset(150, 60),  // Jio-bp Pulse
              ];

              final pos = index < positions.length
                  ? positions[index]
                  : Offset(50.0 + ((index * 45) % 250), 90.0 + ((index * 35) % 180));
              final isSelected = widget.selectedStation?.id == station.id;

              return Positioned(
                left: pos.dx,
                top: pos.dy,
                child: GestureDetector(
                  onTap: () => widget.onSelectStation(station),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Tooltip when selected
                      if (isSelected)
                        Container(
                          margin: const EdgeInsets.only(bottom: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppTheme.primaryGreen),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Text(
                            station.name,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ),

                      // Emerald Map Pin Circle (matching Screen 6 in image)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: isSelected ? 38 : 32,
                        height: isSelected ? 38 : 32,
                        decoration: BoxDecoration(
                          color: isSelected ? AppTheme.primaryGreen : const Color(0xFF00A86B),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryGreen.withOpacity(0.35),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.bolt,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _LightMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. Pale Green Parks / Nature reserves
    final parkPaint = Paint()
      ..color = const Color(0xFFDCFCE7).withOpacity(0.7)
      ..style = PaintingStyle.fill;

    final park1 = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.05, size.height * 0.1, 90, 80),
        const Radius.circular(20),
      ));
    final park2 = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.65, size.height * 0.5, 110, 90),
        const Radius.circular(25),
      ));
    canvas.drawPath(park1, parkPaint);
    canvas.drawPath(park2, parkPaint);

    // 2. Soft Blue River / Water body
    final riverPaint = Paint()
      ..color = const Color(0xFFBAE6FD).withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    final river = Path()
      ..moveTo(0, size.height * 0.8)
      ..quadraticBezierTo(size.width * 0.45, size.height * 0.75, size.width, size.height * 0.95);
    canvas.drawPath(river, riverPaint);

    // 3. Roads (White with border)
    final roadBorderPaint = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round;

    final roadSurfacePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;

    // Highway 1
    final road1 = Path()
      ..moveTo(0, size.height * 0.45)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.4, size.width, size.height * 0.25);
    canvas.drawPath(road1, roadBorderPaint);
    canvas.drawPath(road1, roadSurfacePaint);

    // Road 2 (cross artery)
    final road2 = Path()
      ..moveTo(size.width * 0.35, 0)
      ..quadraticBezierTo(size.width * 0.4, size.height * 0.5, size.width * 0.6, size.height);
    canvas.drawPath(road2, roadBorderPaint);
    canvas.drawPath(road2, roadSurfacePaint);

    // Secondary Street
    final minorRoadPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    final street1 = Path()
      ..moveTo(size.width * 0.1, size.height * 0.7)
      ..lineTo(size.width * 0.85, size.height * 0.65);
    canvas.drawPath(street1, minorRoadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
