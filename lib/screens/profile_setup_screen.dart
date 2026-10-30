import 'package:flutter/material.dart';
import '../state/app_state.dart';
import 'main_shell.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final TextEditingController _nameCtrl = TextEditingController(text: 'Ranvijay Kumar');
  String _selectedVehicleType = 'Electric Car';
  String _selectedVehicleModel = 'Tata Nexon EV';
  String _selectedConnector = 'CCS2';

  final List<String> _vehicleTypes = [
    'Electric Car',
    '2-Wheeler (Scooter/Bike)',
    '3-Wheeler (Auto/Cargo)',
    'Commercial Truck / Van',
  ];

  final Map<String, List<String>> _modelOptions = {
    'Electric Car': ['Tata Nexon EV', 'MG ZS EV', 'Mahindra XUV400', 'Hyundai Ioniq 5'],
    '2-Wheeler (Scooter/Bike)': ['Ather 450X Apex', 'Ola S1 Pro', 'TVS iQube'],
    '3-Wheeler (Auto/Cargo)': ['Mahindra Treo Auto', 'Piaggio Ape E-City'],
    'Commercial Truck / Van': ['Tata Ace EV Commercial', 'Tata Ultra T.7 Electric Truck'],
  };

  final Map<String, List<String>> _connectorOptions = {
    'Electric Car': ['CCS2', 'Type 2'],
    '2-Wheeler (Scooter/Bike)': ['Ather Dot/Type-6', '16A Plug'],
    '3-Wheeler (Auto/Cargo)': ['Bharat AC-001', '16A Industrial'],
    'Commercial Truck / Van': ['CCS2 Fast', 'CCS-2 Heavy DC'],
  };

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  void _onSaveAndContinue() {
    // Navigate into main shell
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => MainShell(appState: AppState()),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final models = _modelOptions[_selectedVehicleType] ?? ['Tata Nexon EV'];
    final connectors = _connectorOptions[_selectedVehicleType] ?? ['CCS2'];

    if (!models.contains(_selectedVehicleModel)) {
      _selectedVehicleModel = models.first;
    }
    if (!connectors.contains(_selectedConnector)) {
      _selectedConnector = connectors.first;
    }

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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Complete Your Profile',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 24),

              // Full Name Field
              _buildFieldLabel('Full Name'),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
                ),
                child: TextField(
                  controller: _nameCtrl,
                  style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Vehicle Type Dropdown
              _buildFieldLabel('Vehicle Type'),
              const SizedBox(height: 8),
              _buildDropdown(
                value: _selectedVehicleType,
                items: _vehicleTypes,
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedVehicleType = val;
                      _selectedVehicleModel = _modelOptions[val]?.first ?? '';
                      _selectedConnector = _connectorOptions[val]?.first ?? '';
                    });
                  }
                },
              ),
              const SizedBox(height: 20),

              // Vehicle Model Dropdown
              _buildFieldLabel('Vehicle Model'),
              const SizedBox(height: 8),
              _buildDropdown(
                value: _selectedVehicleModel,
                items: models,
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedVehicleModel = val;
                    });
                  }
                },
              ),
              const SizedBox(height: 20),

              // Connector Type Dropdown
              _buildFieldLabel('Connector Type'),
              const SizedBox(height: 8),
              _buildDropdown(
                value: _selectedConnector,
                items: connectors,
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedConnector = val;
                    });
                  }
                },
              ),
              const SizedBox(height: 40),

              // Save & Continue Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onSaveAndContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C853),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Save & Continue',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xFF64748B),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.contains(value) ? value : items.first,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF64748B)),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1E293B), fontSize: 14),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
