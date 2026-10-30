import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

class TariffSchedulerDialog extends StatefulWidget {
  final AppState appState;

  const TariffSchedulerDialog({super.key, required this.appState});

  @override
  State<TariffSchedulerDialog> createState() => _TariffSchedulerDialogState();
}

class _TariffSchedulerDialogState extends State<TariffSchedulerDialog> {
  late bool _isScheduled;
  String _selectedTime = '11:00 PM';

  @override
  void initState() {
    super.initState();
    _isScheduled = widget.appState.isScheduledChargeActive;
    _selectedTime = widget.appState.scheduledChargeStartTime;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      titlePadding: const EdgeInsets.fromLTRB(22, 22, 22, 10),
      contentPadding: const EdgeInsets.fromLTRB(22, 0, 22, 20),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: AppTheme.lightGreenBg,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.nightlight_round, color: AppTheme.primaryGreen, size: 22),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ToD Off-Peak Saver',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
                ),
                Text(
                  'Time-of-Day Electricity Tariff Optimizer',
                  style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            // 24-Hour Tariff Chart
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.borderLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'DISCOM TARIFF BY TIME (DELHI NCR)',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppTheme.textSecondary, letterSpacing: 0.8),
                  ),
                  const SizedBox(height: 12),
                  _buildTariffRow(
                    '11:00 PM - 06:00 AM',
                    '₹9.50 / unit',
                    'Super Off-Peak (-45%)',
                    const Color(0xFF10B981),
                    true,
                  ),
                  const SizedBox(height: 8),
                  _buildTariffRow(
                    '06:00 AM - 05:00 PM',
                    '₹16.00 / unit',
                    'Standard Day Rate',
                    Colors.orange,
                    false,
                  ),
                  const SizedBox(height: 8),
                  _buildTariffRow(
                    '05:00 PM - 11:00 PM',
                    '₹22.50 / unit',
                    'Peak Grid Demand',
                    Colors.redAccent,
                    false,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Toggle Overnight Auto-Charge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.borderLight),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Schedule Overnight Charge',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                      ),
                      Text(
                        'Plug gun now; charges at 11 PM',
                        style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                      ),
                    ],
                  ),
                  Switch.adaptive(
                    value: _isScheduled,
                    activeColor: AppTheme.primaryGreen,
                    onChanged: (val) {
                      setState(() => _isScheduled = val);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Potential Savings Box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.lightGreenBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.savings_rounded, color: AppTheme.primaryGreen, size: 24),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Estimated Overnight Savings',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.primaryGreen),
                        ),
                        Text(
                          'Save ~₹340.00 on a full 35 kWh charge!',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.green.shade800),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel', style: TextStyle(color: AppTheme.textSecondary)),
        ),
        ElevatedButton(
          onPressed: () {
            widget.appState.toggleScheduledCharging(_isScheduled, time: _selectedTime);
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  _isScheduled
                      ? '🌙 Smart ToD Schedule Set: Charging will begin at $_selectedTime! ⚡'
                      : 'Scheduled charging disabled.',
                ),
                backgroundColor: _isScheduled ? AppTheme.primaryGreen : AppTheme.cardDark,
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryGreen,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Save Schedule', style: TextStyle(fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }

  Widget _buildTariffRow(String time, String rate, String label, Color color, bool isBest) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(time, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
              Text(label, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        Text(
          rate,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: isBest ? AppTheme.primaryGreen : AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }
}
