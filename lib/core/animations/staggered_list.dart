import 'package:flutter/material.dart';
import '../design/app_theme.dart';

/// Staggered animation for list items
/// Items appear one after another with a slight delay
class StaggeredList extends StatelessWidget {
  final List<Widget> children;
  final Duration delay;
  final Axis direction;

  const StaggeredList({
    required this.children,
    this.delay = const Duration(milliseconds: 50),
    this.direction = Axis.vertical,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return direction == Axis.vertical
        ? Column(
            children: _buildStaggeredChildren(),
          )
        : Row(
            children: _buildStaggeredChildren(),
          );
  }

  List<Widget> _buildStaggeredChildren() {
    return List.generate(
      children.length,
      (index) => StaggeredListItem(
        delay: delay * index,
        child: children[index],
      ),
    );
  }
}

/// Individual staggered list item
class StaggeredListItem extends StatefulWidget {
  final Widget child;
  final Duration delay;

  const StaggeredListItem({
    required this.child,
    required this.delay,
    super.key,
  });

  @override
  State<StaggeredListItem> createState() => _StaggeredListItemState();
}

class _StaggeredListItemState extends State<StaggeredListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppTheme.durationNormal,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: AppTheme.curveEmphasized,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: AppTheme.curveEmphasized,
      ),
    );

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}
