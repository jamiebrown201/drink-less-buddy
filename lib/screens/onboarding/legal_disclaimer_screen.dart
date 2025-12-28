import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../utils/constants.dart';
import 'terms_of_service_screen.dart';

class LegalDisclaimerScreen extends StatelessWidget {
  const LegalDisclaimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('Important Information'),
        backgroundColor: AppConstants.backgroundColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppConstants.warningColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppConstants.warningColor,
                    width: 2,
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: AppConstants.warningColor,
                      size: 32,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Medical Disclaimer',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.warningColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildSection(
                'Not a Medical Device',
                'Drink Less Buddy is NOT a medical device, medical app, or diagnostic tool. It is an educational and behavioral support tool designed to help you track and reduce alcohol consumption.',
              ),
              _buildSection(
                'Not a Substitute for Professional Help',
                'This app is NOT a substitute for professional medical advice, diagnosis, or treatment. If you have concerns about alcohol dependency or Alcohol Use Disorder (AUD), please consult a qualified healthcare provider.',
              ),
              _buildSection(
                'When to Seek Professional Help',
                'Please seek immediate professional help if you experience:\n\n• Inability to stop drinking despite wanting to\n• Withdrawal symptoms when not drinking\n• Drinking that interferes with work or relationships\n• Physical health problems related to alcohol\n• Mental health concerns (depression, anxiety)',
              ),
              _buildSection(
                'Evidence-Based But Not Medical',
                'While our methods are based on peer-reviewed research and proven behavioral techniques, this app is designed for people who want to moderate their drinking, NOT for those with diagnosed alcohol dependence.',
              ),
              _buildSection(
                'Data Privacy',
                'Your data is stored locally on your device. We do not share your drinking data with third parties. See our Privacy Policy for full details.',
              ),
              _buildSection(
                'Resources',
                'UK: NHS Alcohol Support - www.nhs.uk/live-well/alcohol-advice\nUS: SAMHSA National Helpline - 1-800-662-4357\nAustralia: Alcohol Drug Information Service - 1800 250 015',
                isLast: true,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => const TermsOfServiceScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'I Understand',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppConstants.primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
