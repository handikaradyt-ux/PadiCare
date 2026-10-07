import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum BadgeVariant {
  healthy,
  warning,
  uncertain,
  error,
  neutral,
}

class StatusBadge extends StatelessWidget {
  final String label;
  final IconData icon;
  final BadgeVariant variant;

  const StatusBadge({
    super.key,
    required this.label,
    required this.icon,
    this.variant = BadgeVariant.neutral,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color border;
    Color textColor;

    switch (variant) {
      case BadgeVariant.healthy:
        bg = AgroColors.healthyBg;
        border = AgroColors.healthyBorder;
        textColor = AgroColors.healthy;
        break;
      case BadgeVariant.warning:
        bg = AgroColors.warningBg;
        border = AgroColors.warningBorder;
        textColor = AgroColors.warning;
        break;
      case BadgeVariant.uncertain:
        bg = AgroColors.uncertainBg;
        border = AgroColors.uncertainBorder;
        textColor = AgroColors.uncertain;
        break;
      case BadgeVariant.error:
        bg = AgroColors.errorBg;
        border = AgroColors.errorBorder;
        textColor = AgroColors.error;
        break;
      case BadgeVariant.neutral:
        bg = AgroColors.surfaceVariant;
        border = AgroColors.outline;
        textColor = AgroColors.textPrimary;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: border, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: textColor),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: textColor,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}
