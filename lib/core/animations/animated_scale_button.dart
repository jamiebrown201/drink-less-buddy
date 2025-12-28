import 'package:flutter/material.dart';
import '../design/app_theme.dart';
import '../services/haptic_service.dart';

/// Button that scales down on press with haptic feedback
/// Creates a tactile, responsive feel
class AnimatedScaleButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scale;
  final Duration duration;
  final bool enableHaptic;

  const AnimatedScaleButton({
    required this.child,
    required this.onTap,
    this.scale = 0.95,
    this.duration = AppTheme.durationFast,
    this.enableHaptic = true,
    super.key,
  });

  @override
  State<AnimatedScaleButton> createState() => _AnimatedScaleButtonState();
}

class _AnimatedScaleButtonState extends State<AnimatedScaleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scale,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: AppTheme.curveEmphasized,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onTapDown(TapDownDetails details) async {
    if (widget.onTap != null) {
      await _controller.forward();
      if (widget.enableHaptic) {
        await HapticService.lightImpact();
      }
    }
  }

  Future<void> _onTapUp(TapUpDetails details) async {
    await _controller.reverse();
  }

  Future<void> _onTapCancel() async {
    await _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}
