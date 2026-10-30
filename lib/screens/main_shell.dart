import 'package:flutter/material.dart';
import '../models/charging_session.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'discover_screen.dart';
import 'live_charging_screen.dart';
import 'booking_screen.dart';
import 'scan_qr_screen.dart';
import 'wallet_profile_screen.dart';
import 'charging_completed_screen.dart';

class MainShell extends StatelessWidget {
  final AppState appState;

  const MainShell({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    final activeSession = appState.activeSession;
    final isCharging = activeSession != null && activeSession.status == SessionStatus.charging;
    final isCompleted = activeSession != null && activeSession.status == SessionStatus.completed;

    // 5-Tab Screens matching the user's design board
    final screens = [
      DiscoverScreen(appState: appState),       // Tab 0: Home / Map (Screen 6 & 7)
      BookingScreen(appState: appState),        // Tab 1: Bookings (Screen 9)
      ScanQrScreen(appState: appState),         // Tab 2: Scan & Charge (Screen 11)
      LiveChargingScreen(appState: appState),   // Tab 3: Live Telemetry (Screen 12)
      WalletProfileScreen(appState: appState),  // Tab 4: History & Profile (Screen 14)
    ];

    return Scaffold(
      body: Stack(
        children: [
          // Current Selected Screen
          IndexedStack(
            index: appState.currentTabIndex.clamp(0, screens.length - 1),
            children: screens,
          ),

          // Fullscreen Charging Completed Overlay when finished (matching Screen 13!)
          if (isCompleted)
            Positioned.fill(
              child: ChargingCompletedScreen(
                session: activeSession,
                onDismiss: () {
                  appState.dismissCompletedSession();
                },
              ),
            ),

          // Floating Mini Telemetry Bar when session is active and user is on another tab
          if (isCharging && appState.currentTabIndex != 3 && !isCompleted)
            Positioned(
              left: 18,
              right: 18,
              bottom: 84,
              child: GestureDetector(
                onTap: () => appState.setTabIndex(3),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.primaryGreen, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryGreen.withOpacity(0.18),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: AppTheme.lightGreenBg,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.bolt, color: AppTheme.primaryGreen, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Charging ${activeSession.vehicle.model}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            Text(
                              '${activeSession.currentPowerKw.toStringAsFixed(1)} kW • ${activeSession.remainingMinutes} min to ${activeSession.targetPercent.toInt()}%',
                              style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGreen,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${activeSession.currentPercent.toStringAsFixed(0)}%',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Dynamic Bottom Navigation Bar: Dark mode on Live/Scan tabs, Crisp White on Home/Bookings/Profile
          if (!isCompleted)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Builder(
                builder: (context) {
                  final isDarkTab = appState.currentTabIndex == 2 || appState.currentTabIndex == 3;

                  return Container(
                    padding: const EdgeInsets.only(top: 8, bottom: 14),
                    decoration: BoxDecoration(
                      color: isDarkTab ? const Color(0xFF0F1E17) : Colors.white,
                      border: Border(
                        top: BorderSide(
                          color: isDarkTab ? const Color(0xFF1E3529) : AppTheme.borderLight,
                          width: 1,
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDarkTab ? 0.4 : 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildNavItem(
                          index: 0,
                          icon: Icons.home_outlined,
                          activeIcon: Icons.home,
                          label: 'Home',
                          isDark: isDarkTab,
                        ),
                        _buildNavItem(
                          index: 1,
                          icon: Icons.calendar_today_outlined,
                          activeIcon: Icons.calendar_month,
                          label: 'Bookings',
                          isDark: isDarkTab,
                        ),
                        _buildCenterScanButton(isDark: isDarkTab),
                        _buildNavItem(
                          index: 3,
                          icon: Icons.bolt_outlined,
                          activeIcon: Icons.bolt,
                          label: 'Live',
                          hasActiveBadge: isCharging,
                          isDark: isDarkTab,
                        ),
                        _buildNavItem(
                          index: 4,
                          icon: Icons.person_outline,
                          activeIcon: Icons.person,
                          label: 'Profile',
                          isDark: isDarkTab,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCenterScanButton({bool isDark = false}) {
    final isSelected = appState.currentTabIndex == 2;

    return GestureDetector(
      onTap: () => appState.setTabIndex(2),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.vibrantGreen : AppTheme.primaryGreen,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryGreen.withOpacity(0.35),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Icon(
          Icons.qr_code_scanner,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    bool hasActiveBadge = false,
    bool isDark = false,
  }) {
    final isSelected = appState.currentTabIndex == index;
    final activeColor = isDark ? AppTheme.electricMint : AppTheme.primaryGreen;
    final inactiveColor = isDark ? Colors.white60 : AppTheme.textSecondary;

    return InkWell(
      onTap: () => appState.setTabIndex(index),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  isSelected ? activeIcon : icon,
                  size: 22,
                  color: isSelected ? activeColor : inactiveColor,
                ),
                if (hasActiveBadge)
                  Positioned(
                    right: -4,
                    top: -2,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppTheme.vibrantGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? activeColor : inactiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
