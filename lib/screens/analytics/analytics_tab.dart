import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/drink_provider.dart';
import '../../providers/user_provider.dart';
import '../../utils/constants.dart';

class AnalyticsTab extends StatelessWidget {
  const AnalyticsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('Your Insights'),
        backgroundColor: AppConstants.backgroundColor,
        elevation: 0,
      ),
      body: Consumer2<DrinkProvider, UserProvider>(
        builder: (context, drinkProvider, userProvider, _) {
          if (drinkProvider.drinks.isEmpty) {
            return _buildEmptyState();
          }

          final weekUnits = drinkProvider.getCurrentWeekUnits();
          final goalUnits = userProvider.user?.weeklyGoalUnits ??
              AppConstants.ukGuidelineUnitsPerWeek;
          final mostCommonMood = drinkProvider.getMostCommonMood();
          final mostCommonContext = drinkProvider.getMostCommonContext();
          final avgUnitsPerSession = drinkProvider.getAverageUnitsPerSession();
          final moodBreakdown = drinkProvider.getMoodBreakdown();
          final contextBreakdown = drinkProvider.getContextBreakdown();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Week Summary
                _buildWeekSummary(weekUnits, goalUnits),
                const SizedBox(height: 16),

                // Key Insights
                _buildKeyInsights(
                  mostCommonMood,
                  mostCommonContext,
                  avgUnitsPerSession,
                  userProvider.isPremium,
                ),
                const SizedBox(height: 16),

                // Mood Breakdown
                _buildBreakdownCard(
                  'Mood Breakdown',
                  'When do you drink?',
                  moodBreakdown,
                  Icons.mood,
                ),
                const SizedBox(height: 16),

                // Context Breakdown
                _buildBreakdownCard(
                  'Context Breakdown',
                  'Where do you drink?',
                  contextBreakdown,
                  Icons.location_on,
                ),
                const SizedBox(height: 16),

                // Personalized Feedback
                _buildPersonalizedFeedback(
                  weekUnits,
                  goalUnits,
                  mostCommonMood,
                  mostCommonContext,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bar_chart,
              size: 64,
              color: Colors.black26,
            ),
            SizedBox(height: 16),
            Text(
              'No insights yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Start logging drinks to see your patterns and insights',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black38,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekSummary(double weekUnits, double goalUnits) {
    final percentageOfGoal = (weekUnits / goalUnits * 100).clamp(0, 200);
    final isOverGoal = weekUnits > goalUnits;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isOverGoal
              ? [AppConstants.dangerColor.withOpacity(0.8), AppConstants.dangerColor]
              : [AppConstants.secondaryColor.withOpacity(0.8), AppConstants.secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (isOverGoal
                    ? AppConstants.dangerColor
                    : AppConstants.secondaryColor)
                .withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'This Week Summary',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
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
              _buildStat('% of Goal', '${percentageOfGoal.toStringAsFixed(0)}%'),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              isOverGoal
                  ? '⚠️ You\'re ${(weekUnits - goalUnits).toStringAsFixed(1)} units over your goal'
                  : '✅ You\'re ${(goalUnits - weekUnits).toStringAsFixed(1)} units under your goal',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
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
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
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
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.insights,
                color: AppConstants.primaryColor,
              ),
              SizedBox(width: 8),
              Text(
                'Key Insights',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
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
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppConstants.warningColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.lock,
                    color: AppConstants.warningColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Unlock advanced insights with Premium',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
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
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.black54),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppConstants.primaryColor,
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
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppConstants.primaryColor),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...breakdown.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entry.key,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${entry.value.toStringAsFixed(1)}%',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppConstants.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: entry.value / 100,
                      minHeight: 8,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppConstants.primaryColor,
                      ),
                    ),
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
    final ukGuideline = AppConstants.ukGuidelineUnitsPerWeek;

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
        'You\'re consuming $percentOver% more than the UK Chief Medical Officers\' guideline of $ukGuideline units per week. Regular consumption above this level increases health risks.',
      );
    } else {
      feedback.add(
        'You\'re within the UK Chief Medical Officers\' guideline of $ukGuideline units per week.',
      );
    }

    // Pattern-based feedback
    if (mostCommonMood != null && mostCommonContext != null) {
      feedback.add(
        'You tend to drink most when you\'re $mostCommonMood at $mostCommonContext. Try using context-specific tactics for these situations.',
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppConstants.primaryColor.withOpacity(0.1),
            AppConstants.primaryColor.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppConstants.primaryColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.feedback,
                color: AppConstants.primaryColor,
              ),
              SizedBox(width: 8),
              Text(
                'Personalized Feedback',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...feedback.map((text) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '• ',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        text,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppConstants.secondaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppConstants.secondaryColor,
                  size: 20,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Research shows personalized feedback reduces consumption by 31% on average',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black87,
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
