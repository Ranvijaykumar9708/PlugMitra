import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

class CarbonMarketplaceSheet extends StatefulWidget {
  final AppState appState;

  const CarbonMarketplaceSheet({super.key, required this.appState});

  @override
  State<CarbonMarketplaceSheet> createState() => _CarbonMarketplaceSheetState();
}

class _CarbonMarketplaceSheetState extends State<CarbonMarketplaceSheet> {
  final List<Map<String, dynamic>> _catalog = [
    {
      'title': '₹500 Highway FASTag Free Toll Recharge',
      'tokens': 300.0,
      'icon': Icons.toll_rounded,
      'color': Colors.blueAccent,
      'badge': 'Instant Top-Up',
    },
    {
      'title': '100 kWh Highway Supercharge Pass',
      'tokens': 500.0,
      'icon': Icons.bolt_rounded,
      'color': AppTheme.electricMint,
      'badge': 'Zero Rupee Charging',
    },
    {
      'title': 'Starbucks Coffee & Sandwich Voucher',
      'tokens': 180.0,
      'icon': Icons.coffee_rounded,
      'color': const Color(0xFFFBBF24),
      'badge': 'Cafe Partner',
    },
    {
      'title': '3M Ceramic EV Glass & Paint Care Kit',
      'tokens': 650.0,
      'icon': Icons.auto_awesome_rounded,
      'color': const Color(0xFFA855F7),
      'badge': 'Home Delivery',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final tokens = widget.appState.greenCarbonTokens;
    final inrValue = tokens * 1.80;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.electricMint.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.eco_rounded, color: AppTheme.electricMint, size: 24),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mitra Green Tokens & ESG Market',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18),
                    ),
                    Text(
                      'Monetize clean solar charging & carbon avoidance',
                      style: TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Balance Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF064E3B), Color(0xFF047857), Color(0xFF059669)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryGreen.withOpacity(0.2),
                  blurRadius: 12,
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
                    const Text('Token Balance', style: TextStyle(color: Color(0xFFA7F3D0), fontSize: 12, fontWeight: FontWeight.bold)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('1 MGCT = ₹1.80', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 10)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '${tokens.toStringAsFixed(0)} MGCT',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 26),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '(₹${inrValue.toStringAsFixed(2)})',
                      style: const TextStyle(color: Color(0xFFD1FAE5), fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '🌱 ${widget.appState.co2AvoidedKg.toStringAsFixed(0)} kg CO₂ avoided • Equivalent to 84 mature trees planted',
                  style: const TextStyle(color: Color(0xFFA7F3D0), fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Sell to Corporate Buyers Button
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              children: [
                const Icon(Icons.business_center_rounded, color: AppTheme.electricMint, size: 24),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sell to Corporate ESG Buyers',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      Text(
                        'Tata Sustainability, Infosys & Wipro Green Funds buy credits instantly',
                        style: TextStyle(color: Colors.white60, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: tokens >= 500
                      ? () {
                          widget.appState.sellCarbonTokensToCorporate(500);
                          setState(() {});
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('🎉 500 MGCT sold! ₹900.00 credited to Mitra FastWallet!'),
                              backgroundColor: AppTheme.primaryGreen,
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.electricMint,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Sell 500', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 11)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Redeem Store Catalog
          const Text('Redeem Tokens for Real-World Perks', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 10),

          Expanded(
            child: ListView.builder(
              itemCount: _catalog.length,
              itemBuilder: (context, index) {
                final item = _catalog[index];
                final cost = item['tokens'] as double;
                final canAfford = tokens >= cost;

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: (item['color'] as Color).withOpacity(0.2),
                        child: Icon(item['icon'] as IconData, color: item['color'] as Color, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['title'] as String,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            Text(
                              '${cost.toStringAsFixed(0)} MGCT • ${item['badge']}',
                              style: const TextStyle(color: Colors.white60, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: canAfford
                            ? () {
                                widget.appState.redeemTokens(cost, item['title'] as String);
                                setState(() {});
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('🎉 Redeemed ${item['title']}! Voucher code sent to SMS.'),
                                    backgroundColor: AppTheme.primaryGreen,
                                  ),
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryGreen,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(
                          canAfford ? 'Redeem' : 'Need ${cost.toStringAsFixed(0)}',
                          style: TextStyle(
                            color: canAfford ? Colors.white : Colors.white38,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
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
}
