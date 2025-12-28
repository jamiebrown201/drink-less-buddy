import 'package:flutter/material.dart';
import '../error/failures.dart';
import '../../utils/constants.dart';

/// Reusable widget for displaying errors
/// Following DRY principle
class ErrorDisplay extends StatelessWidget {
  final Failure failure;
  final VoidCallback? onRetry;

  const ErrorDisplay({
    required this.failure,
    this.onRetry,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppConstants.dangerColor,
            ),
            const SizedBox(height: 16),
            const Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              failure.message,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Inline error message widget
class InlineErrorMessage extends StatelessWidget {
  final String message;

  const InlineErrorMessage({
    required this.message,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppConstants.dangerColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppConstants.dangerColor,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: AppConstants.dangerColor,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                color: AppConstants.dangerColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
