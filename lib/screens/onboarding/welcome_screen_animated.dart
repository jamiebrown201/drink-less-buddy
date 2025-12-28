import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider_refactored.dart';
import '../../core/design/app_theme.dart';
import '../../core/widgets/glass_button.dart';
import '../../core/widgets/animated_card.dart';
import '../../core/animations/staggered_list.dart';
import '../../core/animations/slide_fade_transition.dart';
import '../../core/services/haptic_service.dart';
import '../home/home_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final TextEditingController _goalController = TextEditingController();
  bool _useUKGuideline = true;

  @override
  void initState() {
    super.initState();
    _goalController.text = '14.0';
  }

  @override
  void dispose() {
    _goalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundCream,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(AppTheme.spacing24),
          child: StaggeredList(
            children: [
              const SizedBox(height: AppTheme.spacing32),

              // Header with icon
              Container(
                padding: const EdgeInsets.all(AppTheme.spacing20),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.favorite_border,
                  size: 48,
                  color: AppTheme.primaryBlue,
                ),
              ),
              const SizedBox(height: AppTheme.spacing24),

              Text(
                'Welcome to\nDrink Less Buddy',
                style: AppTheme.displayLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.spacing16),

              Text(
                'Evidence-based tools to help you reduce drinking, not eliminate it entirely.',
                style: AppTheme.bodyLarge.copyWith(
                  color: AppTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.spacing48),

              // Feature cards
              _buildFeatureCard(
                Icons.track_changes,
                'Self-Monitoring',
                'Track every drink with mood and context. Self-monitoring alone reduces consumption by 25%.',
                AppTheme.primaryBlue,
              ),
              const SizedBox(height: AppTheme.spacing16),

              _buildFeatureCard(
                Icons.insights,
                'Personalized Feedback',
                'See patterns in your drinking and compare to UK guidelines. 31% average reduction.',
                AppTheme.secondaryGreen,
              ),
              const SizedBox(height: AppTheme.spacing16),

              _buildFeatureCard(
                Icons.lightbulb_outline,
                'Evidence-Based Tactics',
                'Learn proven strategies for reducing consumption in different contexts.',
                AppTheme.accentPurple,
              ),
              const SizedBox(height: AppTheme.spacing16),

              _buildFeatureCard(
                Icons.event_note,
                'Daily Intentions',
                'Set goals for tomorrow\'s activities you want to do hangover-free.',
                AppTheme.warningAmber,
              ),
              const SizedBox(height: AppTheme.spacing48),

              Text(
                'Set Your Weekly Goal',
                style: AppTheme.headlineMedium,
              ),
              const SizedBox(height: AppTheme.spacing16),

              AnimatedCard(
                color: AppTheme.secondaryGreen.withOpacity(0.1),
                border: Border.all(
                  color: AppTheme.secondaryGreen.withOpacity(0.3),
                  width: 2,
                ),
                child: Column(
                  children: [
                    CheckboxListTile(
                      value: _useUKGuideline,
                      onChanged: (value) async {
                        await HapticService.selectionClick();
                        setState(() {
                          _useUKGuideline = value ?? false;
                          if (_useUKGuideline) {
                            _goalController.text = '14.0';
                          }
                        });
                      },
                      title: Text(
                        'Use UK Chief Medical Officers\' guideline',
                        style: AppTheme.bodyMedium,
                      ),
                      subtitle: Text(
                        '14 units per week',
                        style: AppTheme.bodySmall,
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: AppTheme.secondaryGreen,
                      contentPadding: EdgeInsets.zero,
                    ),
                    if (!_useUKGuideline) ...[
                      const SizedBox(height: AppTheme.spacing16),
                      TextField(
                        controller: _goalController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        style: AppTheme.bodyMedium,
                        decoration: InputDecoration(
                          labelText: 'Weekly Goal (units)',
                          labelStyle: AppTheme.bodyMedium.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                          ),
                          suffixText: 'units/week',
                          suffixStyle: AppTheme.bodySmall,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacing32),

              GlassButton(
                text: 'Get Started',
                icon: Icons.arrow_forward,
                onPressed: _completeOnboarding,
              ),
              const SizedBox(height: AppTheme.spacing24),
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
                Text(
                  title,
                  style: AppTheme.titleMedium,
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

  void _completeOnboarding() async {
    await HapticService.mediumImpact();

    final goal = double.tryParse(_goalController.text);
    if (goal == null || goal <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a valid weekly goal'),
          backgroundColor: AppTheme.dangerRose,
        ),
      );
      await HapticService.error();
      return;
    }

    final userProvider = context.read<UserProvider>();
    final success = await userProvider.completeOnboarding(weeklyGoal: goal);

    if (!mounted) return;

    if (success) {
      await HapticService.success();
      Navigator.of(context).pushReplacement(
        SlideFadeRoute(page: const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(userProvider.error?.message ?? 'Failed to complete onboarding'),
          backgroundColor: AppTheme.dangerRose,
        ),
      );
      await HapticService.error();
    }
  }
}
