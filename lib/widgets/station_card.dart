import 'package:flutter/material.dart';
import '../models/station.dart';
import '../models/vehicle.dart';
import '../theme/app_theme.dart';

class StationCard extends StatelessWidget {
  final ChargingStation station;
  final VoidCallback onTap;
  final VoidCallback onQuickCharge;
  final VoidCallback onBookSlot;

  const StationCard({
    super.key,
    required this.station,
    required this.onTap,
    required this.onQuickCharge,
    required this.onBookSlot,
  });

  @override
  Widget build(BuildContext context) {
    final hasAvailable = station.availablePorts > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Operator Badge & Distance
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: station.isPlugMitraOwned
                            ? AppTheme.lightGreenBg
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: station.isPlugMitraOwned
                              ? AppTheme.borderGreen
                              : AppTheme.borderLight,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            station.isPlugMitraOwned ? Icons.stars : Icons.verified,
                            size: 13,
                            color: station.isPlugMitraOwned
                                ? AppTheme.primaryGreen
                                : AppTheme.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            station.isPlugMitraOwned ? 'PlugMitra Official Hub' : station.operator,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: station.isPlugMitraOwned
                                  ? AppTheme.primaryGreen
                                  : AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.near_me, size: 14, color: AppTheme.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          '${station.distanceKm} km',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Station Main Info Row (Matching Screen 7 thumbnail layout)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Station Thumbnail
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: AppTheme.lightGreenBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.borderGreen.withOpacity(0.5)),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Icon(Icons.ev_station, color: AppTheme.primaryGreen, size: 30),
                          if (station.isPlugMitraOwned)
                            Positioned(
                              top: 4,
                              right: 4,
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
                    ),
                    const SizedBox(width: 14),

                    // Title & Specs
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  station.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.textPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.star, size: 14, color: AppTheme.amberRating),
                                  const SizedBox(width: 3),
                                  Text(
                                    station.rating.toString(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                '${station.distanceKm} km',
                                style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                              ),
                              const Text(' • ', style: TextStyle(color: AppTheme.textMuted)),
                              Text(
                                hasAvailable ? 'Available' : 'Busy',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: hasAvailable ? AppTheme.primaryGreen : AppTheme.coralRed,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '₹${station.effectiveMemberTariff.toStringAsFixed(0)}/kWh • ${station.isFastCharger ? "DC Fast" : "AC"} (${station.maxSpeedKw.toInt()} kW)',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.chevron_right, color: AppTheme.textMuted, size: 22),
                  ],
                ),
                const SizedBox(height: 12),

                // Tags Row: Available Guns, Heavy Truck, Categories
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: (hasAvailable ? AppTheme.lightGreenBg : const Color(0xFFFEE2E2)),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${station.availablePorts}/${station.totalPorts} Guns Free',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: hasAvailable ? AppTheme.primaryGreen : AppTheme.coralRed,
                        ),
                      ),
                    ),
                    if (station.hasHeavyTruckBay)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.local_shipping, size: 12, color: Color(0xFFB45309)),
                            SizedBox(width: 4),
                            Text(
                              'Truck Bay (240kW)',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFFB45309)),
                            ),
                          ],
                        ),
                      ),
                    ...station.supportedCategories.take(3).map((cat) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          cat.shortLabel,
                          style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary, fontWeight: FontWeight.w600),
                        ),
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1, color: AppTheme.borderLight),
                const SizedBox(height: 10),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onBookSlot,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.textPrimary,
                          side: const BorderSide(color: AppTheme.borderLight),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.calendar_today, size: 14, color: AppTheme.textSecondary),
                            SizedBox(width: 6),
                            Text('Book Slot', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onQuickCharge,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.bolt, size: 16),
                            SizedBox(width: 4),
                            Text('Charge Now', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
