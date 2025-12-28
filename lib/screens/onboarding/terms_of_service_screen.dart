import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../utils/constants.dart';
import 'welcome_screen.dart';

class TermsOfServiceScreen extends StatefulWidget {
  const TermsOfServiceScreen({super.key});

  @override
  State<TermsOfServiceScreen> createState() => _TermsOfServiceScreenState();
}

class _TermsOfServiceScreenState extends State<TermsOfServiceScreen> {
  bool _acceptedTerms = false;
  bool _acceptedPrivacy = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('Terms & Privacy'),
        backgroundColor: AppConstants.backgroundColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Terms of Service',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
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
                    const SizedBox(height: 24),
                    const Text(
                      'Privacy Policy Summary',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
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
                      isLast: true,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CheckboxListTile(
                    value: _acceptedTerms,
                    onChanged: (value) {
                      setState(() {
                        _acceptedTerms = value ?? false;
                      });
                    },
                    title: const Text(
                      'I accept the Terms of Service',
                      style: TextStyle(fontSize: 15),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: AppConstants.primaryColor,
                  ),
                  CheckboxListTile(
                    value: _acceptedPrivacy,
                    onChanged: (value) {
                      setState(() {
                        _acceptedPrivacy = value ?? false;
                      });
                    },
                    title: const Text(
                      'I accept the Privacy Policy',
                      style: TextStyle(fontSize: 15),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: AppConstants.primaryColor,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: (_acceptedTerms && _acceptedPrivacy)
                        ? () => _continueToApp(context)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermsSection(String title, String content,
      {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppConstants.primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  void _continueToApp(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.acceptTerms();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
    );
  }
}
