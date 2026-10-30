import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

class ArcadeZenLoungeSheet extends StatefulWidget {
  final AppState appState;

  const ArcadeZenLoungeSheet({super.key, required this.appState});

  @override
  State<ArcadeZenLoungeSheet> createState() => _ArcadeZenLoungeSheetState();
}

class _ArcadeZenLoungeSheetState extends State<ArcadeZenLoungeSheet> {
  int _selectedTabIndex = 0; // 0: Arcade, 1: Cinema OTT, 2: Zen Sleep Pod
  String _activeSound = 'Monsoon Rain';
  bool _isPlayingSound = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
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

            // Top Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFEC4899), Color(0xFF8B5CF6)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.sports_esports_rounded, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PlugMitra In-Car Lounge',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Entertainment While Fast Charging',
                          style: TextStyle(fontSize: 12, color: Colors.white60),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white54),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Tab Switcher
            Row(
              children: [
                Expanded(child: _buildLoungeTab(0, '🎮 Arcade')),
                const SizedBox(width: 8),
                Expanded(child: _buildLoungeTab(1, '🎬 Cinema OTT')),
                const SizedBox(width: 8),
                Expanded(child: _buildLoungeTab(2, '🧘 Zen Pod')),
              ],
            ),
            const SizedBox(height: 20),

            // Tab 0: Arcade
            if (_selectedTabIndex == 0) ...[
              _buildGameCard(
                'EV Hyperdrive 3D',
                'Dodge ICE traffic, collect green electrons & maximize regenerative braking.',
                'High Score: 14,820 pts',
                Icons.electric_bolt,
                const Color(0xFF10B981),
              ),
              const SizedBox(height: 12),
              _buildGameCard(
                'Clean Mobility Eco Quiz',
                'Test your battery & sustainability IQ. Win Mitra Wallet credits!',
                'Earn up to ₹50 cashback',
                Icons.psychology,
                const Color(0xFF3B82F6),
              ),
            ]
            // Tab 1: Cinema OTT
            else if (_selectedTabIndex == 1) ...[
              const Text(
                'OTT Stream Launcher (with Mini Charge Gauge)',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: _buildOttButton('YouTube', Icons.play_arrow, Colors.red)),
                  const SizedBox(width: 10),
                  Expanded(child: _buildOttButton('Netflix', Icons.movie_creation_outlined, Colors.redAccent)),
                  const SizedBox(width: 10),
                  Expanded(child: _buildOttButton('Hotstar', Icons.live_tv_rounded, Colors.blue)),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.cardDark,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.cardBorder),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.picture_in_picture_alt, color: AppTheme.electricMint, size: 22),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Video plays full screen with floating live battery HUD. Automatically alerts you at 80% charge.',
                        style: TextStyle(fontSize: 11, color: Colors.white70, height: 1.3),
                      ),
                    ),
                  ],
                ),
              ),
            ]
            // Tab 2: Zen Sleep Pod
            else ...[
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E293B), Color(0xFF334155)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white12),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.spa_rounded, color: Color(0xFF38BDF8), size: 36),
                    const SizedBox(height: 10),
                    const Text(
                      'Cabin Relaxation Sleep Pod',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Rest comfortably in your EV cabin while high-speed DC charging.',
                      style: TextStyle(fontSize: 11, color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    Wrap(
                      spacing: 8,
                      children: ['Monsoon Rain', 'Ocean Waves', 'White Noise', 'Forest Birds'].map((sound) {
                        final isSel = _activeSound == sound;
                        return ChoiceChip(
                          label: Text(sound, style: TextStyle(color: isSel ? Colors.black : Colors.white, fontSize: 11)),
                          selected: isSel,
                          selectedColor: const Color(0xFF38BDF8),
                          backgroundColor: AppTheme.cardDark,
                          onSelected: (val) {
                            setState(() {
                              _activeSound = sound;
                              _isPlayingSound = true;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() => _isPlayingSound = !_isPlayingSound);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(_isPlayingSound
                                ? 'Playing relaxing $_activeSound with 80% battery auto-wake alarm! 🧘'
                                : 'Zen audio stopped.'),
                            backgroundColor: const Color(0xFF0284C7),
                          ),
                        );
                      },
                      icon: Icon(_isPlayingSound ? Icons.stop : Icons.play_arrow, color: Colors.black),
                      label: Text(
                        _isPlayingSound ? 'Stop Relaxing Audio' : 'Play $_activeSound',
                        style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.black),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF38BDF8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLoungeTab(int index, String title) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTabIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF8B5CF6) : AppTheme.cardDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? const Color(0xFF8B5CF6) : AppTheme.cardBorder),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              color: isSelected ? Colors.white : Colors.white70,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGameCard(String title, String desc, String badge, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white)),
                const SizedBox(height: 3),
                Text(desc, style: const TextStyle(fontSize: 11, color: Colors.white60, height: 1.3)),
                const SizedBox(height: 6),
                Text(badge, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: color)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Launching $title in-car mini-game! 🎮'),
                  backgroundColor: color,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            ),
            child: const Text('Play', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildOttButton(String title, IconData icon, Color color) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Launching $title Stream Lounge with Battery Gauge Overlay! 🎬'),
            backgroundColor: color,
          ),
        );
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.cardDark,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.cardBorder),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 6),
            Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
