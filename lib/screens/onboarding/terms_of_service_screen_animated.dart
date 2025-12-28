import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider_refactored.dart';
import '../../core/design/app_theme.dart';
import '../../core/widgets/glass_button.dart';
import '../../core/widgets/animated_card.dart';
import '../../core/services/haptic_service.dart';
import '../../core/animations/slide_fade_transition.dart';
import 'welcome_screen_animated.dart';

class TermsOfServiceScreenAnimated extends StatefulWidget {
  const TermsOfServiceScreenAnimated({super.key});

  @override
  State<TermsOfServiceScreenAnimated> createState() =>
      _TermsOfServiceScreenAnimatedState();
}

class _TermsOfServiceScreenAnimatedState
    extends State<TermsOfServiceScreenAnimated> {
  bool _acceptedTerms = false;
  bool _acceptedPrivacy = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundCream,
      appBar: AppBar(
        title: const Text('Terms & Privacy'),
        backgroundColor: AppTheme.backgroundCream,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(AppTheme.spacing24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Terms of Service',
                      style: AppTheme.displaySmall,
                    ),
                    const SizedBox(height: AppTheme.spacing16),
                    _buildTermsSection(
                      '1. Acceptance of Terms',
                      'By using Drink Less Buddy, you agree to these Terms of Service. If you do not agree, do not use the app.',
                    ),
                    _buildTermsSection(
                      '2. Use of the App',
                      'You agree to use this app for personal, non-commercial purposes only. You are responsible for maintaining the confidentiality of your account.',
                    ),
                    _buildTermsSection(
                      '3. No Medical Advice',
                      'This app does not provide medical advice. Always seek the advice of your physician or other qualified health provider with any questions regarding alcohol consumption or dependency.',
                    ),
                    _buildTermsSection(
                      '4. Accuracy of Information',
                      'While we strive to provide accurate information based on research, we make no warranties about the completeness or accuracy of the content.',
                    ),
                    _buildTermsSection(
                      '5. User Data',
                      'You retain ownership of your data. By default, data is stored locally on your device. Premium users who enable cloud sync consent to data storage on our servers.',
                    ),
                    _buildTermsSection(
                      '6. Premium Features',
                      'Premium subscriptions are billed monthly or annually. You may cancel at any time. Refunds are subject to our refund policy.',
                    ),
                    const SizedBox(height: AppTheme.spacing24),
                    Text(
                      'Privacy Policy Summary',
                      style: AppTheme.displaySmall,
                    ),
                    const SizedBox(height: AppTheme.spacing16),
                    _buildTermsSection(
                      'Data Collection',
                      'We collect only data you provide: drink logs, moods, contexts, and intentions. We do not sell your data to third parties.',
                    ),
                    _buildTermsSection(
                      'Data Storage',
                      'Free tier: Data stored locally on your device.\nPremium tier: Optional cloud backup via encrypted servers (Supabase).',
                    ),
                    _buildTermsSection(
                      'Analytics',
                      'We collect anonymized usage data to improve the app. This does NOT include your personal drinking data.',
                    ),
                    _buildTermsSection(
                      'GDPR Compliance',
                      'EU users have the right to access, export, and delete their data at any time via the app settings.',
                    ),
                    _buildTermsSection(
                      'Data Retention',
                      'Your data is retained until you delete it or delete your account. Anonymized research data may be retained indefinitely.',
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Acceptance Section
            AnimatedCard(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
              child: Column(
                children: [
                  CheckboxListTile(
                    value: _acceptedTerms,
                    onChanged: (value) async {
                      await HapticService.selectionClick();
                      setState(() {
                        _acceptedTerms = value ?? false;
                      });
                    },
                    title: Text(
                      'I accept the Terms of Service',
                      style: AppTheme.bodyMedium,
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: AppTheme.primaryBlue,
                    contentPadding: EdgeInsets.zero,
                  ),
                  CheckboxListTile(
                    value: _acceptedPrivacy,
                    onChanged: (value) async {
                      await HapticService.selectionClick();
                      setState(() {
                        _acceptedPrivacy = value ?? false;
                      });
                    },
                    title: Text(
                      'I accept the Privacy Policy',
                      style: AppTheme.bodyMedium,
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: AppTheme.primaryBlue,
                    contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: AppTheme.spacing16),
                  GlassButton(
                    text: 'Continue',
                    icon: Icons.arrow_forward,
                    onPressed: (_acceptedTerms && _acceptedPrivacy)
                        ? () => _continueToApp(context)
                        : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermsSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTheme.titleMedium.copyWith(
              color: AppTheme.primaryBlue,
            ),
          ),
          const SizedBox(height: AppTheme.spacing8),
          Text(
            content,
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  void _continueToApp(BuildContext context) async {
    await HapticService.mediumImpact();

    final userProvider = context.read<UserProvider>();
    await userProvider.acceptTerms();

    if (!mounted) return;

    await HapticService.success();
    Navigator.of(context).pushReplacement(
      SlideFadeRoute(page: const WelcomeScreen()),
    );
  }
}
