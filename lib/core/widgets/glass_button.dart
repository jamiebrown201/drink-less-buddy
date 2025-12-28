import 'package:flutter/material.dart';
import '../design/app_theme.dart';
import '../animations/animated_scale_button.dart';

/// Modern glass-morphism button
class GlassButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Gradient? gradient;
  final bool isLoading;
  final double? width;

  const GlassButton({
    required this.text,
    required this.onPressed,
    this.icon,
    this.gradient,
    this.isLoading = false,
    this.width,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      width: width ?? double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacing24,
        vertical: AppTheme.spacing16,
      ),
      decoration: BoxDecoration(
        gradient: gradient ?? AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        boxShadow: AppTheme.glowShadow(
          gradient != null
            ? (gradient as LinearGradient).colors.first
            : AppTheme.primaryBlue,
        ),
      ),
      child: isLoading
          ? const Center(
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: Colors.white, size: 20),
                  const SizedBox(width: AppTheme.spacing8),
                ],
                Text(
                  text,
                  style: AppTheme.titleMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
    );

    if (onPressed == null || isLoading) {
      return Opacity(
        opacity: 0.5,
        child: content,
      );
    }

    return AnimatedScaleButton(
      onTap: onPressed,
      child: content,
    );
  }
}

/// Secondary outline button with animation
class OutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? color;

  const OutlineButton({
    required this.text,
    required this.onPressed,
    this.icon,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? AppTheme.primaryBlue;

    Widget content = Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacing24,
        vertical: AppTheme.spacing16,
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
          color: buttonColor,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, color: buttonColor, size: 20),
            const SizedBox(width: AppTheme.spacing8),
          ],
          Text(
            text,
            style: AppTheme.titleMedium.copyWith(
              color: buttonColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );

    if (onPressed == null) {
      return Opacity(opacity: 0.5, child: content);
    }

    return AnimatedScaleButton(
      onTap: onPressed,
      child: content,
    );
  }
}
