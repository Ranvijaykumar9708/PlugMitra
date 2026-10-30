import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

class VipMembershipSheet extends StatefulWidget {
  final AppState appState;

  const VipMembershipSheet({super.key, required this.appState});

  @override
  State<VipMembershipSheet> createState() => _VipMembershipSheetState();
}

class _VipMembershipSheetState extends State<VipMembershipSheet> {
  int _selectedPlanIndex = 1; // 0: Monthly (₹499), 1: Annual (₹4,499)

  @override
  Widget build(BuildContext context) {
    final isVip = widget.appState.isVipMember;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0B0F19),
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

            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.workspace_premium, color: Colors.black, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'PlugMitra Black VIP',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          isVip ? 'Active Elite Member' : 'Exclusive EV Privilege Club',
                          style: TextStyle(
                            fontSize: 12,
                            color: isVip ? AppTheme.electricMint : const Color(0xFFFFD700),
                            fontWeight: FontWeight.w600,
                          ),
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
            const SizedBox(height: 20),

            // VIP Membership Card Visual
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E293B), Color(0xFF0F172A), Color(0xFF020617)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: const Color(0xFFFFD700).withOpacity(0.4),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFD700).withOpacity(0.12),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
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
                        'PLUGMITRA BLACK',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2,
                          color: Color(0xFFFFD700),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD700).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          isVip ? 'ACTIVE VIP' : 'ELITE TIER',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFFFD700),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'PM-BLACK-0089-VIP',
                    style: TextStyle(
                      fontFamily: 'Courier',
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 3,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'MEMBER PRIVILEGE',
                            style: TextStyle(fontSize: 9, color: Colors.white54, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.appState.selectedVehicle.fullName,
                            style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      const Icon(Icons.contactless_rounded, color: Color(0xFFFFD700), size: 24),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // VIP Privileges List
            const Text(
              'Exclusive VIP Privileges',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white),
            ),
            const SizedBox(height: 12),
            _buildPrivilegeRow(
              Icons.bolt,
              'Flat 25% Off Super-Tariff',
              'Charge at ₹13.50/kWh instead of ₹18.00 across all verified hubs.',
            ),
            _buildPrivilegeRow(
              Icons.timer,
              '3-Hour Priority Slot Reservation',
              'Reserve charging bays 3 hours in advance with zero queue waiting.',
            ),
            _buildPrivilegeRow(
              Icons.weekend_rounded,
              'PlugMitra Executive Lounge Access',
              'Complimentary AC work pods, high-speed Wi-Fi & coffee while charging.',
            ),
            _buildPrivilegeRow(
              Icons.credit_card,
              'Laser-Engraved Metal Keycard',
              'Physical matte-black NFC RFID keycard delivered to your doorstep.',
            ),
            _buildPrivilegeRow(
              Icons.car_crash_rounded,
              '2x Free Mitra Rescue Dispatches',
              'On-demand mobile DC charging van SOS with zero service charge.',
            ),
            const SizedBox(height: 20),

            // Plan Selector (if not VIP)
            if (!isVip) ...[
              Row(
                children: [
                  Expanded(
                    child: _buildPlanOption(
                      index: 0,
                      title: 'Monthly Pass',
                      price: '₹499',
                      period: '/month',
                      subtext: 'Billed monthly',
                      badge: null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildPlanOption(
                      index: 1,
                      title: 'Annual VIP',
                      price: '₹4,499',
                      period: '/year',
                      subtext: 'Save ₹1,489 + Free Metal Card',
                      badge: 'MOST POPULAR',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],

            // Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (isVip) {
                    widget.appState.cancelVipMembership();
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('VIP membership cancelled.'),
                        backgroundColor: AppTheme.cardDark,
                      ),
                    );
                  } else {
                    widget.appState.upgradeVipMembership();
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('👑 Welcome to PlugMitra Black VIP Club! 25% tariff discount unlocked!'),
                        backgroundColor: Color(0xFF10B981),
                        duration: Duration(seconds: 4),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isVip ? Colors.redAccent.withOpacity(0.2) : const Color(0xFFFFD700),
                  foregroundColor: isVip ? Colors.redAccent : Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: isVip ? 0 : 4,
                ),
                child: Text(
                  isVip ? 'Cancel VIP Membership' : 'Join PlugMitra Black VIP Now',
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivilegeRow(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: const Color(0xFFFFD700).withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFFFFD700), size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 11, color: Colors.white60, height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanOption({
    required int index,
    required String title,
    required String price,
    required String period,
    required String subtext,
    String? badge,
  }) {
    final isSelected = _selectedPlanIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedPlanIndex = index),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFFFD700).withOpacity(0.1) : AppTheme.cardDark,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? const Color(0xFFFFD700) : AppTheme.cardBorder,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? const Color(0xFFFFD700) : Colors.white70,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      price,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white),
                    ),
                    Text(
                      period,
                      style: const TextStyle(fontSize: 10, color: Colors.white54),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtext,
                  style: const TextStyle(fontSize: 9, color: Colors.white54),
                ),
              ],
            ),
          ),
          if (badge != null)
            Positioned(
              top: -8,
              right: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD700),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Colors.black),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
