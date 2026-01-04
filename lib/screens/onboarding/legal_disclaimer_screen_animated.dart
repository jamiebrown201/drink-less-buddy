import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider_refactored.dart';
import '../../core/design/app_theme.dart';
import '../../core/widgets/glass_button.dart';
import '../../core/widgets/animated_card.dart';
import '../../core/animations/staggered_list.dart';
import '../../core/animations/slide_fade_transition.dart';
import '../../core/services/haptic_service.dart';
import 'welcome_screen_animated.dart';

class LegalDisclaimerScreenAnimated extends StatefulWidget {
  const LegalDisclaimerScreenAnimated({super.key});

  @override
  State<LegalDisclaimerScreenAnimated> createState() =>
      _LegalDisclaimerScreenAnimatedState();
}

class _LegalDisclaimerScreenAnimatedState
    extends State<LegalDisclaimerScreenAnimated> {
  bool _acceptedTerms = false;
  bool _acceptedPrivacy = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundCream,
      appBar: AppBar(
        title: const Text('Important Information'),
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
                child: StaggeredList(
                  children: [
                    // Warning Header
                    AnimatedCard(
                      color: AppTheme.warningAmber.withOpacity(0.1),
                      border: Border.all(
                        color: AppTheme.warningAmber,
                        width: 2,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.warning_amber_rounded,
                            color: AppTheme.warningAmber,
                            size: 32,
                          ),
                          const SizedBox(width: AppTheme.spacing12),
                          Expanded(
                            child: Text(
                              'Medical Disclaimer',
                              style: AppTheme.headlineMedium.copyWith(
                                color: AppTheme.warningAmber,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing24),

                    // Disclaimer Sections
                    _buildSection(
                      Icons.medical_services_outlined,
                      'Not a Medical Device',
                      'Drink Less Buddy is NOT a medical device, medical app, or diagnostic tool. It is an educational and behavioral support tool designed to help you track and reduce alcohol consumption.',
                    ),
                    _buildSection(
                      Icons.person_outline,
                      'Not a Substitute for Professional Help',
                      'This app is NOT a substitute for professional medical advice, diagnosis, or treatment. If you have concerns about alcohol dependency or Alcohol Use Disorder (AUD), please consult a qualified healthcare provider.',
                    ),
                    _buildSection(
                      Icons.local_hospital_outlined,
                      'When to Seek Professional Help',
                      'Please seek immediate professional help if you experience:\n\n• Inability to stop drinking despite wanting to\n• Withdrawal symptoms when not drinking\n• Drinking that interferes with work or relationships\n• Physical health problems related to alcohol\n• Mental health concerns (depression, anxiety)',
                    ),
                    _buildSection(
                      Icons.science_outlined,
                      'Evidence-Based But Not Medical',
                      'While our methods are based on peer-reviewed research and proven behavioral techniques, this app is designed for people who want to moderate their drinking, NOT for those with diagnosed alcohol dependence.',
                    ),
                    _buildSection(
                      Icons.support_outlined,
                      'Resources',
                      'UK: NHS Alcohol Support - www.nhs.uk/live-well/alcohol-advice\nUS: SAMHSA National Helpline - 1-800-662-4357\nAustralia: Alcohol Drug Information Service - 1800 250 015',
                    ),

                    const SizedBox(height: AppTheme.spacing24),

                    // Terms & Privacy Header
                    AnimatedCard(
                      color: AppTheme.primaryBlue.withOpacity(0.1),
                      border: Border.all(
                        color: AppTheme.primaryBlue.withOpacity(0.3),
                        width: 2,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.gavel_rounded,
                            color: AppTheme.primaryBlue,
                            size: 28,
                          ),
                          const SizedBox(width: AppTheme.spacing12),
                          Expanded(
                            child: Text(
                              'Terms & Privacy',
                              style: AppTheme.headlineMedium.copyWith(
                                color: AppTheme.primaryBlue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing16),

                    _buildTermsSection(
                      'Terms of Service',
                      'By using Drink Less Buddy, you agree to use this app for personal, non-commercial purposes only. This app does not provide medical advice. You retain ownership of your data, which is stored locally on your device by default.',
                    ),
                    _buildTermsSection(
                      'Privacy Policy',
                      'We collect only data you provide: drink logs, moods, and intentions. Your data is stored locally and we do not sell it to third parties. EU users have GDPR rights to access, export, and delete their data at any time.',
                    ),
                    _buildTermsSection(
                      'Data Storage',
                      'Free tier: Data stored locally on your device.\nPremium tier: Optional encrypted cloud backup available.',
                    ),

                    const SizedBox(height: AppTheme.spacing16),
                  ],
                ),
              ),
            ),

            // Bottom Acceptance Section
            Container(
              padding: const EdgeInsets.all(AppTheme.spacing24),
              decoration: BoxDecoration(
                color: AppTheme.surfaceWhite,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                      'I understand and accept the Terms of Service',
                      style: AppTheme.bodyMedium,
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: AppTheme.primaryBlue,
                    contentPadding: EdgeInsets.zero,
                    dense: true,
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
                    dense: true,
                  ),
                  const SizedBox(height: AppTheme.spacing16),
                  GlassButton(
                    text: 'I Understand - Continue',
                    icon: Icons.check_circle_outline,
                    onPressed: (_acceptedTerms && _acceptedPrivacy)
                        ? _continueToWelcome
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

  Widget _buildSection(IconData icon, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacing20),
      child: AnimatedCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacing8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  ),
                  child: Icon(
                    icon,
                    color: AppTheme.primaryBlue,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppTheme.spacing12),
                Expanded(
                  child: Text(
                    title,
                    style: AppTheme.titleMedium.copyWith(
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacing12),
            Text(
              content,
              style: AppTheme.bodyMedium.copyWith(
                height: 1.5,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermsSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacing12),
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

  void _continueToWelcome() async {
    await HapticService.mediumImpact();

    final userProvider = context.read<UserProvider>();
    await userProvider.acceptTerms();

    if (!mounted) return;

    await HapticService.success();
    Navigator.of(context).pushReplacement(
      SlideFadeRoute(page: const WelcomeScreenAnimated()),
    );
  }
}
