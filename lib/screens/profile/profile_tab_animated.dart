import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider_refactored.dart';
import '../../providers/drink_provider_refactored.dart';
import '../../providers/intention_provider_refactored.dart';
import '../../core/design/app_theme.dart';
import '../../core/widgets/animated_card.dart';
import '../../core/widgets/glass_button.dart';
import '../../core/animations/staggered_list.dart';
import '../../core/animations/slide_fade_transition.dart';
import '../../core/services/haptic_service.dart';
import 'premium_screen_animated.dart';

class ProfileTabAnimated extends StatelessWidget {
  const ProfileTabAnimated({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundCream,
      body: SafeArea(
        child: Consumer<UserProvider>(
          builder: (context, userProvider, _) {
            final user = userProvider.user;
            if (user == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // App Bar
                SliverAppBar(
                  expandedHeight: 120,
                  floating: true,
                  pinned: false,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Padding(
                      padding: const EdgeInsets.all(AppTheme.spacing20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Profile & Settings',
                            style: AppTheme.displayMedium,
                          ),
                          const SizedBox(height: AppTheme.spacing4),
                          Text(
                            'Manage your account and preferences',
                            style: AppTheme.bodyMedium.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Main Content
                SliverPadding(
                  padding: const EdgeInsets.all(AppTheme.spacing20),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      StaggeredList(
                        children: [
                          // Premium Status
                          if (!user.isPremium)
                            _buildPremiumPromotionCard(context)
                          else
                            _buildPremiumStatusCard(),
                          const SizedBox(height: AppTheme.spacing24),

                          // Weekly Goal
                          _buildGoalCard(context, user, userProvider),
                          const SizedBox(height: AppTheme.spacing24),

                          // Settings Section
                          Text('Settings', style: AppTheme.headlineLarge),
                          const SizedBox(height: AppTheme.spacing12),
                          _buildSettingsCard(context, userProvider),
                          const SizedBox(height: AppTheme.spacing24),

                          // Data Management
                          Text('Data Management', style: AppTheme.headlineLarge),
                          const SizedBox(height: AppTheme.spacing12),
                          _buildDataManagementCard(context),
                          const SizedBox(height: AppTheme.spacing24),

                          // About
                          _buildAboutCard(),
                        ],
                      ),
                    ]),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPremiumPromotionCard(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await HapticService.lightImpact();
        if (context.mounted) {
          Navigator.of(context).push(
            SlideFadeRoute(page: const PremiumScreenAnimated()),
          );
        }
      },
      child: AnimatedCard(
        gradient: AppTheme.warningGradient,
        boxShadow: AppTheme.glowShadow(AppTheme.warningAmber),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Colors.white),
                      const SizedBox(width: AppTheme.spacing8),
                      Text(
                        'Upgrade to Premium',
                        style: AppTheme.headlineMedium.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacing8),
                  Text(
                    'AI coaching, unlimited logging, smart reminders & more',
                    style: AppTheme.bodyMedium.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing8),
                  Text(
                    'From £4.99/month',
                    style: AppTheme.titleMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumStatusCard() {
    return AnimatedCard(
      gradient: AppTheme.successGradient,
      boxShadow: AppTheme.glowShadow(AppTheme.secondaryGreen),
      child: Row(
        children: [
          const Icon(Icons.verified, color: Colors.white, size: 32),
          const SizedBox(width: AppTheme.spacing16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Premium Member',
                  style: AppTheme.headlineMedium.copyWith(color: Colors.white),
                ),
                const SizedBox(height: AppTheme.spacing4),
                Text(
                  'You have access to all premium features',
                  style: AppTheme.bodyMedium.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalCard(BuildContext context, user, UserProvider provider) {
    return AnimatedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Weekly Goal', style: AppTheme.headlineMedium),
              TextButton(
                onPressed: () async {
                  await HapticService.lightImpact();
                  _showGoalDialog(context, provider);
                },
                child: const Text('Edit'),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacing12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${user.weeklyGoalUnits?.toStringAsFixed(0) ?? '14'}',
                style: AppTheme.displayLarge.copyWith(
                  color: AppTheme.primaryBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: AppTheme.spacing8),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  'units per week',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacing8),
          Text(
            user.weeklyGoalUnits == 14.0
                ? 'Following UK Chief Medical Officers\' guideline'
                : 'Custom goal',
            style: AppTheme.bodySmall.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context, UserProvider provider) {
    return AnimatedCard(
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              padding: const EdgeInsets.all(AppTheme.spacing8),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: const Icon(Icons.notifications_outlined, color: AppTheme.primaryBlue),
            ),
            title: Text('Notifications', style: AppTheme.bodyMedium),
            subtitle: Text(
              'Manage reminder settings',
              style: AppTheme.bodySmall.copyWith(color: AppTheme.textSecondary),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppTheme.textTertiary),
            onTap: () async {
              await HapticService.lightImpact();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Coming soon in premium'),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                    ),
                  ),
                );
              }
            },
          ),
          const Divider(height: 1),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              padding: const EdgeInsets.all(AppTheme.spacing8),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: const Icon(Icons.privacy_tip_outlined, color: AppTheme.primaryBlue),
            ),
            title: Text('Privacy Policy', style: AppTheme.bodyMedium),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppTheme.textTertiary),
            onTap: () async {
              await HapticService.lightImpact();
              // TODO: Show privacy policy
            },
          ),
          const Divider(height: 1),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              padding: const EdgeInsets.all(AppTheme.spacing8),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: const Icon(Icons.description_outlined, color: AppTheme.primaryBlue),
            ),
            title: Text('Terms of Service', style: AppTheme.bodyMedium),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppTheme.textTertiary),
            onTap: () async {
              await HapticService.lightImpact();
              // TODO: Show terms of service
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDataManagementCard(BuildContext context) {
    return AnimatedCard(
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              padding: const EdgeInsets.all(AppTheme.spacing8),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: const Icon(Icons.download_outlined, color: AppTheme.primaryBlue),
            ),
            title: Text('Export Data', style: AppTheme.bodyMedium),
            subtitle: Text(
              'Download your data as JSON',
              style: AppTheme.bodySmall.copyWith(color: AppTheme.textSecondary),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppTheme.textTertiary),
            onTap: () async {
              await HapticService.lightImpact();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Export feature coming soon'),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                    ),
                  ),
                );
              }
            },
          ),
          const Divider(height: 1),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              padding: const EdgeInsets.all(AppTheme.spacing8),
              decoration: BoxDecoration(
                color: AppTheme.dangerRose.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: const Icon(Icons.delete_forever_outlined, color: AppTheme.dangerRose),
            ),
            title: Text(
              'Clear All Data',
              style: AppTheme.bodyMedium.copyWith(color: AppTheme.dangerRose),
            ),
            subtitle: Text(
              'Permanently delete all drinks and intentions',
              style: AppTheme.bodySmall.copyWith(color: AppTheme.textSecondary),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppTheme.textTertiary),
            onTap: () async {
              await HapticService.lightImpact();
              _showClearDataDialog(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAboutCard() {
    return AnimatedCard(
      child: Column(
        children: [
          Text('Drink Less Buddy', style: AppTheme.headlineMedium),
          const SizedBox(height: AppTheme.spacing8),
          Text(
            'Version 1.0.0',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: AppTheme.spacing16),
          Text(
            'Evidence-based tools to help you reduce alcohol consumption',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacing16),
          Text(
            '© 2025 Drink Less Buddy',
            style: AppTheme.bodySmall.copyWith(
              color: AppTheme.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  void _showGoalDialog(BuildContext context, UserProvider provider) {
    final controller = TextEditingController(
      text: (provider.user?.weeklyGoalUnits ?? 14.0).toStringAsFixed(0),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
        title: const Text('Set Weekly Goal'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              style: AppTheme.bodyMedium,
              decoration: InputDecoration(
                labelText: 'Units per week',
                labelStyle: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.textSecondary,
                ),
                hintText: '14',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacing16),
            Text(
              'UK guideline: 14 units per week',
              style: AppTheme.bodySmall.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final goal = double.tryParse(controller.text);
              if (goal != null && goal > 0) {
                await provider.updateWeeklyGoal(goal);
                await HapticService.success();
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: AppTheme.dangerRose),
            const SizedBox(width: AppTheme.spacing12),
            const Text('Clear All Data'),
          ],
        ),
        content: const Text(
          'Are you sure you want to delete all your drinks and intentions? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final drinkProvider = context.read<DrinkProvider>();
              final intentionProvider = context.read<IntentionProvider>();

              await drinkProvider.clearAllDrinks();
              await intentionProvider.clearAllIntentions();

              if (!context.mounted) return;

              await HapticService.error();
              Navigator.of(context).pop();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('All data cleared'),
                  backgroundColor: AppTheme.dangerRose,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  ),
                ),
              );
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppTheme.dangerRose),
            ),
          ),
        ],
      ),
    );
  }
}
