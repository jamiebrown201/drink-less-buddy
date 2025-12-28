import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/intention_provider.dart';
import '../../providers/user_provider.dart';
import '../../models/intention.dart';
import '../../utils/constants.dart';

class SetIntentionScreen extends StatefulWidget {
  const SetIntentionScreen({super.key});

  @override
  State<SetIntentionScreen> createState() => _SetIntentionScreenState();
}

class _SetIntentionScreenState extends State<SetIntentionScreen> {
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
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('Set Tomorrow\'s Intention'),
        backgroundColor: AppConstants.backgroundColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppConstants.warningColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppConstants.warningColor,
                  width: 2,
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb,
                        color: AppConstants.warningColor,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Why This Works',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Research shows that setting specific intentions for tomorrow reduces alcohol consumption by 31%. When you have something meaningful to do, you\'re more likely to moderate your drinking tonight.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'What do you want to do?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Quick suggestions:',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _suggestedActivities.map((activity) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _activityController.text = activity;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppConstants.primaryColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      activity,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppConstants.primaryColor,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _activityController,
              decoration: InputDecoration(
                hintText: 'E.g., "Morning gym session"',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.event_note),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            const Text(
              'What time?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _timeController,
              decoration: InputDecoration(
                hintText: 'E.g., "8:00 AM" or "Morning"',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.access_time),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Why does this matter to you? (optional)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _reasonController,
              decoration: InputDecoration(
                hintText: 'E.g., "Want to be sharp for my presentation"',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.favorite),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            const Text(
              'For which day?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _intentionDate.day == DateTime.now().day + 1
                          ? 'Tomorrow - ${_intentionDate.day}/${_intentionDate.month}/${_intentionDate.year}'
                          : '${_intentionDate.day}/${_intentionDate.month}/${_intentionDate.year}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Icon(
                      Icons.calendar_today,
                      color: AppConstants.primaryColor,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Consumer<IntentionProvider>(
              builder: (context, provider, _) {
                final existingIntentions =
                    provider.getIntentionsForDate(_intentionDate);

                if (existingIntentions.isNotEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Existing intentions for this day:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...existingIntentions.map((intention) => Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppConstants.secondaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.check_circle,
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
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    provider.deleteIntention(intention.id);
                                  },
                                ),
                              ],
                            ),
                          )),
                      const SizedBox(height: 16),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            ElevatedButton(
              onPressed: _activityController.text.isNotEmpty
                  ? _saveIntention
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Set Intention',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          ],
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
    );

    if (date != null) {
      setState(() {
        _intentionDate = date;
      });
    }
  }

  void _saveIntention() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final intentionProvider =
        Provider.of<IntentionProvider>(context, listen: false);

    final intention = Intention(
      createdAt: DateTime.now(),
      intentionDate: _intentionDate,
      activity: _activityController.text,
      time: _timeController.text.isEmpty ? null : _timeController.text,
      reason: _reasonController.text.isEmpty ? null : _reasonController.text,
      userId: userProvider.user!.id,
    );

    intentionProvider.addIntention(intention);

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Intention set successfully!'),
        backgroundColor: AppConstants.secondaryColor,
      ),
    );
  }
}
