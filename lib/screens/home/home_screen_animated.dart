import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/drink_provider_refactored.dart';
import '../../providers/intention_provider_refactored.dart';
import '../../core/design/app_theme.dart';
import '../../core/services/haptic_service.dart';
import '../drinks/drinks_tab_animated.dart';
import '../analytics/analytics_tab_animated.dart';
import '../tactics/tactics_tab_animated.dart';
import '../research/research_tab_animated.dart';
import '../profile/profile_tab_animated.dart';

class HomeScreenAnimated extends StatefulWidget {
  const HomeScreenAnimated({super.key});

  @override
  State<HomeScreenAnimated> createState() => _HomeScreenAnimatedState();
}

class _HomeScreenAnimatedState extends State<HomeScreenAnimated> {
  int _currentIndex = 0;

  final List<Widget> _tabs = const [
    DrinksTabAnimated(),
    AnalyticsTabAnimated(),
    TacticsTabAnimated(),
    ResearchTabAnimated(),
    ProfileTabAnimated(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final drinkProvider = context.read<DrinkProvider>();
    final intentionProvider = context.read<IntentionProvider>();

    await Future.wait([
      drinkProvider.loadDrinks(),
      intentionProvider.loadIntentions(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundCream,
      body: _tabs[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) async {
            await HapticService.selectionClick();
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppTheme.primaryBlue,
          unselectedItemColor: AppTheme.textTertiary,
          selectedFontSize: 12,
          unselectedFontSize: 11,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.local_drink_outlined),
              activeIcon: Icon(Icons.local_drink),
              label: 'Track',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined),
              activeIcon: Icon(Icons.bar_chart),
              label: 'Insights',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.lightbulb_outline),
              activeIcon: Icon(Icons.lightbulb),
              label: 'Tactics',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school_outlined),
              activeIcon: Icon(Icons.school),
              label: 'Research',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
