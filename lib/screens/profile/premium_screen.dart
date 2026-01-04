import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../utils/constants.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('Upgrade to Premium'),
        backgroundColor: AppConstants.backgroundColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppConstants.warningColor.withOpacity(0.8),
                    AppConstants.warningColor,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.star,
                    size: 64,
                    color: Colors.white,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Unlock Premium Features',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Get the most out of Drink Less Buddy',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Premium Features',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildFeatureCard(
              Icons.smart_toy,
              'AI-Powered Coach',
              '24/7 personalized support and encouragement based on your patterns',
              true,
            ),
            const SizedBox(height: 12),
            _buildFeatureCard(
              Icons.notifications_active,
              'Smart Reminders',
              'Context-aware notifications at the right time to help you stick to your goals',
              true,
            ),
            const SizedBox(height: 12),
            _buildFeatureCard(
              Icons.analytics,
              'Advanced Analytics',
              'Deep insights into your drinking patterns, health impact estimates, and trends',
              true,
            ),
            const SizedBox(height: 12),
            _buildFeatureCard(
              Icons.all_inclusive,
              'Unlimited Logging',
              'No limits on drink tracking (free tier limited to 5 drinks/day)',
              true,
            ),
            const SizedBox(height: 12),
            _buildFeatureCard(
              Icons.cloud,
              'Cloud Backup',
              'Automatic backup and sync across devices',
              true,
            ),
            const SizedBox(height: 12),
            _buildFeatureCard(
              Icons.psychology,
              'Personalized Tactic Recommendations',
              'AI suggests the most effective tactics for your specific patterns',
              true,
            ),
            const SizedBox(height: 24),
            const Text(
              'Pricing',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildPricingCard(
                    'Monthly',
                    AppConstants.premiumPriceMonthly,
                    'per month',
                    false,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPricingCard(
                    'Yearly',
                    AppConstants.premiumPriceYearly,
                    'per year',
                    true,
                    savings: 'Save 17%',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _upgradeToPremium(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.warningColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Start Premium Trial',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '7-day free trial, then £4.99/month. Cancel anytime.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppConstants.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                children: [
                  Text(
                    'Why Premium?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Research shows that personalized interventions increase effectiveness by 40%. Premium features provide the individualized support proven to maximize your success.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    IconData icon,
    String title,
    String description,
    bool isPremium,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppConstants.warningColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppConstants.warningColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (isPremium) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppConstants.warningColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'PRO',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingCard(
    String title,
    String price,
    String period,
    bool isPopular, {
    String? savings,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isPopular ? AppConstants.primaryColor : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPopular
              ? AppConstants.primaryColor
              : Colors.grey.shade300,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          if (savings != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isPopular
                    ? Colors.white
                    : AppConstants.secondaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                savings,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isPopular
                      ? AppConstants.primaryColor
                      : Colors.white,
                ),
              ),
            ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isPopular ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            price,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isPopular ? Colors.white : AppConstants.primaryColor,
            ),
          ),
          Text(
            period,
            style: TextStyle(
              fontSize: 12,
              color: isPopular ? Colors.white70 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  void _upgradeToPremium(BuildContext context) {
    // In production, this would integrate with Stripe
    // For now, simulate the upgrade
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.upgradeToPremium();

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.star, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text('Welcome to Premium!'),
          ],
        ),
        backgroundColor: AppConstants.secondaryColor,
      ),
    );
  }
}
