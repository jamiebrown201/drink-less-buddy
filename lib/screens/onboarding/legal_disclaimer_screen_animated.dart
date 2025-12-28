import 'package:flutter/material.dart';
import '../../core/design/app_theme.dart';
import '../../core/widgets/glass_button.dart';
import '../../core/widgets/animated_card.dart';
import '../../core/animations/staggered_list.dart';
import '../../core/animations/slide_fade_transition.dart';
import '../../core/services/haptic_service.dart';
import 'terms_of_service_screen_animated.dart';

class LegalDisclaimerScreenAnimated extends StatelessWidget {
  const LegalDisclaimerScreenAnimated({super.key});

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

              // Sections
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
                Icons.lock_outline,
                'Data Privacy',
                'Your data is stored locally on your device. We do not share your drinking data with third parties. See our Privacy Policy for full details.',
              ),
              _buildSection(
                Icons.support_outlined,
                'Resources',
                'UK: NHS Alcohol Support - www.nhs.uk/live-well/alcohol-advice\nUS: SAMHSA National Helpline - 1-800-662-4357\nAustralia: Alcohol Drug Information Service - 1800 250 015',
              ),
              const SizedBox(height: AppTheme.spacing32),

              GlassButton(
                text: 'I Understand',
                icon: Icons.check_circle_outline,
                onPressed: () async {
                  await HapticService.mediumImpact();
                  if (context.mounted) {
                    Navigator.of(context).pushReplacement(
                      SlideFadeRoute(page: const TermsOfServiceScreenAnimated()),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(IconData icon, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacing24),
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
}
