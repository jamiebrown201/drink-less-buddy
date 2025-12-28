import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider_refactored.dart';
import '../../core/design/app_theme.dart';
import '../../core/widgets/glass_button.dart';
import '../../core/services/haptic_service.dart';
import '../../core/animations/slide_fade_transition.dart';
import 'legal_disclaimer_screen_animated.dart';

class AgeVerificationScreenAnimated extends StatelessWidget {
  const AgeVerificationScreenAnimated({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundCream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacing24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(AppTheme.spacing24),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.verified_user,
                  size: 80,
                  color: AppTheme.primaryBlue,
                ),
              ),
              const SizedBox(height: AppTheme.spacing32),

              // Title
              Text(
                'Age Verification',
                style: AppTheme.displayLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.spacing16),

              // Description
              Text(
                'This app is designed to help adults reduce their alcohol consumption. You must be 18 or older to use Drink Less Buddy.',
                style: AppTheme.bodyLarge.copyWith(
                  color: AppTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.spacing48),

              // Confirm Age Button
              GlassButton(
                text: 'I am 18 or older',
                icon: Icons.check_circle_outline,
                onPressed: () async {
                  await HapticService.mediumImpact();
                  if (context.mounted) {
                    _confirmAge(context, true);
                  }
                },
              ),
              const SizedBox(height: AppTheme.spacing16),

              // Under Age Button
              OutlineButton(
                text: 'I am under 18',
                icon: Icons.cancel_outlined,
                color: AppTheme.dangerRose,
                onPressed: () async {
                  await HapticService.lightImpact();
                  if (context.mounted) {
                    _confirmAge(context, false);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmAge(BuildContext context, bool isOver18) async {
    if (isOver18) {
      final userProvider = context.read<UserProvider>();
      await userProvider.confirmAge();

      if (!context.mounted) return;

      await HapticService.success();
      Navigator.of(context).pushReplacement(
        SlideFadeRoute(page: const LegalDisclaimerScreenAnimated()),
      );
    } else {
      await HapticService.error();
      if (!context.mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
          title: Row(
            children: [
              const Icon(Icons.block, color: AppTheme.dangerRose),
              const SizedBox(width: AppTheme.spacing12),
              const Text('Access Denied'),
            ],
          ),
          content: Text(
            'We\'re sorry, but you must be 18 or older to use this app. If you\'re concerned about your drinking or someone else\'s, please speak to a parent, guardian, or trusted adult.',
            style: AppTheme.bodyMedium.copyWith(height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
