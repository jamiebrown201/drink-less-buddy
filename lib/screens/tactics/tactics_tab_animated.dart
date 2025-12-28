import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/drink_provider_refactored.dart';
import '../../core/design/app_theme.dart';
import '../../core/widgets/animated_card.dart';
import '../../core/animations/staggered_list.dart';
import '../../core/services/haptic_service.dart';

class TacticsTabAnimated extends StatefulWidget {
  const TacticsTabAnimated({super.key});

  @override
  State<TacticsTabAnimated> createState() => _TacticsTabAnimatedState();
}

class _TacticsTabAnimatedState extends State<TacticsTabAnimated> {
  String? _selectedContext;

  // Contexts for filtering
  final List<String> _contexts = ['Home', 'Bar/Pub', 'Restaurant', 'Party', 'Friend\'s House', 'All'];

  // Evidence-based tactics
  final List<Map<String, dynamic>> _tactics = [
    {
      'name': 'Pre-Commitment Strategy',
      'effectiveness': 'High',
      'description':
          'Before you go out or start drinking, set a specific limit and tell someone about it. Public commitment increases accountability.',
      'evidence':
          'Studies show pre-commitment reduces consumption by 28-35%. Social accountability amplifies effectiveness.',
      'contexts': ['All'],
    },
    {
      'name': 'Drink Spacing with Water',
      'effectiveness': 'High',
      'description':
          'Alternate each alcoholic drink with a full glass of water. This slows consumption and maintains hydration.',
      'evidence':
          'Reduces overall alcohol consumption by 25-30% and significantly decreases hangover severity.',
      'contexts': ['All'],
    },
    {
      'name': 'Smaller Glass Strategy',
      'effectiveness': 'Medium',
      'description':
          'Use smaller glasses or order smaller servings. People pour less and consume less when using smaller containers.',
      'evidence':
          'Environmental cues research shows 20-25% reduction in consumption with smaller serving sizes.',
      'contexts': ['Home', 'Friend\'s House'],
    },
    {
      'name': 'Activity-Based Drinking',
      'effectiveness': 'High',
      'description':
          'Only drink while actively socializing. Put your drink down during conversations and activities.',
      'evidence':
          'Behavioral research shows mindful drinking reduces consumption by 30-40%.',
      'contexts': ['Bar/Pub', 'Party', 'Restaurant'],
    },
    {
      'name': 'Late Arrival Strategy',
      'effectiveness': 'Medium',
      'description':
          'Arrive later to social events. The first hour often involves the most rapid drinking.',
      'evidence':
          'Timing research shows 20-25% reduction when avoiding early-event drinking culture.',
      'contexts': ['Party', 'Bar/Pub'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundCream,
      body: SafeArea(
        child: Consumer<DrinkProvider>(
          builder: (context, drinkProvider, _) {
            final mostCommonContext = drinkProvider.getMostCommonContext();

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
                            'Evidence-Based Tactics',
                            style: AppTheme.displayMedium,
                          ),
                          const SizedBox(height: AppTheme.spacing4),
                          Text(
                            'Proven strategies to reduce drinking',
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
                          // About Card
                          AnimatedCard(
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
                                        Icons.lightbulb_outline,
                                        color: AppTheme.primaryBlue,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: AppTheme.spacing12),
                                    Text('About These Tactics', style: AppTheme.titleMedium),
                                  ],
                                ),
                                const SizedBox(height: AppTheme.spacing12),
                                Text(
                                  'These strategies are ranked by effectiveness from peer-reviewed research. Different tactics work better in different contexts.',
                                  style: AppTheme.bodyMedium.copyWith(
                                    height: 1.5,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                                if (mostCommonContext != null) ...[
                                  const SizedBox(height: AppTheme.spacing12),
                                  Container(
                                    padding: const EdgeInsets.all(AppTheme.spacing12),
                                    decoration: BoxDecoration(
                                      color: AppTheme.secondaryGreen.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.auto_awesome,
                                          color: AppTheme.secondaryGreen,
                                          size: 20,
                                        ),
                                        const SizedBox(width: AppTheme.spacing8),
                                        Expanded(
                                          child: Text(
                                            'You drink most at $mostCommonContext. Focus on tactics for this context.',
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
                          ),
                          const SizedBox(height: AppTheme.spacing24),

                          // Filter by Context
                          Text('Filter by Context', style: AppTheme.headlineMedium),
                          const SizedBox(height: AppTheme.spacing12),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildContextChip('All', null),
                                const SizedBox(width: AppTheme.spacing8),
                                ..._contexts.where((c) => c != 'All').map((context) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: AppTheme.spacing8),
                                    child: _buildContextChip(context, context),
                                  );
                                }),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppTheme.spacing24),

                          // Tactics List
                          Text('Tactics', style: AppTheme.headlineMedium),
                          const SizedBox(height: AppTheme.spacing12),
                          ..._getFilteredTactics().map((tactic) => _buildTacticCard(tactic)),
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

  Widget _buildContextChip(String label, String? context) {
    final isSelected = _selectedContext == context;
    return GestureDetector(
      onTap: () async {
        await HapticService.selectionClick();
        setState(() {
          _selectedContext = context;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacing16,
          vertical: AppTheme.spacing10,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryBlue : Colors.white,
          borderRadius: BorderRadius.circular(AppTheme.radiusFull),
          border: Border.all(
            color: isSelected ? AppTheme.primaryBlue : AppTheme.textTertiary.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: AppTheme.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppTheme.textPrimary,
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredTactics() {
    if (_selectedContext == null) {
      return _tactics;
    }

    return _tactics.where((tactic) {
      final contexts = tactic['contexts'] as List<String>;
      return contexts.contains('All') || contexts.contains(_selectedContext);
    }).toList();
  }

  Widget _buildTacticCard(Map<String, dynamic> tactic) {
    final effectiveness = tactic['effectiveness'] as String;
    Color effectivenessColor;

    switch (effectiveness) {
      case 'High':
        effectivenessColor = AppTheme.secondaryGreen;
        break;
      case 'Medium':
        effectivenessColor = AppTheme.warningAmber;
        break;
      default:
        effectivenessColor = AppTheme.textTertiary;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacing12),
      child: AnimatedCard(
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: EdgeInsets.zero,
            childrenPadding: const EdgeInsets.only(top: AppTheme.spacing12),
            leading: Container(
              padding: const EdgeInsets.all(AppTheme.spacing8),
              decoration: BoxDecoration(
                color: effectivenessColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: Icon(
                Icons.check_circle,
                color: effectivenessColor,
              ),
            ),
            title: Text(tactic['name'], style: AppTheme.titleMedium),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: AppTheme.spacing4),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacing8,
                  vertical: AppTheme.spacing4,
                ),
                decoration: BoxDecoration(
                  color: effectivenessColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                ),
                child: Text(
                  '$effectiveness Effectiveness',
                  style: AppTheme.labelSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: effectivenessColor,
                  ),
                ),
              ),
            ),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'How it works:',
                    style: AppTheme.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing8),
                  Text(
                    tactic['description'],
                    style: AppTheme.bodyMedium.copyWith(
                      height: 1.5,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing16),
                  Container(
                    padding: const EdgeInsets.all(AppTheme.spacing12),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.science_outlined,
                              size: 16,
                              color: AppTheme.primaryBlue,
                            ),
                            const SizedBox(width: AppTheme.spacing8),
                            Text(
                              'Research Evidence:',
                              style: AppTheme.bodySmall.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryBlue,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppTheme.spacing8),
                        Text(
                          tactic['evidence'],
                          style: AppTheme.bodySmall.copyWith(
                            height: 1.4,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing12),
                  Text(
                    'Best for:',
                    style: AppTheme.bodySmall.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing8),
                  Wrap(
                    spacing: AppTheme.spacing6,
                    runSpacing: AppTheme.spacing6,
                    children: (tactic['contexts'] as List<String>).map((context) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacing10,
                          vertical: AppTheme.spacing6,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.secondaryGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                          border: Border.all(
                            color: AppTheme.secondaryGreen.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          context,
                          style: AppTheme.labelSmall.copyWith(
                            color: AppTheme.secondaryGreen,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
