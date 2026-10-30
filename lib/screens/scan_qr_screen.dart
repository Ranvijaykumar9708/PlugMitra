import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../state/app_state.dart';
import '../theme/app_theme.dart';

class ScanQrScreen extends StatefulWidget {
  final AppState appState;

  const ScanQrScreen({super.key, required this.appState});

  @override
  State<ScanQrScreen> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _laserController;
  bool _isFlashOn = false;
  final TextEditingController _manualIdCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _laserController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _laserController.dispose();
    _manualIdCtrl.dispose();
    super.dispose();
  }

  void _triggerScanSuccess() {
    // Pick first available station & connector matching user vehicle
    final vehicle = widget.appState.selectedVehicle;
    final station = widget.appState.allStations.firstWhere(
      (s) => s.supportsCategory(vehicle.category),
      orElse: () => widget.appState.allStations.first,
    );
    final connector = station.connectors.firstWhere(
      (c) => c.compatibleCategories.contains(vehicle.category) && c.isAvailable,
      orElse: () => station.connectors.first,
    );

    widget.appState.startChargingSession(
      station: station,
      connector: connector,
    );

    widget.appState.setTabIndex(3); // Switch to Live Charging Telemetry screen

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Connected to ${station.name}! Starting EV charge... ⚡'),
        backgroundColor: AppTheme.cardDark,
      ),
    );
  }

  void _showManualIdDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.surfaceDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: const BorderSide(color: AppTheme.cardBorder),
          ),
          title: const Text('Enter Charger ID'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Type the 6-digit Charger ID printed near the gun holster on the kiosk.',
                style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _manualIdCtrl,
                autofocus: true,
                textCapitalization: TextCapitalization.characters,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
                decoration: InputDecoration(
                  hintText: 'e.g. PM-8921',
                  hintStyle: const TextStyle(
                    color: AppTheme.textMuted,
                    letterSpacing: 1,
                  ),
                  filled: true,
                  fillColor: AppTheme.cardDark,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppTheme.cardBorder),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppTheme.textMuted),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _triggerScanSuccess();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.electricMint,
                foregroundColor: Colors.black,
              ),
              child: const Text(
                'Connect & Charge',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppTheme.bgDark,
        body: SafeArea(
          child: Column(
            children: [
              // Top Bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: 18,
                          ),
                          onPressed: () => widget.appState.setTabIndex(0),
                        ),
                        const Text(
                          'Scan QR Code',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            _isFlashOn ? Icons.flash_on : Icons.flash_off,
                            color: _isFlashOn
                                ? AppTheme.vibrantGreen
                                : Colors.white70,
                          ),
                          onPressed: () {
                            setState(() {
                              _isFlashOn = !_isFlashOn;
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.image_outlined,
                            color: Colors.white70,
                          ),
                          onPressed: () => _triggerScanSuccess(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Scan the QR code on the charger to start charging.',
                style: TextStyle(fontSize: 13, color: Colors.white70),
              ),
              const Spacer(),

              // Viewfinder Target Box with Animated Laser
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Camera Viewfinder Box
                    Container(
                      width: 270,
                      height: 270,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: AppTheme.cardBorder,
                          width: 1.5,
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Viewfinder Corner Brackets
                          CustomPaint(
                            size: const Size(270, 270),
                            painter: _ScannerCornersPainter(
                              color: AppTheme.electricMint,
                            ),
                          ),

                          // Animated Green Laser Scan Line
                          AnimatedBuilder(
                            animation: _laserController,
                            builder: (context, child) {
                              return Positioned(
                                top: 20 + (_laserController.value * 230),
                                left: 15,
                                right: 15,
                                child: Container(
                                  height: 3,
                                  decoration: BoxDecoration(
                                    color: AppTheme.electricMint,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.electricMint
                                            .withOpacity(0.8),
                                        blurRadius: 12,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    // Tap viewfinder to simulate instant scan
                    InkWell(
                      onTap: _triggerScanSuccess,
                      borderRadius: BorderRadius.circular(24),
                      child: const SizedBox(width: 270, height: 270),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Align QR code within frame or tap to test',
                style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
              ),

              const Spacer(),

              // AutoCharge Banner (if enabled)
              if (widget.appState.isAutoChargeEnabled)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppTheme.electricMint.withOpacity(0.4)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.bolt, color: AppTheme.electricMint, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'AutoCharge Active: Plug gun into ${widget.appState.selectedVehicle.name} to start.',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.electricMint),
                        ),
                      ),
                    ],
                  ),
                ),

              // Action Buttons: Virtual RFID Tap & Manual Charger ID
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _simulateRfidTap,
                        icon: const Icon(Icons.contactless_rounded, color: Colors.black, size: 20),
                        label: const Text(
                          'Tap Virtual RFID Keycard',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.electricMint,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _showManualIdDialog,
                        icon: const Icon(
                          Icons.keyboard_outlined,
                          color: Colors.white70,
                          size: 18,
                        ),
                        label: const Text(
                          'Enter Charger ID Manually',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white70,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: AppTheme.cardBorder,
                            width: 1.2,
                          ),
                          backgroundColor: AppTheme.cardDark,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50), // clearance for bottom navigation
            ],
          ),
        ),
      ),
    );
  }

  void _simulateRfidTap() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF0F172A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: AppTheme.primaryGreen.withOpacity(0.5)),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.contactless_rounded,
                  color: AppTheme.electricMint,
                  size: 48,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'NFC Tap Authenticated',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'Keycard PM-RFID-8921-IN approved.\nUnlocking charging gun...',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.white70, height: 1.4),
              ),
              const SizedBox(height: 22),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.electricMint),
              ),
              const SizedBox(height: 14),
            ],
          ),
        );
      },
    );

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        _triggerScanSuccess();
      }
    });
  }
}

class _ScannerCornersPainter extends CustomPainter {
  final Color color;

  _ScannerCornersPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const cornerLength = 32.0;

    // Top-Left
    canvas.drawLine(const Offset(0, 0), const Offset(cornerLength, 0), paint);
    canvas.drawLine(const Offset(0, 0), const Offset(0, cornerLength), paint);

    // Top-Right
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width - cornerLength, 0),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width, cornerLength),
      paint,
    );

    // Bottom-Left
    canvas.drawLine(
      Offset(0, size.height),
      Offset(cornerLength, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(0, size.height),
      Offset(0, size.height - cornerLength),
      paint,
    );

    // Bottom-Right
    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width - cornerLength, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width, size.height - cornerLength),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
