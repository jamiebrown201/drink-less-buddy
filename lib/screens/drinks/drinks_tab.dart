import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/drink_provider.dart';
import '../../providers/intention_provider.dart';
import '../../providers/user_provider.dart';
import '../../models/drink.dart';
import '../../utils/constants.dart';
import 'log_drink_screen.dart';
import '../intentions/set_intention_screen.dart';

class DrinksTab extends StatelessWidget {
  const DrinksTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('Track Your Drinks'),
        backgroundColor: AppConstants.backgroundColor,
        elevation: 0,
      ),
      body: Consumer3<DrinkProvider, IntentionProvider, UserProvider>(
        builder: (context, drinkProvider, intentionProvider, userProvider, _) {
          final weekUnits = drinkProvider.getCurrentWeekUnits();
          final goalUnits = userProvider.user?.weeklyGoalUnits ??
              AppConstants.ukGuidelineUnitsPerWeek;
          final progressPercentage = (weekUnits / goalUnits).clamp(0.0, 1.0);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Week Progress Card
                _buildWeekProgressCard(
                  context,
                  weekUnits,
                  goalUnits,
                  progressPercentage,
                ),
                const SizedBox(height: 16),

                // Tomorrow's Intentions Card
                _buildIntentionsCard(context, intentionProvider),
                const SizedBox(height: 16),

                // Quick Log Button
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const LogDrinkScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add_circle),
                  label: const Text('Log a Drink'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Recent Drinks
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recent Drinks',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'This Week: ${drinkProvider.getCurrentWeekDrinks().length} drinks',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                if (drinkProvider.drinks.isEmpty)
                  _buildEmptyState()
                else
                  ...drinkProvider.drinks
                      .take(10)
                      .map((drink) => _buildDrinkCard(context, drink, drinkProvider))
                      .toList(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWeekProgressCard(
    BuildContext context,
    double weekUnits,
    double goalUnits,
    double progressPercentage,
  ) {
    final isOverGoal = weekUnits > goalUnits;
    final color = isOverGoal ? AppConstants.dangerColor : AppConstants.secondaryColor;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.8), color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'This Week',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${(progressPercentage * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                weekUnits.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1,
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  '/ ${goalUnits.toStringAsFixed(0)} units',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progressPercentage,
              minHeight: 8,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            isOverGoal
                ? 'You\'re ${(weekUnits - goalUnits).toStringAsFixed(1)} units over your goal'
                : 'You\'re ${(goalUnits - weekUnits).toStringAsFixed(1)} units under your goal',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntentionsCard(BuildContext context, IntentionProvider provider) {
    final tomorrowIntentions = provider.getTomorrowIntentions();
    final todayIntentions = provider.getTodayIncompleteIntentions();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.warningColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppConstants.warningColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.wb_sunny,
                    color: AppConstants.warningColor,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Tomorrow\'s Intentions',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const SetIntentionScreen(),
                    ),
                  );
                },
                child: const Text('Set'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (tomorrowIntentions.isEmpty)
            const Text(
              'What do you want to do tomorrow hangover-free?\nSetting intentions reduces consumption by 31%.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.black54,
              ),
            )
          else
            ...tomorrowIntentions.map((intention) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        color: AppConstants.secondaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          intention.activity,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                )),
          if (todayIntentions.isNotEmpty) ...[
            const Divider(),
            const Text(
              'Today\'s Intentions',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            ...todayIntentions.map((intention) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Checkbox(
                        value: intention.isCompleted,
                        onChanged: (_) {
                          provider.completeIntention(intention.id);
                        },
                      ),
                      Expanded(
                        child: Text(
                          intention.activity,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: const Column(
        children: [
          Icon(
            Icons.local_drink_outlined,
            size: 64,
            color: Colors.black26,
          ),
          SizedBox(height: 16),
          Text(
            'No drinks logged yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Start tracking to see insights and patterns',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black38,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDrinkCard(BuildContext context, Drink drink, DrinkProvider provider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppConstants.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Icon(
                Icons.local_drink,
                color: AppConstants.primaryColor,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  drink.drinkType,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${drink.units} units • ${drink.mood} • ${drink.context}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  DateFormat('MMM d, yyyy • h:mm a').format(drink.timestamp),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black38,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppConstants.dangerColor),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Drink'),
                  content: const Text('Are you sure you want to delete this entry?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        provider.deleteDrink(drink.id);
                        Navigator.of(context).pop();
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
