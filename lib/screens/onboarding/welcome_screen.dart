import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../utils/constants.dart';
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
    _goalController.text = AppConstants.ukGuidelineUnitsPerWeek.toString();
  }

  @override
  void dispose() {
    _goalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              const Text(
                'Welcome to\nDrink Less Buddy',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Evidence-based tools to help you reduce drinking, not eliminate it entirely.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              _buildFeatureCard(
                Icons.track_changes,
                'Self-Monitoring',
                'Track every drink with mood and context. Self-monitoring alone reduces consumption by 25%.',
              ),
              const SizedBox(height: 16),
              _buildFeatureCard(
                Icons.insights,
                'Personalized Feedback',
                'See patterns in your drinking and compare to UK guidelines. 31% average reduction.',
              ),
              const SizedBox(height: 16),
              _buildFeatureCard(
                Icons.lightbulb,
                'Evidence-Based Tactics',
                'Learn proven strategies for reducing consumption in different contexts.',
              ),
              const SizedBox(height: 16),
              _buildFeatureCard(
                Icons.event_note,
                'Daily Intentions',
                'Set goals for tomorrow\'s activities you want to do hangover-free.',
              ),
              const SizedBox(height: 48),
              const Text(
                'Set Your Weekly Goal',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppConstants.secondaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppConstants.secondaryColor,
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    CheckboxListTile(
                      value: _useUKGuideline,
                      onChanged: (value) {
                        setState(() {
                          _useUKGuideline = value ?? false;
                          if (_useUKGuideline) {
                            _goalController.text =
                                AppConstants.ukGuidelineUnitsPerWeek.toString();
                          }
                        });
                      },
                      title: const Text(
                        'Use UK Chief Medical Officers\' guideline',
                        style: TextStyle(fontSize: 15),
                      ),
                      subtitle: const Text('14 units per week'),
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: AppConstants.secondaryColor,
                      contentPadding: EdgeInsets.zero,
                    ),
                    if (!_useUKGuideline) ...[
                      const SizedBox(height: 16),
                      TextField(
                        controller: _goalController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Weekly Goal (units)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          suffixText: 'units/week',
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _completeOnboarding,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, String description) {
    return Container(
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
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppConstants.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppConstants.primaryColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _completeOnboarding() {
    final goal = double.tryParse(_goalController.text);
    if (goal == null || goal <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid weekly goal'),
        ),
      );
      return;
    }

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.completeOnboarding(weeklyGoal: goal);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }
}
