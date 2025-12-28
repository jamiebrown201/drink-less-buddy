import 'package:flutter/material.dart';
import '../design/app_theme.dart';
import 'animated_card.dart';
import 'pulse_animation.dart';

/// Stat card with animated number
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Gradient? gradient;
  final VoidCallback? onTap;
  final bool isPulsing;

  const StatCard({
    required this.label,
    required this.value,
    required this.icon,
    this.gradient,
    this.onTap,
    this.isPulsing = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = AnimatedCard(
      onTap: onTap,
      gradient: gradient,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(height: AppTheme.spacing12),
          Text(
            value,
            style: AppTheme.displayMedium.copyWith(
              color: gradient != null ? Colors.white : AppTheme.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacing4),
          Text(
            label,
            style: AppTheme.bodySmall.copyWith(
              color: gradient != null
                  ? Colors.white.withOpacity(0.8)
                  : AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );

    if (isPulsing) {
      return PulseAnimation(child: card);
    }

    return card;
  }
}
