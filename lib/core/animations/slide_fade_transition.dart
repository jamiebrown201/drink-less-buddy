import 'package:flutter/material.dart';
import '../design/app_theme.dart';

/// Slide and fade transition for page routes
/// Creates smooth, polished navigation
class SlideFadeRoute<T> extends PageRoute<T> {
  final Widget page;
  final Duration duration;

  SlideFadeRoute({
    required this.page,
    this.duration = AppTheme.durationNormal,
  });

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => duration;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return page;
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(0.0, 0.03); // Slight vertical offset
    const end = Offset.zero;
    final tween = Tween(begin: begin, end: end);
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: AppTheme.curveEmphasized,
    );

    return SlideTransition(
      position: tween.animate(curvedAnimation),
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }
}

/// Extension for easy navigation with custom transition
extension NavigationExtension on BuildContext {
  Future<T?> pushWithSlide<T>(Widget page) {
    return Navigator.of(this).push<T>(
      SlideFadeRoute(page: page),
    );
  }

  Future<T?> pushReplacementWithSlide<T>(Widget page) {
    return Navigator.of(this).pushReplacement<T, void>(
      SlideFadeRoute(page: page),
    );
  }
}
