import 'package:flutter/material.dart';
import '../models/charging_session.dart';
import '../state/app_state.dart';
import '../widgets/booking_ticket_dialog.dart';

class PaymentScreen extends StatefulWidget {
  final double amount;
  final String stationName;
  final String slotTime;
  final AppState appState;
  final BookingRecord? booking;

  const PaymentScreen({
    super.key,
    required this.amount,
    required this.stationName,
    required this.slotTime,
    required this.appState,
    this.booking,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedMethod = 'upi'; // 'upi', 'card', 'wallet', 'other'

  void _onPay() {
    // Process payment and show success pass
    if (widget.booking != null) {
      Navigator.of(context).pop(); // pop payment
      showDialog(
        context: context,
        builder: (context) {
          return BookingTicketDialog(
            booking: widget.booking!,
            onStartNow: () {
              final station = widget.appState.allStations.firstWhere(
                (s) => s.name == widget.booking!.stationName,
                orElse: () => widget.appState.allStations.first,
              );
              final connector = station.connectors.first;
              widget.appState.startChargingSession(
                station: station,
                connector: connector,
              );
            },
          );
        },
      );
    } else {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment of ₹${widget.amount.toInt()} successful! ⚡'),
          backgroundColor: const Color(0xFF00C853),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF1E293B), size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Payment Method',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 24),

              // UPI Option (Recommended)
              _buildPaymentCard(
                methodId: 'upi',
                title: 'UPI (Recommended)',
                icon: Icons.account_balance,
                iconColor: const Color(0xFF00C853),
                trailingWidget: Row(
                  children: [
                    _buildUpiPill('PhonePe', Colors.deepPurple),
                    const SizedBox(width: 8),
                    _buildUpiPill('GPay', Colors.blue),
                    const SizedBox(width: 8),
                    _buildUpiPill('Paytm', Colors.lightBlue),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Credit / Debit Card
              _buildPaymentCard(
                methodId: 'card',
                title: 'Credit / Debit Card',
                icon: Icons.credit_card,
                iconColor: const Color(0xFF3B82F6),
              ),
              const SizedBox(height: 16),

              // Wallet Balance
              _buildPaymentCard(
                methodId: 'wallet',
                title: 'Wallet Balance',
                subtitle: '₹${widget.appState.walletBalance.toStringAsFixed(2)}',
                icon: Icons.account_balance_wallet,
                iconColor: const Color(0xFFF59E0B),
              ),
              const SizedBox(height: 16),

              // Other Payment Options
              _buildPaymentCard(
                methodId: 'other',
                title: 'Other Payment Options',
                icon: Icons.more_horiz,
                iconColor: const Color(0xFF64748B),
                hasChevron: true,
              ),

              const Spacer(),

              // Pay Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onPay,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C853),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Pay ₹${widget.amount.toInt()}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 14),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentCard({
    required String methodId,
    required String title,
    String? subtitle,
    required IconData icon,
    required Color iconColor,
    Widget? trailingWidget,
    bool hasChevron = false,
  }) {
    final isSelected = _selectedMethod == methodId;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedMethod = methodId;
        });
      },
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? const Color(0xFF00C853) : const Color(0xFFE2E8F0),
            width: isSelected ? 1.8 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 20, color: iconColor),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (hasChevron)
                  const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF94A3B8))
                else
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? const Color(0xFF00C853) : Colors.transparent,
                      border: Border.all(
                        color: isSelected ? const Color(0xFF00C853) : const Color(0xFFCBD5E1),
                        width: 1.8,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : null,
                  ),
              ],
            ),
            if (trailingWidget != null) ...[
              const SizedBox(height: 14),
              const Divider(height: 1, color: Color(0xFFF1F5F9)),
              const SizedBox(height: 12),
              trailingWidget,
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildUpiPill(String name, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        name,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color),
      ),
    );
  }
}
