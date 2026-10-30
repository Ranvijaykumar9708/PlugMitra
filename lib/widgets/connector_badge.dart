import 'package:flutter/material.dart';
import '../models/station.dart';
import '../theme/app_theme.dart';

class ConnectorBadge extends StatelessWidget {
  final ConnectorInfo connector;
  final bool isSelected;
  final VoidCallback? onTap;

  const ConnectorBadge({
    super.key,
    required this.connector,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isAvailable = connector.isAvailable;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.electricMint.withOpacity(0.12)
              : AppTheme.cardDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppTheme.electricMint
                : isAvailable
                    ? AppTheme.cardBorder
                    : Colors.white10,
            width: isSelected ? 1.8 : 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.electricMint.withOpacity(0.2)
                    : Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.ev_station,
                size: 18,
                color: isSelected
                    ? AppTheme.electricMint
                    : isAvailable
                        ? AppTheme.textPrimary
                        : AppTheme.textMuted,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  connector.name,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isAvailable ? AppTheme.textPrimary : AppTheme.textMuted,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isAvailable ? AppTheme.electricMint : AppTheme.amberBusy,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${connector.powerKw.toInt()} kW • ${connector.currentStatus}',
                      style: TextStyle(
                        fontSize: 11,
                        color: isAvailable ? AppTheme.electricMint : AppTheme.amberBusy,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
