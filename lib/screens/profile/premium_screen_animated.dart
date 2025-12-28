import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider_refactored.dart';
import '../../core/design/app_theme.dart';
import '../../core/widgets/animated_card.dart';
import '../../core/widgets/glass_button.dart';
import '../../core/animations/staggered_list.dart';
import '../../core/services/haptic_service.dart';

class PremiumScreenAnimated extends StatelessWidget {
  const PremiumScreenAnimated({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundCream,
      appBar: AppBar(
        title: const Text('Upgrade to Premium'),
        backgroundColor: AppTheme.backgroundCream,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(AppTheme.spacing20),
          child: StaggeredList(
            children: [
              // Hero Header
              AnimatedCard(
                gradient: AppTheme.warningGradient,
                boxShadow: AppTheme.glowShadow(AppTheme.warningAmber),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppTheme.spacing16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.star_rounded,
                        size: 48,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing16),
                    Text(
                      'Unlock Premium Features',
                      style: AppTheme.displayMedium.copyWith(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppTheme.spacing8),
                    Text(
                      'Get the most out of Drink Less Buddy',
                      style: AppTheme.bodyLarge.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacing32),

              Text('Premium Features', style: AppTheme.headlineLarge),
              const SizedBox(height: AppTheme.spacing16),

              // Feature Cards
              _buildFeatureCard(
                Icons.smart_toy,
                'AI-Powered Coach',
                '24/7 personalized support and encouragement based on your patterns',
                AppTheme.primaryBlue,
              ),
              const SizedBox(height: AppTheme.spacing12),
              _buildFeatureCard(
                Icons.notifications_active,
                'Smart Reminders',
                'Context-aware notifications at the right time to help you stick to your goals',
                AppTheme.secondaryGreen,
              ),
              const SizedBox(height: AppTheme.spacing12),
              _buildFeatureCard(
                Icons.analytics_outlined,
                'Advanced Analytics',
                'Deep insights into your drinking patterns, health impact estimates, and trends',
                AppTheme.accentPurple,
              ),
              const SizedBox(height: AppTheme.spacing12),
              _buildFeatureCard(
                Icons.all_inclusive,
                'Unlimited Logging',
                'No limits on drink tracking (free tier limited to 5 drinks/day)',
                AppTheme.warningAmber,
              ),
              const SizedBox(height: AppTheme.spacing12),
              _buildFeatureCard(
                Icons.cloud_outlined,
                'Cloud Backup',
                'Automatic backup and sync across devices',
                AppTheme.primaryBlue,
              ),
              const SizedBox(height: AppTheme.spacing12),
              _buildFeatureCard(
                Icons.psychology_outlined,
                'Personalized Tactic Recommendations',
                'AI suggests the most effective tactics for your specific patterns',
                AppTheme.secondaryGreen,
              ),
              const SizedBox(height: AppTheme.spacing32),

              Text('Pricing', style: AppTheme.headlineLarge),
              const SizedBox(height: AppTheme.spacing16),

              // Pricing Cards
              Row(
                children: [
                  Expanded(
                    child: _buildPricingCard(
                      'Monthly',
                      '£4.99',
                      'per month',
                      false,
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacing12),
                  Expanded(
                    child: _buildPricingCard(
                      'Yearly',
                      '£49.99',
                      'per year',
                      true,
                      savings: 'Save 17%',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacing24),

              // CTA Button
              GlassButton(
                text: 'Start Premium Trial',
                icon: Icons.star_rounded,
                gradient: AppTheme.warningGradient,
                onPressed: () async {
                  await HapticService.mediumImpact();
                  if (context.mounted) {
                    _upgradeToPremium(context);
                  }
                },
              ),
              const SizedBox(height: AppTheme.spacing12),

              Text(
                '7-day free trial, then £4.99/month. Cancel anytime.',
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.spacing24),

              // Why Premium
              AnimatedCard(
                color: AppTheme.primaryBlue.withOpacity(0.05),
                border: Border.all(
                  color: AppTheme.primaryBlue.withOpacity(0.3),
                  width: 2,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppTheme.spacing8),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                          ),
                          child: const Icon(
                            Icons.info_outline,
                            color: AppTheme.primaryBlue,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: AppTheme.spacing12),
                        Text('Why Premium?', style: AppTheme.titleLarge),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacing12),
                    Text(
                      'Research shows that personalized interventions increase effectiveness by 40%. Premium features provide the individualized support proven to maximize your success.',
                      style: AppTheme.bodyMedium.copyWith(
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
      ),
    );
  }

  Widget _buildFeatureCard(
    IconData icon,
    String title,
    String description,
    Color color,
  ) {
    return AnimatedCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(width: AppTheme.spacing16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: AppTheme.titleMedium,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacing8,
                        vertical: AppTheme.spacing4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.warningAmber,
                        borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                      ),
                      child: Text(
                        'PRO',
                        style: AppTheme.labelSmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacing4),
                Text(
                  description,
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textSecondary,
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
    return AnimatedCard(
      color: isPopular ? AppTheme.primaryBlue : Colors.white,
      border: Border.all(
        color: isPopular ? AppTheme.primaryBlue : AppTheme.textTertiary.withOpacity(0.3),
        width: 2,
      ),
      child: Column(
        children: [
          if (savings != null)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacing8,
                vertical: AppTheme.spacing4,
              ),
              decoration: BoxDecoration(
                color: isPopular ? Colors.white : AppTheme.secondaryGreen,
                borderRadius: BorderRadius.circular(AppTheme.radiusFull),
              ),
              child: Text(
                savings,
                style: AppTheme.labelSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isPopular ? AppTheme.primaryBlue : Colors.white,
                ),
              ),
            ),
          const SizedBox(height: AppTheme.spacing8),
          Text(
            title,
            style: AppTheme.titleMedium.copyWith(
              color: isPopular ? Colors.white : AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: AppTheme.spacing8),
          Text(
            price,
            style: AppTheme.displaySmall.copyWith(
              color: isPopular ? Colors.white : AppTheme.primaryBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            period,
            style: AppTheme.bodySmall.copyWith(
              color: isPopular ? Colors.white70 : AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  void _upgradeToPremium(BuildContext context) async {
    // In production, this would integrate with Stripe
    // For now, simulate the upgrade
    final userProvider = context.read<UserProvider>();
    await userProvider.upgradeToPremium();

    if (!context.mounted) return;

    await HapticService.success();
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.celebration, color: Colors.white),
            const SizedBox(width: 12),
            const Text('Welcome to Premium!'),
          ],
        ),
        backgroundColor: AppTheme.secondaryGreen,
      ),
    );
  }
}
