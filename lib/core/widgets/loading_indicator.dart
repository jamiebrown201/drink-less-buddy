import 'package:flutter/material.dart';
import '../../utils/constants.dart';

/// Reusable loading indicator widget
/// Following DRY principle
class LoadingIndicator extends StatelessWidget {
  final String? message;
  final double size;

  const LoadingIndicator({
    this.message,
    this.size = 40,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                AppConstants.primaryColor,
              ),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// Inline loading indicator (for smaller spaces)
class InlineLoadingIndicator extends StatelessWidget {
  const InlineLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            AppConstants.primaryColor,
          ),
        ),
      ),
    );
  }
}
