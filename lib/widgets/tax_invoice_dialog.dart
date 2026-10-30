import 'package:flutter/material.dart';
import '../models/charging_session.dart';
import '../theme/app_theme.dart';

class TaxInvoiceDialog extends StatelessWidget {
  final ChargingSession? session;
  final Map<String, dynamic>? historyItem;

  const TaxInvoiceDialog({
    super.key,
    this.session,
    this.historyItem,
  });

  @override
  Widget build(BuildContext context) {
    final invoiceNumber = 'PM-INV-2026-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    final date = historyItem != null ? historyItem!['date'] as String : 'Today, ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}';
    final stationName = session?.station.name ?? (historyItem != null ? historyItem!['station'] as String : 'GreenCharge Station');
    final energy = session?.energyDeliveredKwh.toStringAsFixed(1) ?? '24.8';
    final totalAmount = session != null ? session!.totalCost : (historyItem != null ? double.tryParse((historyItem!['amount'] as String).replaceAll('₹', '')) ?? 356.0 : 356.0);

    final baseAmount = totalAmount / 1.18;
    final gstAmount = totalAmount - baseAmount;
    final cgst = gstAmount / 2;
    final sgst = gstAmount / 2;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      child: Container(
        padding: const EdgeInsets.all(22),
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
              // Header Row: Brand & Close
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
                        child: const Icon(Icons.bolt, color: AppTheme.primaryGreen, size: 22),
                      ),
                      const SizedBox(width: 10),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PlugMitra Mobility',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          Text(
                            'GST Tax Invoice',
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

              // Invoice Metadata
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Invoice No', style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                      const SizedBox(height: 2),
                      Text(invoiceNumber, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('Date & Time', style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                      const SizedBox(height: 2),
                      Text(date, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Station & GSTIN Info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.borderLight),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stationName,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'GSTIN: 07AAACP8921K1Z4 • SAC: 998714 (EV Charging Services)',
                      style: TextStyle(fontSize: 10, color: AppTheme.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Breakdown Table
              const Text('Itemized Billing', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
              const SizedBox(height: 8),
              _buildBillRow('Energy Consumed', '$energy kWh'),
              _buildBillRow('Tariff Rate', '₹18.00 / kWh'),
              _buildBillRow('Base Value (Excl. Tax)', '₹${baseAmount.toStringAsFixed(2)}'),
              _buildBillRow('CGST (9%)', '₹${cgst.toStringAsFixed(2)}'),
              _buildBillRow('SGST (9%)', '₹${sgst.toStringAsFixed(2)}'),
              const Divider(height: 16, color: AppTheme.borderLight),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Paid (UPI)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
                  Text(
                    '₹${totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppTheme.primaryGreen),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Green Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.lightGreenBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.verified, size: 16, color: AppTheme.primaryGreen),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '100% Green Energy Certificate: Verified Zero-Emission Charging',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.primaryGreen),
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
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Invoice link copied to clipboard! 📄'),
                            backgroundColor: AppTheme.primaryGreen,
                          ),
                        );
                      },
                      icon: const Icon(Icons.share, size: 16, color: AppTheme.textPrimary),
                      label: const Text('Share', style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w700)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppTheme.borderLight),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Invoice $invoiceNumber downloaded to device! ⚡'),
                            backgroundColor: AppTheme.primaryGreen,
                          ),
                        );
                      },
                      icon: const Icon(Icons.download, size: 18),
                      label: const Text('Save PDF Invoice', style: TextStyle(fontWeight: FontWeight.w800)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBillRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
        ],
      ),
    );
  }
}
