import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class OfflineBadge extends StatelessWidget {
  const OfflineBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AgroColors.surfaceVariant,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AgroColors.outlineDark.withValues(alpha: 0.4), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: AgroColors.secondary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          const Icon(
            Icons.cloud_off,
            size: 13,
            color: AgroColors.secondary,
          ),
          const SizedBox(width: 4),
          const Text(
            'Mode Offline',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AgroColors.textSecondary,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}
