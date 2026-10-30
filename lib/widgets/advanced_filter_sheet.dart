import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

class AdvancedFilterSheet extends StatefulWidget {
  final AppState appState;

  const AdvancedFilterSheet({super.key, required this.appState});

  @override
  State<AdvancedFilterSheet> createState() => _AdvancedFilterSheetState();
}

class _AdvancedFilterSheetState extends State<AdvancedFilterSheet> {
  late String _selectedConnector;
  late double _minPowerKw;
  late bool _onlyAvailable;
  late bool _onlyPlugMitra;
  late bool _only24x7;
  late List<String> _selectedAmenities;

  final List<String> _connectorOptions = ['All', 'CCS-2', 'Type-2', 'CHAdeMO', 'GB/T'];
  final List<double> _speedOptions = [0.0, 22.0, 50.0, 120.0];
  final List<String> _availableAmenities = ['Café', 'Restroom', '24/7 Security', 'WiFi', 'Truck Bay'];

  @override
  void initState() {
    super.initState();
    _selectedConnector = widget.appState.filterConnector ?? 'All';
    _minPowerKw = widget.appState.minPowerKw;
    _onlyAvailable = widget.appState.onlyAvailable;
    _onlyPlugMitra = widget.appState.onlyPlugMitra;
    _only24x7 = widget.appState.only24x7;
    _selectedAmenities = List.from(widget.appState.selectedAmenities);
  }

  void _resetFilters() {
    setState(() {
      _selectedConnector = 'All';
      _minPowerKw = 0.0;
      _onlyAvailable = false;
      _onlyPlugMitra = false;
      _only24x7 = false;
      _selectedAmenities.clear();
    });
  }

  void _applyFilters() {
    widget.appState.setAdvancedFilters(
      connector: _selectedConnector == 'All' ? null : _selectedConnector,
      minPowerKw: _minPowerKw,
      onlyAvailable: _onlyAvailable,
      onlyPlugMitra: _onlyPlugMitra,
      only24x7: _only24x7,
      amenities: _selectedAmenities,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.borderLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filter Charging Stations',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.textPrimary,
                ),
              ),
              TextButton(
                onPressed: _resetFilters,
                child: const Text(
                  'Reset All',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔌 1. Connector Type
                  const Text(
                    'Connector Type',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _connectorOptions.map((conn) {
                      final isSelected = _selectedConnector == conn;
                      return ChoiceChip(
                        label: Text(conn),
                        selected: isSelected,
                        selectedColor: AppTheme.lightGreenBg,
                        backgroundColor: const Color(0xFFF8FAFC),
                        side: BorderSide(
                          color: isSelected ? AppTheme.primaryGreen : AppTheme.borderLight,
                        ),
                        labelStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? AppTheme.primaryGreen : AppTheme.textPrimary,
                        ),
                        onSelected: (val) {
                          if (val) setState(() => _selectedConnector = conn);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 18),

                  // ⚡ 2. Minimum Power Speed
                  const Text(
                    'Minimum Power Speed',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _speedOptions.map((speed) {
                      final isSelected = _minPowerKw == speed;
                      final label = speed == 0.0
                          ? 'Any Speed'
                          : speed == 22.0
                              ? 'Fast (≥ 22 kW)'
                              : speed == 50.0
                                  ? 'DC Fast (≥ 50 kW)'
                                  : 'HyperCharge (≥ 120 kW)';

                      return ChoiceChip(
                        label: Text(label),
                        selected: isSelected,
                        selectedColor: AppTheme.lightGreenBg,
                        backgroundColor: const Color(0xFFF8FAFC),
                        side: BorderSide(
                          color: isSelected ? AppTheme.primaryGreen : AppTheme.borderLight,
                        ),
                        labelStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? AppTheme.primaryGreen : AppTheme.textPrimary,
                        ),
                        onSelected: (val) {
                          if (val) setState(() => _minPowerKw = speed);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 18),

                  // ☕ 3. Amenities Filter
                  const Text(
                    'Amenities & Facilities',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _availableAmenities.map((amenity) {
                      final isSelected = _selectedAmenities.contains(amenity);
                      return FilterChip(
                        label: Text(amenity),
                        selected: isSelected,
                        selectedColor: AppTheme.lightGreenBg,
                        backgroundColor: const Color(0xFFF8FAFC),
                        side: BorderSide(
                          color: isSelected ? AppTheme.primaryGreen : AppTheme.borderLight,
                        ),
                        labelStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? AppTheme.primaryGreen : AppTheme.textPrimary,
                        ),
                        onSelected: (val) {
                          setState(() {
                            if (val) {
                              _selectedAmenities.add(amenity);
                            } else {
                              _selectedAmenities.remove(amenity);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 18),

                  // ⚙️ 4. Toggles
                  _buildToggleRow(
                    title: 'Available Ports Only',
                    subtitle: 'Show only stations with free guns ready right now',
                    value: _onlyAvailable,
                    onChanged: (val) => setState(() => _onlyAvailable = val),
                  ),
                  _buildToggleRow(
                    title: '⭐ PlugMitra SuperHubs Only',
                    subtitle: 'Direct member network with guaranteed 15% discount',
                    value: _onlyPlugMitra,
                    onChanged: (val) => setState(() => _onlyPlugMitra = val),
                  ),
                  _buildToggleRow(
                    title: '24/7 Open Stations',
                    subtitle: 'Accessible day & night with security staff',
                    value: _only24x7,
                    onChanged: (val) => setState(() => _only24x7 = val),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Apply Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _applyFilters,
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
                'Apply Filters',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleRow({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            activeColor: AppTheme.primaryGreen,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
