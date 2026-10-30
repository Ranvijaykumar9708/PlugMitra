import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'payment_screen.dart';

class BookingScreen extends StatefulWidget {
  final AppState appState;

  const BookingScreen({super.key, required this.appState});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int _selectedStationIndex = 0;
  int _selectedConnectorIndex = 0;
  String _selectedDate = '25 Oct 2026';
  String _selectedSlot = '10:00 AM - 11:00 AM';

  final List<String> _timeSlots = [
    '08:00 AM - 09:00 AM',
    '10:00 AM - 11:00 AM',
    '12:30 PM - 01:30 PM',
    '03:00 PM - 04:00 PM',
    '06:00 PM - 07:00 PM',
    '08:30 PM - 09:30 PM',
  ];

  @override
  Widget build(BuildContext context) {
    final state = widget.appState;
    final stations = state.allStations;
    final selectedStation = stations.isNotEmpty
        ? stations[_selectedStationIndex.clamp(0, stations.length - 1)]
        : null;

    final connectors = selectedStation?.connectors ?? [];
    final selectedConnector = connectors.isNotEmpty
        ? connectors[_selectedConnectorIndex.clamp(0, connectors.length - 1)]
        : null;

    final tariff = selectedStation?.effectiveMemberTariff ?? 18.0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.textPrimary, size: 18),
          onPressed: () => widget.appState.setTabIndex(0),
        ),
        title: const Text(
          'Book a Slot',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppTheme.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Select Station / Charger
              const Text(
                'Select Station',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.borderLight),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: _selectedStationIndex,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.textSecondary),
                    items: stations.asMap().entries.map((entry) {
                      return DropdownMenuItem<int>(
                        value: entry.key,
                        child: Text(
                          entry.value.name,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedStationIndex = val;
                          _selectedConnectorIndex = 0;
                        });
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Select Charger Gun (CCS2 / Type 2)
              const Text(
                'Select Charger',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.borderLight),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: _selectedConnectorIndex.clamp(0, (connectors.length - 1).clamp(0, 100)),
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.textSecondary),
                    items: connectors.asMap().entries.map((entry) {
                      final c = entry.value;
                      return DropdownMenuItem<int>(
                        value: entry.key,
                        child: Text(
                          '${c.name} (${c.type} • ${c.powerKw.toInt()} kW)',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedConnectorIndex = val;
                        });
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // 2. Select Date
              const Text(
                'Select Date',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  final now = DateTime.now();
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: now,
                    firstDate: now,
                    lastDate: now.add(const Duration(days: 30)),
                  );
                  if (picked != null) {
                    setState(() {
                      _selectedDate = '${picked.day} Oct 2026';
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppTheme.borderLight),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedDate,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                      ),
                      const Icon(Icons.calendar_today, size: 18, color: AppTheme.primaryGreen),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // 3. Select Time Slot
              const Text(
                'Select Time',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _timeSlots.map((slot) {
                  final isSelected = _selectedSlot == slot;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedSlot = slot),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.lightGreenBg : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? AppTheme.primaryGreen : AppTheme.borderLight,
                          width: isSelected ? 1.5 : 1.0,
                        ),
                      ),
                      child: Text(
                        slot,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? AppTheme.primaryGreen : AppTheme.textPrimary,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // 4. Rate & Estimated Amount Summary Card (Exact replica of Screen 9)
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.borderLight),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Charging Rate', style: TextStyle(fontSize: 14, color: AppTheme.textSecondary)),
                        Text(
                          '₹${tariff.toStringAsFixed(0)}/kWh',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Estimated Amount', style: TextStyle(fontSize: 14, color: AppTheme.textSecondary)),
                        Text(
                          '₹200 - ₹400',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppTheme.primaryGreen),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Tip Box with green icon
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppTheme.lightGreenBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.bolt, color: AppTheme.primaryGreen, size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'You can start charging anytime within the selected slot.',
                        style: TextStyle(fontSize: 12, color: AppTheme.primaryGreen, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // 5. Proceed to Pay Button (Screen 9)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedStation != null && selectedConnector != null) {
                      widget.appState.createBooking(
                        station: selectedStation,
                        connector: selectedConnector,
                        slotTime: _selectedSlot,
                        estimatedCost: 300.0,
                      );
                    }
                    final booking = widget.appState.bookings.isNotEmpty ? widget.appState.bookings.first : null;

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PaymentScreen(
                          amount: 300,
                          stationName: selectedStation?.name ?? 'GreenCharge Station',
                          slotTime: _selectedSlot,
                          appState: widget.appState,
                          booking: booking,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Proceed to Pay',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
