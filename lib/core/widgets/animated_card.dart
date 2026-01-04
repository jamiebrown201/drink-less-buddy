import 'package:flutter/material.dart';
import '../design/app_theme.dart';
import '../animations/animated_scale_button.dart';

/// Animated card with hover effect and optional tap
class AnimatedCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final Gradient? gradient;
  final Color? color;
  final List<BoxShadow>? boxShadow;
  final double borderRadius;
  final Border? border;

  const AnimatedCard({
    required this.child,
    this.onTap,
    this.padding,
    this.gradient,
    this.color,
    this.boxShadow,
    this.borderRadius = AppTheme.radiusMedium,
    this.border,
    super.key,
  });

  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _elevation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppTheme.durationFast,
      vsync: this,
    );

    _elevation = Tween<double>(begin: 0.0, end: 8.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: AppTheme.curveDefault,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardContent = AnimatedBuilder(
      animation: _elevation,
      builder: (context, child) {
        return Container(
          padding: widget.padding ?? const EdgeInsets.all(AppTheme.spacing16),
          decoration: BoxDecoration(
            gradient: widget.gradient,
            color: widget.color ?? AppTheme.cardBackground,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: widget.border,
            boxShadow: widget.boxShadow ??
                [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04 + _elevation.value * 0.01),
                    blurRadius: 16 + _elevation.value,
                    offset: Offset(0, 4 + _elevation.value / 2),
                  ),
                ],
          ),
          child: widget.child,
        );
      },
    );

    if (widget.onTap == null) {
      return cardContent;
    }

    return MouseRegion(
      onEnter: (_) => _controller.forward(),
      onExit: (_) => _controller.reverse(),
      child: AnimatedScaleButton(
        onTap: widget.onTap,
        child: cardContent,
      ),
    );
  }
}
