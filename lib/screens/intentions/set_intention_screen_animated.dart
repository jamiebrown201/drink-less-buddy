import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/intention_provider_refactored.dart';
import '../../providers/user_provider_refactored.dart';
import '../../models/intention.dart';
import '../../core/design/app_theme.dart';
import '../../core/widgets/glass_button.dart';
import '../../core/widgets/animated_card.dart';
import '../../core/animations/staggered_list.dart';
import '../../core/services/haptic_service.dart';

class SetIntentionScreenAnimated extends StatefulWidget {
  const SetIntentionScreenAnimated({super.key});

  @override
  State<SetIntentionScreenAnimated> createState() => _SetIntentionScreenAnimatedState();
}

class _SetIntentionScreenAnimatedState extends State<SetIntentionScreenAnimated> {
  final TextEditingController _activityController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  DateTime _intentionDate = DateTime.now().add(const Duration(days: 1));

  // Suggested activities for quick selection
  final List<String> _suggestedActivities = [
    'Morning workout',
    'Important meeting',
    'Spend time with family',
    'Work on a project',
    'Go for a run',
    'Productive morning',
    'Early appointment',
    'Study/Learn',
    'Outdoor activity',
    'Quality time with kids',
  ];

  @override
  void dispose() {
    _activityController.dispose();
    _timeController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundCream,
      appBar: AppBar(
        title: const Text('Set Tomorrow\'s Intention'),
        backgroundColor: AppTheme.backgroundCream,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(AppTheme.spacing20),
          child: StaggeredList(
            children: [
              // Why This Works Card
              AnimatedCard(
                color: AppTheme.accentPurple.withOpacity(0.1),
                border: Border.all(
                  color: AppTheme.accentPurple,
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
                            color: AppTheme.accentPurple.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                          ),
                          child: const Icon(
                            Icons.lightbulb_outline,
                            color: AppTheme.accentPurple,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: AppTheme.spacing12),
                        Text(
                          'Why This Works',
                          style: AppTheme.titleMedium.copyWith(
                            color: AppTheme.accentPurple,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacing12),
                    Text(
                      'Research shows that setting specific intentions for tomorrow reduces alcohol consumption by 31%. When you have something meaningful to do, you\'re more likely to moderate your drinking tonight.',
                      style: AppTheme.bodyMedium.copyWith(
                        height: 1.5,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacing24),

              Text('What do you want to do?', style: AppTheme.headlineMedium),
              const SizedBox(height: AppTheme.spacing12),
              Text(
                'Quick suggestions:',
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: AppTheme.spacing8),

              // Suggested activities
              Wrap(
                spacing: AppTheme.spacing8,
                runSpacing: AppTheme.spacing8,
                children: _suggestedActivities.map((activity) {
                  return GestureDetector(
                    onTap: () async {
                      await HapticService.selectionClick();
                      setState(() {
                        _activityController.text = activity;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacing12,
                        vertical: AppTheme.spacing8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                        border: Border.all(
                          color: AppTheme.primaryBlue.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        activity,
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppTheme.spacing16),

              // Activity Input
              AnimatedCard(
                child: TextField(
                  controller: _activityController,
                  style: AppTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'E.g., "Morning gym session"',
                    hintStyle: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textTertiary,
                    ),
                    prefixIcon: const Icon(Icons.event_note, color: AppTheme.primaryBlue),
                    border: InputBorder.none,
                  ),
                  maxLines: 2,
                ),
              ),
              const SizedBox(height: AppTheme.spacing24),

              Text('What time?', style: AppTheme.headlineMedium),
              const SizedBox(height: AppTheme.spacing12),
              AnimatedCard(
                child: TextField(
                  controller: _timeController,
                  style: AppTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'E.g., "8:00 AM" or "Morning"',
                    hintStyle: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textTertiary,
                    ),
                    prefixIcon: const Icon(Icons.access_time, color: AppTheme.primaryBlue),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacing24),

              Text(
                'Why does this matter to you? (optional)',
                style: AppTheme.headlineMedium,
              ),
              const SizedBox(height: AppTheme.spacing12),
              AnimatedCard(
                child: TextField(
                  controller: _reasonController,
                  style: AppTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'E.g., "Want to be sharp for my presentation"',
                    hintStyle: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textTertiary,
                    ),
                    prefixIcon: const Icon(Icons.favorite_border, color: AppTheme.primaryBlue),
                    border: InputBorder.none,
                  ),
                  maxLines: 3,
                ),
              ),
              const SizedBox(height: AppTheme.spacing24),

              Text('For which day?', style: AppTheme.headlineMedium),
              const SizedBox(height: AppTheme.spacing12),
              GestureDetector(
                onTap: () async {
                  await HapticService.lightImpact();
                  _pickDate();
                },
                child: AnimatedCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              Icons.calendar_today,
                              color: AppTheme.primaryBlue,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: AppTheme.spacing12),
                          Text(
                            _intentionDate.day == DateTime.now().day + 1
                                ? 'Tomorrow - ${DateFormat('MMM d, yyyy').format(_intentionDate)}'
                                : DateFormat('MMM d, yyyy').format(_intentionDate),
                            style: AppTheme.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const Icon(Icons.chevron_right, color: AppTheme.textTertiary),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacing32),

              // Existing Intentions
              Consumer<IntentionProvider>(
                builder: (context, provider, _) {
                  final existingIntentions =
                      provider.getIntentionsForDate(_intentionDate);

                  if (existingIntentions.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Existing intentions for this day:',
                        style: AppTheme.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacing12),
                      ...existingIntentions.map((intention) => AnimatedCard(
                            color: AppTheme.secondaryGreen.withOpacity(0.1),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  color: AppTheme.secondaryGreen,
                                  size: 20,
                                ),
                                const SizedBox(width: AppTheme.spacing12),
                                Expanded(
                                  child: Text(
                                    intention.activity,
                                    style: AppTheme.bodyMedium,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: AppTheme.dangerRose,
                                    size: 20,
                                  ),
                                  onPressed: () async {
                                    await HapticService.lightImpact();
                                    provider.deleteIntention(intention.id);
                                  },
                                ),
                              ],
                            ),
                          )),
                      const SizedBox(height: AppTheme.spacing16),
                    ],
                  );
                },
              ),

              GlassButton(
                text: 'Set Intention',
                icon: Icons.check_circle_outline,
                onPressed: _activityController.text.isNotEmpty
                    ? _saveIntention
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _intentionDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryBlue,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        _intentionDate = date;
      });
    }
  }

  void _saveIntention() async {
    await HapticService.mediumImpact();

    final userProvider = context.read<UserProvider>();
    final intentionProvider = context.read<IntentionProvider>();

    final intention = Intention(
      createdAt: DateTime.now(),
      intentionDate: _intentionDate,
      activity: _activityController.text,
      time: _timeController.text.isEmpty ? null : _timeController.text,
      reason: _reasonController.text.isEmpty ? null : _reasonController.text,
      userId: userProvider.user!.id,
    );

    await intentionProvider.addIntention(intention);

    if (!mounted) return;

    await HapticService.success();
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: AppTheme.spacing12),
            const Text('Intention set successfully!'),
          ],
        ),
        backgroundColor: AppTheme.secondaryGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        ),
      ),
    );
  }
}
