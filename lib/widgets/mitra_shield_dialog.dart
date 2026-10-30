import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

class MitraShieldDialog extends StatefulWidget {
  final AppState appState;

  const MitraShieldDialog({super.key, required this.appState});

  @override
  State<MitraShieldDialog> createState() => _MitraShieldDialogState();
}

class _MitraShieldDialogState extends State<MitraShieldDialog> {
  String _selectedIncident = 'Monsoon Waterlogging & Underbody Splash';
  final TextEditingController _notesController = TextEditingController();
  bool _claimSubmitted = false;

  final List<String> _incidentTypes = [
    'Monsoon Waterlogging & Underbody Splash',
    'Public Charger Socket Arc Flash / High Voltage Spike',
    'Charging Gun Jammed in Inlet / Port Lock Damage',
    'Charging Cable Theft / Vandalism at Highway Station',
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: const Color(0xFF0284C7).withOpacity(0.4), width: 1.5),
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
                      color: const Color(0xFF0284C7).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.shield_rounded, color: Color(0xFF38BDF8), size: 26),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mitra Shield™ Platinum',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18),
                        ),
                        Text(
                          'Monsoon Flood & Battery Zero-Dep Protection',
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

              // Platinum Policy Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0369A1), Color(0xFF075985)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'POLICY ID: PM-SHIELD-EV-9821-ZERO',
                          style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.electricMint,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text('ACTIVE', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 10)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '₹10,00,000 Pack Cover',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 24),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Zero Depreciation • IP67 Flood Immersion Guarantee • 100% Cashless',
                      style: TextStyle(color: Color(0xFFBAE6FD), fontSize: 11),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // 4 Covered Perils
              const Text('Covered Perils & Guarantees', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 8),
              _buildPerilRow(Icons.water_drop_outlined, 'Monsoon Flood & Underbody Splash (Zero Deductible)'),
              _buildPerilRow(Icons.bolt_outlined, 'Public Charger Over-Voltage & Arc Flash Protection'),
              _buildPerilRow(Icons.lock_reset_outlined, 'Port Locking Mechanism Jam & Thermal Fusing'),
              _buildPerilRow(Icons.security_outlined, 'AI Battery Doctor SoH Verified Auto-Claim Approval'),
              const SizedBox(height: 18),

              // File Instant AI Claim Section
              if (!_claimSubmitted) ...[
                const Text('File Instant AI Cashless Claim', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedIncident,
                    isExpanded: true,
                    dropdownColor: const Color(0xFF1E293B),
                    underline: const SizedBox(),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    items: _incidentTypes.map((type) {
                      return DropdownMenuItem(value: type, child: Text(type, maxLines: 1, overflow: TextOverflow.ellipsis));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedIncident = val);
                    },
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _notesController,
                  maxLines: 2,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  decoration: InputDecoration(
                    hintText: 'Brief incident details (e.g. water level on road)...',
                    hintStyle: const TextStyle(color: Colors.white38, fontSize: 11),
                    filled: true,
                    fillColor: const Color(0xFF1E293B),
                    contentPadding: const EdgeInsets.all(12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.appState.submitShieldClaim(
                        incidentType: _selectedIncident,
                        description: _notesController.text.isEmpty ? 'Monsoon waterlogging claim' : _notesController.text,
                        estimatedDamageAmount: 48000.0,
                      );
                      setState(() => _claimSubmitted = true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0284C7),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.verified_rounded, color: Colors.white, size: 18),
                        SizedBox(width: 8),
                        Text('Submit with Battery Doctor Telemetry', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.primaryGreen),
                  ),
                  child: const Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.check_circle_rounded, color: AppTheme.electricMint, size: 24),
                          SizedBox(width: 10),
                          Text(
                            'Instant Pre-Approval Granted!',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Battery Doctor Telemetry attached: 98.2% SoH. Zero degradation confirmed. Cashless settlement code generated for authorized service center.',
                        style: TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPerilRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF38BDF8), size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: const TextStyle(color: Colors.white70, fontSize: 11)),
          ),
        ],
      ),
    );
  }
}
