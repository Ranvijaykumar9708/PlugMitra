import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

class BayDeliverySheet extends StatefulWidget {
  final AppState appState;

  const BayDeliverySheet({super.key, required this.appState});

  @override
  State<BayDeliverySheet> createState() => _BayDeliverySheetState();
}

class _BayDeliverySheetState extends State<BayDeliverySheet> {
  int _selectedBrandIndex = 0;
  final List<String> _cartItems = [];
  double _cartTotal = 0.0;

  final List<Map<String, dynamic>> _brands = [
    {
      'name': 'Starbucks Coffee',
      'logo': '☕',
      'distance': 'In-Hub (Ground Floor)',
      'items': [
        {'name': 'Iced Caramel Macchiato', 'price': 345.0, 'tag': 'Popular'},
        {'name': 'Roasted Chicken & Cheese Croissant', 'price': 390.0, 'tag': 'Fresh'},
        {'name': 'Java Chip Frappuccino', 'price': 375.0, 'tag': 'Chilled'},
      ],
    },
    {
      'name': 'Haldiram\'s Express',
      'logo': '🍲',
      'distance': 'Food Court Bay 2',
      'items': [
        {'name': 'Chole Bhature Platter', 'price': 220.0, 'tag': 'Hot'},
        {'name': 'Special Highway Thali', 'price': 320.0, 'tag': 'Meals'},
        {'name': 'Masala Chai & Samosa (2 pcs)', 'price': 140.0, 'tag': 'Quick'},
      ],
    },
    {
      'name': 'McDonald\'s Highway Drive',
      'logo': '🍔',
      'distance': 'Drive-thru 50m',
      'items': [
        {'name': 'McSpicy Paneer Burger Meal', 'price': 285.0, 'tag': 'Combo'},
        {'name': 'McChicken & Fries Combo', 'price': 295.0, 'tag': 'Combo'},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final activeOrder = widget.appState.activeFoodOrder;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
                  color: const Color(0xFFE11D48).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.takeout_dining_rounded, color: Color(0xFFFB7185), size: 24),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bay-Delivery & In-Car Dine-In',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18),
                    ),
                    Text(
                      'Delivered straight to your EV car window while charging',
                      style: TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.amber),
                ),
                child: const Text('Bay #03', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Active Order Banner if exists
          if (activeOrder != null) ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppTheme.electricMint),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.delivery_dining_rounded, color: AppTheme.electricMint, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            activeOrder['orderId'] as String,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppTheme.electricMint.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'ETA ${activeOrder['etaMinutes']} Mins',
                          style: const TextStyle(color: AppTheme.electricMint, fontWeight: FontWeight.w800, fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${activeOrder['cafeName']} • ${activeOrder['status']}',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total: ₹${(activeOrder['totalAmount'] as double).toStringAsFixed(0)} (Paid via FastWallet)',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12),
                      ),
                      TextButton(
                        onPressed: () {
                          widget.appState.cancelBayFoodOrder();
                          setState(() {});
                        },
                        child: const Text('Cancel Order', style: TextStyle(color: Colors.redAccent, fontSize: 12)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // VIP Lounge & Shower Bay Door Access Pass
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFF1E1B4B), const Color(0xFF312E81).withOpacity(0.6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF818CF8).withOpacity(0.4)),
            ),
            child: Row(
              children: [
                const Icon(Icons.door_sliding_rounded, color: Color(0xFFA5B4FC), size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'VIP AC Lounge & Shower Bay Pass',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Digital Door Unlock: ${widget.appState.loungeAccessPin} • Clean Shower & Recliner Pods',
                        style: const TextStyle(color: Color(0xFFC7D2FE), fontSize: 11),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.lock_open_rounded, color: AppTheme.electricMint, size: 18),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Brand Selector Tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_brands.length, (index) {
                final isSelected = _selectedBrandIndex == index;
                final brand = _brands[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text('${brand['logo']} ${brand['name']}'),
                    selected: isSelected,
                    selectedColor: AppTheme.primaryGreen,
                    backgroundColor: const Color(0xFF1E293B),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.white70,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 12,
                    ),
                    onSelected: (val) {
                      if (val) setState(() => _selectedBrandIndex = index);
                    },
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 12),

          // Menu Items List
          ...(_brands[_selectedBrandIndex]['items'] as List<Map<String, dynamic>>).map((item) {
            final isAdded = _cartItems.contains(item['name']);
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['name'] as String,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        Text(
                          '₹${(item['price'] as double).toStringAsFixed(0)} • Fresh to Bay 03',
                          style: const TextStyle(color: Colors.white60, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (isAdded) {
                          _cartItems.remove(item['name']);
                          _cartTotal -= (item['price'] as double);
                        } else {
                          _cartItems.add(item['name'] as String);
                          _cartTotal += (item['price'] as double);
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isAdded ? Colors.redAccent.withOpacity(0.8) : AppTheme.primaryGreen,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(
                      isAdded ? 'Remove' : '+ Add',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 12),

          // Checkout Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _cartItems.isEmpty
                  ? null
                  : () {
                      final brand = _brands[_selectedBrandIndex];
                      widget.appState.placeBayFoodOrder(
                        cafeName: brand['name'] as String,
                        items: List.from(_cartItems),
                        totalAmount: _cartTotal,
                        bayNumber: 'Bay 03 (FastGun 120kW)',
                      );
                      setState(() {
                        _cartItems.clear();
                        _cartTotal = 0.0;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('🍔 Order placed! Thermal delivery to Bay 03 ETA 8 Mins.'),
                          backgroundColor: AppTheme.primaryGreen,
                        ),
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.electricMint,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(
                _cartItems.isEmpty
                    ? 'Select items to deliver to car'
                    : 'Dispatch Order to Bay 03 (₹${_cartTotal.toStringAsFixed(0)})',
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
