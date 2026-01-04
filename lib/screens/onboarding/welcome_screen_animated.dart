import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider_refactored.dart';
import '../../core/design/app_theme.dart';
import '../../core/widgets/glass_button.dart';
import '../../core/widgets/animated_card.dart';
import '../../core/animations/staggered_list.dart';
import '../../core/animations/slide_fade_transition.dart';
import '../../core/services/haptic_service.dart';
import '../home/home_screen_animated.dart';

class WelcomeScreenAnimated extends StatefulWidget {
  const WelcomeScreenAnimated({super.key});

  @override
  State<WelcomeScreenAnimated> createState() => _WelcomeScreenAnimatedState();
}

class _WelcomeScreenAnimatedState extends State<WelcomeScreenAnimated> {
  bool _useRecommendedLimit = true;
  double _customGoal = 14.0;

  // Preset goal options for easy selection
  final List<Map<String, dynamic>> _goalPresets = [
    {'units': 7.0, 'label': '7 units', 'desc': 'Very low risk'},
    {'units': 10.0, 'label': '10 units', 'desc': 'Low risk'},
    {'units': 14.0, 'label': '14 units', 'desc': 'Moderate'},
    {'units': 21.0, 'label': '21 units', 'desc': 'Higher risk'},
  ];

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
                'See patterns in your drinking and compare to recommended limits. 31% average reduction.',
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
                      value: _useRecommendedLimit,
                      onChanged: (value) async {
                        await HapticService.selectionClick();
                        setState(() {
                          _useRecommendedLimit = value ?? false;
                          if (_useRecommendedLimit) {
                            _customGoal = 14.0;
                          }
                        });
                      },
                      title: Text(
                        'Use recommended low-risk limit',
                        style: AppTheme.bodyMedium,
                      ),
                      subtitle: Text(
                        '14 units per week (UK CMO guideline)',
                        style: AppTheme.bodySmall,
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: AppTheme.secondaryGreen,
                      contentPadding: EdgeInsets.zero,
                    ),
                    const SizedBox(height: AppTheme.spacing16),
                    _buildDrinkEquivalents(),
                    if (!_useRecommendedLimit) ...[
                      const SizedBox(height: AppTheme.spacing20),
                      Text(
                        'Or choose a different goal:',
                        style: AppTheme.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacing12),
                      _buildGoalSelector(),
                      const SizedBox(height: AppTheme.spacing16),
                      _buildGoalSlider(),
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

  Widget _buildGoalSelector() {
    return Wrap(
      spacing: AppTheme.spacing8,
      runSpacing: AppTheme.spacing8,
      children: _goalPresets.map((preset) {
        final isSelected = _customGoal == preset['units'];
        return GestureDetector(
          onTap: () async {
            await HapticService.selectionClick();
            setState(() {
              _customGoal = preset['units'] as double;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacing16,
              vertical: AppTheme.spacing12,
            ),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.primaryBlue : AppTheme.cardBackground,
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              border: Border.all(
                color: isSelected ? AppTheme.primaryBlue : AppTheme.textTertiary.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Column(
              children: [
                Text(
                  preset['label'] as String,
                  style: AppTheme.titleMedium.copyWith(
                    color: isSelected ? Colors.white : AppTheme.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  preset['desc'] as String,
                  style: AppTheme.bodySmall.copyWith(
                    color: isSelected ? Colors.white70 : AppTheme.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGoalSlider() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Fine-tune:',
              style: AppTheme.bodySmall.copyWith(color: AppTheme.textSecondary),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacing12,
                vertical: AppTheme.spacing4,
              ),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue,
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: Text(
                '${_customGoal.toStringAsFixed(0)} units/week',
                style: AppTheme.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppTheme.primaryBlue,
            inactiveTrackColor: AppTheme.primaryBlue.withOpacity(0.2),
            thumbColor: AppTheme.primaryBlue,
            overlayColor: AppTheme.primaryBlue.withOpacity(0.2),
            trackHeight: 6,
          ),
          child: Slider(
            value: _customGoal,
            min: 1,
            max: 30,
            divisions: 29,
            onChanged: (value) async {
              await HapticService.selectionClick();
              setState(() {
                _customGoal = value;
              });
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('1', style: AppTheme.bodySmall.copyWith(color: AppTheme.textTertiary)),
            Text('30', style: AppTheme.bodySmall.copyWith(color: AppTheme.textTertiary)),
          ],
        ),
      ],
    );
  }

  Widget _buildDrinkEquivalents() {
    // Calculate equivalents based on standard UK units
    final pints = (_customGoal / 2.3).floor(); // Pint of beer = 2.3 units
    final largeWines = (_customGoal / 3.0).floor(); // Large wine = 3 units
    final shots = _customGoal.floor(); // Single spirit = 1 unit

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue.withOpacity(0.08),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
          color: AppTheme.primaryBlue.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'That\'s equivalent to:',
            style: AppTheme.bodySmall.copyWith(
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppTheme.spacing12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildEquivalentItem(Icons.sports_bar, '$pints', 'pints'),
              Text(
                'or',
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.textTertiary,
                  fontStyle: FontStyle.italic,
                ),
              ),
              _buildEquivalentItem(Icons.wine_bar, '$largeWines', 'large wines'),
              Text(
                'or',
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.textTertiary,
                  fontStyle: FontStyle.italic,
                ),
              ),
              _buildEquivalentItem(Icons.local_bar, '$shots', 'shots'),
            ],
          ),
          const SizedBox(height: AppTheme.spacing8),
          Center(
            child: Text(
              'per week',
              style: AppTheme.bodySmall.copyWith(
                color: AppTheme.textTertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEquivalentItem(IconData icon, String count, String label) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.primaryBlue, size: 28),
        const SizedBox(height: AppTheme.spacing4),
        Text(
          count,
          style: AppTheme.titleLarge.copyWith(
            color: AppTheme.primaryBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTheme.bodySmall.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
      ],
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

    final userProvider = context.read<UserProvider>();
    final success = await userProvider.completeOnboarding(weeklyGoal: _customGoal);

    if (!mounted) return;

    if (success) {
      await HapticService.success();
      Navigator.of(context).pushReplacement(
        SlideFadeRoute(page: const HomeScreenAnimated()),
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
