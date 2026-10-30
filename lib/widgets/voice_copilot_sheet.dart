import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

class VoiceCopilotSheet extends StatefulWidget {
  final AppState appState;

  const VoiceCopilotSheet({super.key, required this.appState});

  @override
  State<VoiceCopilotSheet> createState() => _VoiceCopilotSheetState();
}

class _VoiceCopilotSheetState extends State<VoiceCopilotSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  String? _detectedQuery;
  String? _aiResponse;
  bool _isProcessing = false;

  final List<String> _samplePrompts = [
    '⚡ Agra Expressway 60kW charger with cafe',
    '🛵 Nearest 2-Wheeler Ather Dot charger',
    '☀️ Find 100% Solar Green charging hub',
    '🔋 How much battery will I need for Jaipur?',
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _simulateVoiceCommand(String query) {
    setState(() {
      _detectedQuery = query;
      _isProcessing = true;
      _aiResponse = null;
    });

    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() {
        _isProcessing = false;
        if (query.contains('Solar')) {
          _aiResponse = 'Found GreenCharge Station with 100% Certified Rooftop Solar Power & 3 ports free!';
          widget.appState.toggleSolarFilter();
        } else if (query.contains('2-Wheeler') || query.contains('Ather')) {
          _aiResponse = 'Switching map to 2-Wheeler mode. Showing fast Ather Dot & Type-6 ports nearby.';
          widget.appState.setCategoryFilter(null);
          widget.appState.setFilterChip('All');
        } else {
          _aiResponse = 'Found 2 high-speed 60kW+ stations on your route with Coffee Shop and clean washrooms!';
          widget.appState.setFilterChip('Fast (>50kW)');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.mic, color: AppTheme.electricMint, size: 20),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Hey Mitra AI Voice Co-Pilot',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white54),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Pulsing Sound Wave Graphic
          AnimatedBuilder(
            animation: _animController,
            builder: (context, child) {
              final scale = 1.0 + (_animController.value * 0.18);
              return Container(
                width: 80 * scale,
                height: 80 * scale,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primaryGreen.withOpacity(0.15),
                  border: Border.all(
                    color: AppTheme.electricMint.withOpacity(0.5 - (_animController.value * 0.3)),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.electricMint.withOpacity(0.2),
                      blurRadius: 20 * scale,
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.electricMint,
                    ),
                    child: const Icon(Icons.mic, color: Colors.black, size: 28),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),

          Text(
            _isProcessing
                ? 'Processing voice intent...'
                : _detectedQuery != null
                    ? '"$_detectedQuery"'
                    : 'Listening... (Boliye, mai sun raha hu)',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: _detectedQuery != null ? AppTheme.electricMint : Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // AI Response Bubble if available
          if (_aiResponse != null) ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.cardDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.electricMint.withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome, color: AppTheme.electricMint, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _aiResponse!,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white, height: 1.3),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.electricMint,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('View on Map', style: TextStyle(fontWeight: FontWeight.w800)),
              ),
            ),
          ] else ...[
            const Text(
              'Or tap a quick voice command:',
              style: TextStyle(fontSize: 11, color: Colors.white54, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: _samplePrompts.map((prompt) {
                return GestureDetector(
                  onTap: () => _simulateVoiceCommand(prompt),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.cardDark,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.cardBorder),
                    ),
                    child: Text(
                      prompt,
                      style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
