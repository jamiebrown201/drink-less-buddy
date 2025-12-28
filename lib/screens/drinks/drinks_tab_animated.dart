import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/drink_provider_refactored.dart';
import '../../providers/intention_provider_refactored.dart';
import '../../providers/user_provider_refactored.dart';
import '../../core/design/app_theme.dart';
import '../../core/widgets/animated_card.dart';
import '../../core/widgets/animated_progress_bar.dart';
import '../../core/widgets/stat_card.dart';
import '../../core/widgets/glass_button.dart';
import '../../core/animations/staggered_list.dart';
import '../../core/animations/slide_fade_transition.dart';
import '../../core/services/haptic_service.dart';
import '../intentions/set_intention_screen.dart';
import 'log_drink_screen.dart';

class DrinksTabAnimated extends StatelessWidget {
  const DrinksTabAnimated({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundCream,
      body: SafeArea(
        child: Consumer3<DrinkProvider, IntentionProvider, UserProvider>(
          builder: (context, drinkProvider, intentionProvider, userProvider, _) {
            final weekUnits = drinkProvider.getCurrentWeekUnits();
            final goalUnits = userProvider.user?.weeklyGoalUnits ?? 14.0;
            final progressPercentage = (weekUnits / goalUnits).clamp(0.0, 1.0);
            final isOverGoal = weekUnits > goalUnits;

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
                            'Track Your Drinks',
                            style: AppTheme.displayMedium,
                          ),
                          const SizedBox(height: AppTheme.spacing4),
                          Text(
                            'Week of ${DateFormat('MMM d').format(DateTime.now())}',
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
                      // Week Progress Card
                      _buildWeekProgressCard(
                        weekUnits,
                        goalUnits,
                        progressPercentage,
                        isOverGoal,
                      ),
                      const SizedBox(height: AppTheme.spacing20),

                      // Stats Row
                      _buildStatsRow(context, drinkProvider),
                      const SizedBox(height: AppTheme.spacing20),

                      // Tomorrow's Intentions
                      _buildIntentionsCard(context, intentionProvider),
                      const SizedBox(height: AppTheme.spacing20),

                      // Log Button
                      GlassButton(
                        text: 'Log a Drink',
                        icon: Icons.add_circle_outline,
                        onPressed: () async {
                          await HapticService.mediumImpact();
                          if (context.mounted) {
                            context.pushWithSlide(const LogDrinkScreen());
                          }
                        },
                      ),
                      const SizedBox(height: AppTheme.spacing32),

                      // Recent Drinks Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Recent Drinks', style: AppTheme.headlineMedium),
                          Text(
                            '${drinkProvider.getCurrentWeekDrinks().length} this week',
                            style: AppTheme.bodySmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.spacing16),

                      // Drinks List
                      if (drinkProvider.drinks.isEmpty)
                        _buildEmptyState()
                      else
                        StaggeredList(
                          children: drinkProvider.drinks
                              .take(10)
                              .map((drink) => Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: AppTheme.spacing12,
                                    ),
                                    child: _buildDrinkCard(
                                      context,
                                      drink,
                                      drinkProvider,
                                    ),
                                  ))
                              .toList(),
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

  Widget _buildWeekProgressCard(
    double weekUnits,
    double goalUnits,
    double progressPercentage,
    bool isOverGoal,
  ) {
    final gradient = isOverGoal ? AppTheme.warningGradient : AppTheme.successGradient;

    return AnimatedCard(
      gradient: gradient,
      boxShadow: AppTheme.glowShadow(
        isOverGoal ? AppTheme.warningAmber : AppTheme.secondaryGreen,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'This Week',
                style: AppTheme.headlineMedium.copyWith(color: Colors.white),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacing12,
                  vertical: AppTheme.spacing4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                ),
                child: Text(
                  '${(progressPercentage * 100).toStringAsFixed(0)}%',
                  style: AppTheme.labelLarge.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacing20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                weekUnits.toStringAsFixed(1),
                style: AppTheme.displayLarge.copyWith(
                  fontSize: 48,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: AppTheme.spacing8),
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  '/ ${goalUnits.toStringAsFixed(0)} units',
                  style: AppTheme.titleLarge.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacing16),
          AnimatedProgressBar(
            progress: progressPercentage,
            height: 10,
            gradient: const LinearGradient(
              colors: [Colors.white, Colors.white70],
            ),
            backgroundColor: Colors.white.withOpacity(0.2),
          ),
          const SizedBox(height: AppTheme.spacing12),
          Text(
            isOverGoal
                ? '${(weekUnits - goalUnits).toStringAsFixed(1)} units over your goal'
                : '${(goalUnits - weekUnits).toStringAsFixed(1)} units under your goal',
            style: AppTheme.bodyMedium.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, DrinkProvider provider) {
    final mostCommonContext = provider.getMostCommonContext() ?? 'N/A';
    final avgUnits = provider.getAverageUnitsPerSession();

    return Row(
      children: [
        Expanded(
          child: StatCard(
            label: 'Avg per Session',
            value: avgUnits.toStringAsFixed(1),
            icon: Icons.analytics_outlined,
          ),
        ),
        const SizedBox(width: AppTheme.spacing12),
        Expanded(
          child: StatCard(
            label: 'Top Location',
            value: mostCommonContext,
            icon: Icons.location_on_outlined,
          ),
        ),
      ],
    );
  }

  Widget _buildIntentionsCard(
    BuildContext context,
    IntentionProvider provider,
  ) {
    final tomorrowIntentions = provider.getTomorrowIntentions();
    final todayIntentions = provider.getTodayIncompleteIntentions();

    return AnimatedCard(
      color: AppTheme.accentPurple.withOpacity(0.1),
      border: Border.all(
        color: AppTheme.accentPurple.withOpacity(0.3),
        width: 2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppTheme.spacing8),
                    decoration: BoxDecoration(
                      color: AppTheme.accentPurple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                    ),
                    child: const Icon(
                      Icons.wb_sunny_outlined,
                      color: AppTheme.accentPurple,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacing12),
                  Text(
                    'Tomorrow\'s Intentions',
                    style: AppTheme.titleMedium.copyWith(
                      color: AppTheme.accentPurple,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () async {
                  await HapticService.lightImpact();
                  if (context.mounted) {
                    context.pushWithSlide(const SetIntentionScreen());
                  }
                },
                child: const Text('Set'),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacing12),
          if (tomorrowIntentions.isEmpty)
            Text(
              'What do you want to do tomorrow hangover-free?',
              style: AppTheme.bodySmall.copyWith(
                fontStyle: FontStyle.italic,
              ),
            )
          else
            ...tomorrowIntentions.map((intention) => Padding(
                  padding: const EdgeInsets.only(bottom: AppTheme.spacing8),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: AppTheme.accentPurple,
                        size: 20,
                      ),
                      const SizedBox(width: AppTheme.spacing8),
                      Expanded(
                        child: Text(
                          intention.activity,
                          style: AppTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                )),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing40),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(AppTheme.spacing24),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.local_drink_outlined,
                size: 48,
                color: AppTheme.primaryBlue,
              ),
            ),
            const SizedBox(height: AppTheme.spacing20),
            Text(
              'No drinks logged yet',
              style: AppTheme.headlineMedium,
            ),
            const SizedBox(height: AppTheme.spacing8),
            Text(
              'Start tracking to see insights',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrinkCard(
    BuildContext context,
    drink,
    DrinkProvider provider,
  ) {
    return AnimatedCard(
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
            child: const Center(
              child: Icon(
                Icons.local_drink,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spacing16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  drink.drinkType,
                  style: AppTheme.titleMedium,
                ),
                const SizedBox(height: AppTheme.spacing4),
                Text(
                  '${drink.units} units • ${drink.mood} • ${drink.context}',
                  style: AppTheme.bodySmall,
                ),
                Text(
                  DateFormat('MMM d, h:mm a').format(drink.timestamp),
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.delete_outline,
              color: AppTheme.dangerRose,
            ),
            onPressed: () async {
              await HapticService.lightImpact();
              // Show delete confirmation
            },
          ),
        ],
      ),
    );
  }
}
