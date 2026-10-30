import 'package:flutter/material.dart';
import '../models/charging_session.dart';
import '../theme/app_theme.dart';

class BookingTicketDialog extends StatelessWidget {
  final BookingRecord booking;
  final VoidCallback onStartNow;

  const BookingTicketDialog({
    super.key,
    required this.booking,
    required this.onStartNow,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppTheme.borderLight, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Header: PlugMitra Pass
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              decoration: BoxDecoration(
                gradient: AppTheme.mintCyanGradient,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(26),
                  topRight: Radius.circular(26),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.black26,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.bolt, color: Colors.black, size: 20),
                      ),
                      const SizedBox(width: 8),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PLUGMITRA PASS',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                              letterSpacing: 1.2,
                            ),
                          ),
                          Text(
                            'Confirmed EV Reservation',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      booking.bookingId,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.electricMint,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                children: [
                  // Station Details
                  Text(
                    booking.stationName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    booking.stationAddress,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textMuted,
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Ticket Details Grid
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.borderLight),
                    ),
                    child: Column(
                      children: [
                        _buildRow('Vehicle', booking.vehicleName, Icons.directions_car),
                        const Divider(height: 16, color: AppTheme.borderLight),
                        _buildRow('Connector', booking.connectorName, Icons.power),
                        const Divider(height: 16, color: AppTheme.borderLight),
                        _buildRow('Slot Window', booking.slotTime, Icons.access_time),
                        const Divider(height: 16, color: AppTheme.borderLight),
                        _buildRow('Estimated Est.', '₹${booking.estimatedCost.toInt()} (Reserved)', Icons.currency_rupee),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Visual Mock QR Code
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        CustomPaint(
                          size: const Size(120, 120),
                          painter: _QrCodePainter(),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Scan at Charger Screen',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // OTP / Gun Unlock Code
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppTheme.electricMint.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.electricMint.withOpacity(0.2)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.lock_open, size: 16, color: AppTheme.electricMint),
                        const SizedBox(width: 8),
                        const Text(
                          'Gun Unlock PIN: ',
                          style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                        ),
                        Text(
                          '8924',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2,
                            color: AppTheme.electricMint,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppTheme.cardBorder),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text('Close Pass', style: TextStyle(color: AppTheme.textSecondary)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            onStartNow();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.electricMint,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Charge Now',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.electricMint),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
        ),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _QrCodePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    // Stylized QR pattern simulation
    final unit = size.width / 12;

    void drawBox(int gx, int gy, int w, int h) {
      canvas.drawRect(Rect.fromLTWH(gx * unit, gy * unit, w * unit, h * unit), paint);
    }

    // Top-left finder
    drawBox(1, 1, 3, 3);
    // Top-right finder
    drawBox(8, 1, 3, 3);
    // Bottom-left finder
    drawBox(1, 8, 3, 3);

    // Inner details & random data blocks
    drawBox(5, 1, 2, 1);
    drawBox(5, 3, 1, 3);
    drawBox(7, 5, 2, 2);
    drawBox(2, 5, 2, 1);
    drawBox(5, 7, 2, 3);
    drawBox(8, 8, 3, 2);
    drawBox(10, 10, 1, 1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
