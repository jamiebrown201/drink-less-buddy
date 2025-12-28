import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/drink_provider_refactored.dart';
import '../../providers/user_provider_refactored.dart';
import '../../core/design/app_theme.dart';
import '../../core/widgets/animated_card.dart';
import '../../core/widgets/animated_progress_bar.dart';
import '../../core/widgets/stat_card.dart';
import '../../core/animations/staggered_list.dart';

class AnalyticsTabAnimated extends StatelessWidget {
  const AnalyticsTabAnimated({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundCream,
      body: SafeArea(
        child: Consumer2<DrinkProvider, UserProvider>(
          builder: (context, drinkProvider, userProvider, _) {
            if (drinkProvider.drinks.isEmpty) {
              return _buildEmptyState();
            }

            final weekUnits = drinkProvider.getCurrentWeekUnits();
            final goalUnits = userProvider.user?.weeklyGoalUnits ?? 14.0;
            final mostCommonMood = drinkProvider.getMostCommonMood();
            final mostCommonContext = drinkProvider.getMostCommonContext();
            final avgUnitsPerSession = drinkProvider.getAverageUnitsPerSession();
            final moodBreakdown = drinkProvider.getMoodBreakdown();
            final contextBreakdown = drinkProvider.getContextBreakdown();

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
                            'Your Insights',
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
                      StaggeredList(
                        children: [
                          // Week Summary
                          _buildWeekSummary(weekUnits, goalUnits),
                          const SizedBox(height: AppTheme.spacing20),

                          // Key Insights
                          _buildKeyInsights(
                            mostCommonMood,
                            mostCommonContext,
                            avgUnitsPerSession,
                            userProvider.user?.isPremium ?? false,
                          ),
                          const SizedBox(height: AppTheme.spacing20),

                          // Mood Breakdown
                          _buildBreakdownCard(
                            'Mood Breakdown',
                            'When do you drink?',
                            moodBreakdown,
                            Icons.mood,
                            AppTheme.accentPurple,
                          ),
                          const SizedBox(height: AppTheme.spacing20),

                          // Context Breakdown
                          _buildBreakdownCard(
                            'Context Breakdown',
                            'Where do you drink?',
                            contextBreakdown,
                            Icons.location_on,
                            AppTheme.primaryBlue,
                          ),
                          const SizedBox(height: AppTheme.spacing20),

                          // Personalized Feedback
                          _buildPersonalizedFeedback(
                            weekUnits,
                            goalUnits,
                            mostCommonMood,
                            mostCommonContext,
                          ),
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

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppTheme.spacing24),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.bar_chart_rounded,
                size: 64,
                color: AppTheme.primaryBlue,
              ),
            ),
            const SizedBox(height: AppTheme.spacing20),
            Text(
              'No insights yet',
              style: AppTheme.headlineLarge,
            ),
            const SizedBox(height: AppTheme.spacing8),
            Text(
              'Start logging drinks to see your patterns and insights',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekSummary(double weekUnits, double goalUnits) {
    final percentageOfGoal = (weekUnits / goalUnits).clamp(0.0, 2.0);
    final isOverGoal = weekUnits > goalUnits;
    final gradient = isOverGoal ? AppTheme.warningGradient : AppTheme.successGradient;

    return AnimatedCard(
      gradient: gradient,
      boxShadow: AppTheme.glowShadow(
        isOverGoal ? AppTheme.warningAmber : AppTheme.secondaryGreen,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'This Week Summary',
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
                  '${(percentageOfGoal * 100).toStringAsFixed(0)}%',
                  style: AppTheme.labelLarge.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacing20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStat('Total Units', weekUnits.toStringAsFixed(1)),
              Container(
                width: 2,
                height: 40,
                color: Colors.white30,
              ),
              _buildStat('Goal', goalUnits.toStringAsFixed(0)),
              Container(
                width: 2,
                height: 40,
                color: Colors.white30,
              ),
              _buildStat('% of Goal', '${(percentageOfGoal * 100).toStringAsFixed(0)}%'),
            ],
          ),
          const SizedBox(height: AppTheme.spacing20),
          AnimatedProgressBar(
            progress: percentageOfGoal.clamp(0.0, 1.0),
            height: 10,
            gradient: const LinearGradient(
              colors: [Colors.white, Colors.white70],
            ),
            backgroundColor: Colors.white.withOpacity(0.2),
          ),
          const SizedBox(height: AppTheme.spacing16),
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isOverGoal ? Icons.trending_up : Icons.trending_down,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: AppTheme.spacing8),
                Flexible(
                  child: Text(
                    isOverGoal
                        ? 'You\'re ${(weekUnits - goalUnits).toStringAsFixed(1)} units over your goal'
                        : 'You\'re ${(goalUnits - weekUnits).toStringAsFixed(1)} units under your goal',
                    style: AppTheme.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTheme.titleLarge.copyWith(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppTheme.spacing4),
        Text(
          label,
          style: AppTheme.bodySmall.copyWith(
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildKeyInsights(
    String? mostCommonMood,
    String? mostCommonContext,
    double avgUnits,
    bool isPremium,
  ) {
    return AnimatedCard(
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
                child: const Icon(
                  Icons.insights,
                  color: AppTheme.primaryBlue,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppTheme.spacing12),
              Text('Key Insights', style: AppTheme.headlineMedium),
            ],
          ),
          const SizedBox(height: AppTheme.spacing16),
          _buildInsightRow(
            Icons.mood,
            'Most Common Mood',
            mostCommonMood ?? 'N/A',
          ),
          const Divider(),
          _buildInsightRow(
            Icons.location_on,
            'Most Common Location',
            mostCommonContext ?? 'N/A',
          ),
          const Divider(),
          _buildInsightRow(
            Icons.local_drink,
            'Avg Units per Session',
            avgUnits.toStringAsFixed(1),
          ),
          if (!isPremium) ...[
            const Divider(),
            Container(
              padding: const EdgeInsets.all(AppTheme.spacing12),
              decoration: BoxDecoration(
                color: AppTheme.warningAmber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.lock,
                    color: AppTheme.warningAmber,
                    size: 20,
                  ),
                  const SizedBox(width: AppTheme.spacing8),
                  Expanded(
                    child: Text(
                      'Unlock advanced insights with Premium',
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInsightRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.textSecondary),
          const SizedBox(width: AppTheme.spacing12),
          Expanded(
            child: Text(
              label,
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          Text(
            value,
            style: AppTheme.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownCard(
    String title,
    String subtitle,
    Map<String, double> breakdown,
    IconData icon,
    Color color,
  ) {
    return AnimatedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppTheme.spacing8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: AppTheme.spacing12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTheme.titleMedium),
                  Text(
                    subtitle,
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacing16),
          ...breakdown.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entry.key,
                        style: AppTheme.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${entry.value.toStringAsFixed(1)}%',
                        style: AppTheme.bodyMedium.copyWith(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacing4),
                  AnimatedProgressBar(
                    progress: entry.value / 100,
                    height: 8,
                    gradient: LinearGradient(
                      colors: [color, color.withOpacity(0.6)],
                    ),
                    backgroundColor: AppTheme.textTertiary.withOpacity(0.1),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPersonalizedFeedback(
    double weekUnits,
    double goalUnits,
    String? mostCommonMood,
    String? mostCommonContext,
  ) {
    final isOverGoal = weekUnits > goalUnits;
    const ukGuideline = 14.0;

    List<String> feedback = [];

    // Goal-based feedback
    if (isOverGoal) {
      feedback.add(
        'You\'re currently ${((weekUnits / goalUnits - 1) * 100).toStringAsFixed(0)}% over your weekly goal. Consider using the tactics in the Tactics tab to help reduce consumption.',
      );
    } else {
      feedback.add(
        'Great job! You\'re staying within your goal. Keep up the good work!',
      );
    }

    // UK guideline comparison
    if (weekUnits > ukGuideline) {
      final percentOver = ((weekUnits / ukGuideline - 1) * 100).toStringAsFixed(0);
      feedback.add(
        'You\'re consuming $percentOver% more than the UK Chief Medical Officers\' guideline of ${ukGuideline.toStringAsFixed(0)} units per week. Regular consumption above this level increases health risks.',
      );
    } else {
      feedback.add(
        'You\'re within the UK Chief Medical Officers\' guideline of ${ukGuideline.toStringAsFixed(0)} units per week.',
      );
    }

    // Pattern-based feedback
    if (mostCommonMood != null && mostCommonContext != null) {
      feedback.add(
        'You tend to drink most when you\'re $mostCommonMood at $mostCommonContext. Try using context-specific tactics for these situations.',
      );
    }

    return AnimatedCard(
      color: AppTheme.primaryBlue.withOpacity(0.05),
      border: Border.all(
        color: AppTheme.primaryBlue.withOpacity(0.3),
        width: 2,
      ),
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
                child: const Icon(
                  Icons.feedback,
                  color: AppTheme.primaryBlue,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppTheme.spacing12),
              Text('Personalized Feedback', style: AppTheme.headlineMedium),
            ],
          ),
          const SizedBox(height: AppTheme.spacing16),
          ...feedback.map((text) => Padding(
                padding: const EdgeInsets.only(bottom: AppTheme.spacing12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Icon(
                        Icons.circle,
                        size: 6,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacing12),
                    Expanded(
                      child: Text(
                        text,
                        style: AppTheme.bodyMedium.copyWith(
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: AppTheme.spacing8),
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing12),
            decoration: BoxDecoration(
              color: AppTheme.secondaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: AppTheme.secondaryGreen,
                  size: 20,
                ),
                const SizedBox(width: AppTheme.spacing8),
                Expanded(
                  child: Text(
                    'Research shows personalized feedback reduces consumption by 31% on average',
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
