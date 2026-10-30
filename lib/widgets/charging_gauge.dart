import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ChargingGauge extends StatefulWidget {
  final double currentPercent;
  final double targetPercent;
  final double powerKw;
  final bool isCharging;

  const ChargingGauge({
    super.key,
    required this.currentPercent,
    required this.targetPercent,
    required this.powerKw,
    required this.isCharging,
  });

  @override
  State<ChargingGauge> createState() => _ChargingGaugeState();
}

class _ChargingGaugeState extends State<ChargingGauge> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final pulseValue = widget.isCharging ? _pulseController.value : 0.0;

        return SizedBox(
          width: 250,
          height: 250,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer Ambient Glow
              Container(
                width: 240 + (pulseValue * 12),
                height: 240 + (pulseValue * 12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: widget.isCharging
                          ? AppTheme.electricMint.withOpacity(0.18 + (pulseValue * 0.12))
                          : Colors.transparent,
                      blurRadius: 40 + (pulseValue * 20),
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),

              // Custom Painter for circular gauge tracks
              CustomPaint(
                size: const Size(230, 230),
                painter: _GaugePainter(
                  percent: widget.currentPercent / 100.0,
                  targetPercent: widget.targetPercent / 100.0,
                  pulse: pulseValue,
                  isCharging: widget.isCharging,
                ),
              ),

              // Center Telemetry Info
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.bolt,
                        color: widget.isCharging ? AppTheme.electricMint : Colors.white60,
                        size: 26,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.currentPercent.toStringAsFixed(0)}%',
                        style: const TextStyle(
                          fontSize: 52,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: -1.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.isCharging ? 'Charging...' : 'Ready to Charge',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.electricMint.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.electricMint.withOpacity(0.4),
                      ),
                    ),
                    child: Text(
                      widget.isCharging
                          ? '${widget.powerKw.toStringAsFixed(1)} kW FAST'
                          : 'STANDBY',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: widget.isCharging ? AppTheme.electricMint : Colors.white60,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Target: ${widget.targetPercent.toInt()}%',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white60,
                      fontWeight: FontWeight.w500,
                    ),
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

class _GaugePainter extends CustomPainter {
  final double percent;
  final double targetPercent;
  final double pulse;
  final bool isCharging;

  _GaugePainter({
    required this.percent,
    required this.targetPercent,
    required this.pulse,
    required this.isCharging,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 24) / 2;

    const startAngle = -math.pi * 0.75;
    const sweepAngleTotal = math.pi * 1.5;

    // Background Arc
    final bgPaint = Paint()
      ..color = const Color(0xFF1E293B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngleTotal,
      false,
      bgPaint,
    );

    // Target Marker Arc (dashed or ghost)
    final targetPaint = Paint()
      ..color = AppTheme.electricCyan.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    final targetSweep = sweepAngleTotal * targetPercent.clamp(0.0, 1.0);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      targetSweep,
      false,
      targetPaint,
    );

    // Progress Arc with Gradient
    final currentSweep = sweepAngleTotal * percent.clamp(0.0, 1.0);
    if (currentSweep > 0) {
      final gradient = SweepGradient(
        startAngle: startAngle,
        endAngle: startAngle + sweepAngleTotal,
        colors: const [
          AppTheme.electricCyan,
          AppTheme.electricMint,
          AppTheme.neonVolt,
        ],
      );

      final progressPaint = Paint()
        ..shader = gradient.createShader(Rect.fromCircle(center: center, radius: radius))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 15
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        currentSweep,
        false,
        progressPaint,
      );

      // Glowing tip indicator dot
      final tipAngle = startAngle + currentSweep;
      final tipX = center.dx + radius * math.cos(tipAngle);
      final tipY = center.dy + radius * math.sin(tipAngle);

      final glowPaint = Paint()
        ..color = isCharging ? AppTheme.neonVolt : AppTheme.electricMint
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(tipX, tipY), 9, glowPaint);

      final corePaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(tipX, tipY), 4, corePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) {
    return oldDelegate.percent != percent ||
        oldDelegate.targetPercent != targetPercent ||
        oldDelegate.pulse != pulse ||
        oldDelegate.isCharging != isCharging;
  }
}
