import 'package:flutter/material.dart';
import '../models/station.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

class StationDetailSheet extends StatefulWidget {
  final ChargingStation station;
  final AppState appState;
  final VoidCallback onBookSlot;
  final VoidCallback onStartCharging;

  const StationDetailSheet({
    super.key,
    required this.station,
    required this.appState,
    required this.onBookSlot,
    required this.onStartCharging,
  });

  @override
  State<StationDetailSheet> createState() => _StationDetailSheetState();
}

class _StationDetailSheetState extends State<StationDetailSheet> {
  int _selectedConnectorIndex = 0;

  @override
  Widget build(BuildContext context) {
    final station = widget.station;
    final selectedConnector = station.connectors.isNotEmpty
        ? station.connectors[_selectedConnectorIndex.clamp(0, station.connectors.length - 1)]
        : null;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Grab handle
              const SizedBox(height: 12),
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Image Header (Simulating Screen 8 top banner)
              Stack(
                children: [
                  Container(
                    height: 160,
                    margin: const EdgeInsets.symmetric(horizontal: 18),
                    decoration: BoxDecoration(
                      color: AppTheme.lightGreenBg,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppTheme.borderLight),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.ev_station, color: AppTheme.primaryGreen, size: 48),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            station.operator,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.primaryGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 28,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, size: 18, color: AppTheme.textPrimary),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 28,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.favorite_border, size: 18, color: AppTheme.textSecondary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Station Name & Rating (Screen 8)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            station.name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star, size: 14, color: AppTheme.amberRating),
                              const SizedBox(width: 4),
                              Text(
                                '${station.rating} (${station.totalReviews})',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF92400E),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Distance & Open 24 Hours
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 15, color: AppTheme.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          '${station.distanceKm} km',
                          style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                        ),
                        const Text(' • ', style: TextStyle(color: AppTheme.textMuted)),
                        const Text(
                          'Open 24 Hours',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryGreen,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${station.address}, ${station.city}',
                      style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                    ),
                    const SizedBox(height: 18),

                    // Amenities Row (Restroom, Cafe, Parking, Wi-Fi)
                    const Text(
                      'Station Amenities',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildAmenityItem(Icons.wc, 'Restroom'),
                        _buildAmenityItem(Icons.local_cafe, 'Cafe'),
                        _buildAmenityItem(Icons.local_parking, 'Parking'),
                        _buildAmenityItem(Icons.wifi, 'Wi-Fi'),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Available Chargers List (Screen 8)
                    const Text(
                      'Available Chargers',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),

                    ...station.connectors.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final connector = entry.value;
                      final isSelected = _selectedConnectorIndex == idx;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedConnectorIndex = idx;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isSelected ? AppTheme.lightGreenBg : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isSelected ? AppTheme.primaryGreen : AppTheme.borderLight,
                              width: isSelected ? 1.5 : 1.0,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isSelected ? AppTheme.primaryGreen : const Color(0xFFF1F5F9),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.bolt,
                                  color: isSelected ? Colors.white : AppTheme.primaryGreen,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      connector.name,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: AppTheme.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      '${connector.type} • ${connector.powerKw.toInt()} kW',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppTheme.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '₹${station.effectiveMemberTariff.toStringAsFixed(0)}/kWh',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    connector.isAvailable ? 'Available' : 'Busy',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: connector.isAvailable ? AppTheme.primaryGreen : AppTheme.coralRed,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    // 💬 Community Driver Reviews & Status Section
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Community Driver Reviews',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _showReportIssueDialog(context),
                          child: const Row(
                            children: [
                              Icon(Icons.flag_outlined, size: 14, color: AppTheme.coralRed),
                              SizedBox(width: 4),
                              Text(
                                'Report Issue',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.coralRed,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  CircleAvatar(
                                    radius: 12,
                                    backgroundColor: AppTheme.lightGreenBg,
                                    child: Text('AV', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppTheme.primaryGreen)),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Aman Verma • Nexon EV',
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                                  ),
                                ],
                              ),
                              Row(
                                children: List.generate(5, (i) => const Icon(Icons.star, size: 13, color: Colors.amber)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            '"Both CCS2 guns delivering solid 58 kW peak speed. Clean washrooms and Cafe right next door with 15% PlugMitra discount."',
                            style: TextStyle(fontSize: 12, color: AppTheme.textSecondary, height: 1.3),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Primary Action Buttons: Book Now (Screen 8) & Charge Now
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: widget.onBookSlot,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppTheme.primaryGreen,
                              side: const BorderSide(color: AppTheme.primaryGreen),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text(
                              'Book Slot',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: () {
                              if (selectedConnector != null) {
                                widget.onStartCharging();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryGreen,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 0,
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.bolt, size: 18),
                                SizedBox(width: 6),
                                Text(
                                  'Book Now',
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAmenityItem(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.borderLight),
          ),
          child: Icon(icon, color: AppTheme.primaryGreen, size: 22),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.textSecondary),
        ),
      ],
    );
  }

  void _showReportIssueDialog(BuildContext context) {
    String selectedIssue = 'Gun Damaged / Stiff Cable';
    final issues = [
      'Gun Damaged / Stiff Cable',
      'ICEing: Petrol car blocked bay',
      'RFID / Screen offline',
      'Slow charging speed (<20 kW)',
      'Cleanliness or lighting issue',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppTheme.borderLight,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Report Station Issue',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppTheme.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Help other EV drivers and dispatch PlugMitra ground ops at ${widget.station.name}.',
                    style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 14),
                  ...issues.map((iss) {
                    final isSel = selectedIssue == iss;
                    return InkWell(
                      onTap: () => setModalState(() => selectedIssue = iss),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Icon(
                              isSel ? Icons.radio_button_checked : Icons.radio_button_off,
                              color: isSel ? AppTheme.coralRed : AppTheme.textMuted,
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              iss,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                                color: isSel ? AppTheme.textPrimary : AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        widget.appState.reportStationIssue(widget.station.name, selectedIssue, 'Verified driver report');
                        Navigator.of(ctx).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Report submitted: "$selectedIssue". Ops team alerted! 🛡️'),
                            backgroundColor: AppTheme.primaryGreen,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.coralRed,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      child: const Text('Submit Report', style: TextStyle(fontWeight: FontWeight.w800)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
