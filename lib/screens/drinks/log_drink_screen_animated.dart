import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/drink_provider_refactored.dart';
import '../../providers/user_provider_refactored.dart';
import '../../models/drink.dart';
import '../../core/design/app_theme.dart';
import '../../core/widgets/glass_button.dart';
import '../../core/widgets/animated_card.dart';
import '../../core/animations/staggered_list.dart';
import '../../core/services/haptic_service.dart';

class LogDrinkScreenAnimated extends StatefulWidget {
  const LogDrinkScreenAnimated({super.key});

  @override
  State<LogDrinkScreenAnimated> createState() => _LogDrinkScreenAnimatedState();
}

class _LogDrinkScreenAnimatedState extends State<LogDrinkScreenAnimated> {
  String? _selectedDrinkType;
  double _units = 0.0;
  String _selectedMood = 'Happy';
  String _selectedContext = 'Home';
  final TextEditingController _notesController = TextEditingController();
  DateTime _selectedDateTime = DateTime.now();

  // Standard drink types with their units, icons, and descriptions
  final List<Map<String, dynamic>> _drinkTypes = [
    {'name': 'Pint of Beer', 'units': 2.3, 'icon': Icons.sports_bar, 'desc': '568ml glass'},
    {'name': 'Half Pint', 'units': 1.2, 'icon': Icons.local_drink, 'desc': '284ml glass'},
    {'name': 'Large Wine', 'units': 3.0, 'icon': Icons.wine_bar, 'desc': '250ml glass'},
    {'name': 'Medium Wine', 'units': 2.1, 'icon': Icons.wine_bar, 'desc': '175ml glass'},
    {'name': 'Small Wine', 'units': 1.5, 'icon': Icons.wine_bar, 'desc': '125ml glass'},
    {'name': 'Single Spirit', 'units': 1.0, 'icon': Icons.local_bar, 'desc': '25ml shot'},
    {'name': 'Double Spirit', 'units': 2.0, 'icon': Icons.local_bar, 'desc': '50ml measure'},
    {'name': 'Cocktail', 'units': 2.5, 'icon': Icons.nightlife, 'desc': 'Mixed drink'},
    {'name': 'Pint of Cider', 'units': 2.6, 'icon': Icons.sports_bar, 'desc': '568ml glass'},
    {'name': 'Alcopop', 'units': 1.5, 'icon': Icons.liquor, 'desc': '275ml bottle'},
    {'name': 'Prosecco', 'units': 1.5, 'icon': Icons.celebration, 'desc': '125ml flute'},
    {'name': 'Can of Beer', 'units': 1.8, 'icon': Icons.inventory_2, 'desc': '440ml can'},
  ];

  final List<String> _moods = ['Happy', 'Stressed', 'Sad', 'Bored', 'Anxious', 'Celebrating'];
  final List<String> _contexts = ['Home', 'Bar/Pub', 'Restaurant', 'Party', 'Friend\'s House', 'Other'];

  @override
  void initState() {
    super.initState();
    _selectedMood = _moods.first;
    _selectedContext = _contexts.first;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundCream,
      appBar: AppBar(
        title: const Text('Log a Drink'),
        backgroundColor: AppTheme.backgroundCream,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(AppTheme.spacing20),
          child: StaggeredList(
            children: [
              // Question: What did you drink?
              Text('What did you drink?', style: AppTheme.headlineMedium),
              const SizedBox(height: AppTheme.spacing12),
              _buildDrinkTypeSelector(),
              const SizedBox(height: AppTheme.spacing24),

              // Question: How were you feeling?
              Text('How were you feeling?', style: AppTheme.headlineMedium),
              const SizedBox(height: AppTheme.spacing12),
              _buildMoodSelector(),
              const SizedBox(height: AppTheme.spacing24),

              // Question: Where were you?
              Text('Where were you?', style: AppTheme.headlineMedium),
              const SizedBox(height: AppTheme.spacing12),
              _buildContextSelector(),
              const SizedBox(height: AppTheme.spacing24),

              // Question: When?
              Text('When?', style: AppTheme.headlineMedium),
              const SizedBox(height: AppTheme.spacing12),
              _buildDateTimePicker(),
              const SizedBox(height: AppTheme.spacing24),

              // Optional notes
              Text('Notes (optional)', style: AppTheme.headlineMedium),
              const SizedBox(height: AppTheme.spacing12),
              AnimatedCard(
                child: TextField(
                  controller: _notesController,
                  maxLines: 3,
                  style: AppTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'Any additional thoughts or observations...',
                    hintStyle: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textTertiary,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacing32),

              // Total units summary
              if (_selectedDrinkType != null) ...[
                AnimatedCard(
                  color: AppTheme.primaryBlue.withOpacity(0.1),
                  border: Border.all(
                    color: AppTheme.primaryBlue,
                    width: 2,
                  ),
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
                              Icons.local_drink,
                              color: AppTheme.primaryBlue,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: AppTheme.spacing12),
                          Text('Total Units:', style: AppTheme.titleMedium),
                        ],
                      ),
                      Text(
                        _units.toStringAsFixed(1),
                        style: AppTheme.displaySmall.copyWith(
                          color: AppTheme.primaryBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppTheme.spacing16),
              ],

              // Log button
              GlassButton(
                text: 'Log Drink',
                icon: Icons.check_circle_outline,
                onPressed: _selectedDrinkType != null ? _logDrink : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrinkTypeSelector() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.85,
        crossAxisSpacing: AppTheme.spacing8,
        mainAxisSpacing: AppTheme.spacing8,
      ),
      itemCount: _drinkTypes.length,
      itemBuilder: (context, index) {
        final drink = _drinkTypes[index];
        final isSelected = _selectedDrinkType == drink['name'];
        return GestureDetector(
          onTap: () async {
            await HapticService.selectionClick();
            setState(() {
              _selectedDrinkType = drink['name'] as String;
              _units = drink['units'] as double;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(AppTheme.spacing8),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.primaryBlue : AppTheme.cardBackground,
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              border: Border.all(
                color: isSelected ? AppTheme.primaryBlue : AppTheme.textTertiary.withOpacity(0.2),
                width: 2,
              ),
              boxShadow: isSelected ? [
                BoxShadow(
                  color: AppTheme.primaryBlue.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ] : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  drink['icon'] as IconData,
                  size: 28,
                  color: isSelected ? Colors.white : AppTheme.primaryBlue,
                ),
                const SizedBox(height: AppTheme.spacing4),
                Text(
                  drink['name'] as String,
                  style: AppTheme.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : AppTheme.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppTheme.spacing4),
                Text(
                  drink['desc'] as String,
                  style: TextStyle(
                    fontSize: 10,
                    color: isSelected ? Colors.white70 : AppTheme.textTertiary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppTheme.spacing4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacing6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withOpacity(0.2)
                        : AppTheme.primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  ),
                  child: Text(
                    '${drink['units']} units',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : AppTheme.primaryBlue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMoodSelector() {
    return Wrap(
      spacing: AppTheme.spacing8,
      runSpacing: AppTheme.spacing8,
      children: _moods.map((mood) {
        final isSelected = _selectedMood == mood;
        return GestureDetector(
          onTap: () async {
            await HapticService.selectionClick();
            setState(() {
              _selectedMood = mood;
            });
          },
          child: AnimatedCard(
            color: isSelected ? AppTheme.secondaryGreen : AppTheme.cardBackground,
            border: Border.all(
              color: isSelected ? AppTheme.secondaryGreen : AppTheme.textTertiary.withOpacity(0.3),
              width: 2,
            ),
            child: Text(
              mood,
              style: AppTheme.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppTheme.textPrimary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildContextSelector() {
    return Wrap(
      spacing: AppTheme.spacing8,
      runSpacing: AppTheme.spacing8,
      children: _contexts.map((context) {
        final isSelected = _selectedContext == context;
        return GestureDetector(
          onTap: () async {
            await HapticService.selectionClick();
            setState(() {
              _selectedContext = context;
            });
          },
          child: AnimatedCard(
            color: isSelected ? AppTheme.accentPurple : AppTheme.cardBackground,
            border: Border.all(
              color: isSelected ? AppTheme.accentPurple : AppTheme.textTertiary.withOpacity(0.3),
              width: 2,
            ),
            child: Text(
              context,
              style: AppTheme.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppTheme.textPrimary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDateTimePicker() {
    return GestureDetector(
      onTap: () async {
        await HapticService.lightImpact();
        _pickDateTime();
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
                  DateFormat('MMM d, yyyy \'at\' h:mm a').format(_selectedDateTime),
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
    );
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
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

    if (date == null) return;

    if (!mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
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

    if (time == null) return;

    setState(() {
      _selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  void _logDrink() async {
    await HapticService.mediumImpact();

    final userProvider = context.read<UserProvider>();
    final drinkProvider = context.read<DrinkProvider>();

    final drink = Drink(
      timestamp: _selectedDateTime,
      drinkType: _selectedDrinkType!,
      units: _units,
      mood: _selectedMood,
      context: _selectedContext,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
      userId: userProvider.user!.id,
    );

    final success = await drinkProvider.logDrink(drink);

    if (!mounted) return;

    if (success) {
      await HapticService.success();
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: AppTheme.spacing12),
              const Text('Drink logged successfully!'),
            ],
          ),
          backgroundColor: AppTheme.secondaryGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          ),
        ),
      );
    } else {
      await HapticService.error();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: AppTheme.spacing12),
              Text(drinkProvider.error?.message ?? 'Failed to log drink'),
            ],
          ),
          backgroundColor: AppTheme.dangerRose,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          ),
        ),
      );
    }
  }
}
