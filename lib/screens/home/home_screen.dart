import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/drink_provider.dart';
import '../../providers/intention_provider.dart';
import '../../utils/constants.dart';
import '../drinks/drinks_tab.dart';
import '../analytics/analytics_tab.dart';
import '../tactics/tactics_tab.dart';
import '../research/research_tab.dart';
import '../profile/profile_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = const [
    DrinksTab(),
    AnalyticsTab(),
    TacticsTab(),
    ResearchTab(),
    ProfileTab(),
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final drinkProvider = Provider.of<DrinkProvider>(context, listen: false);
    final intentionProvider = Provider.of<IntentionProvider>(context, listen: false);

    await Future.wait([
      drinkProvider.loadDrinks(),
      intentionProvider.loadIntentions(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppConstants.primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_drink),
            label: 'Track',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Insights',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb_outline),
            label: 'Tactics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Research',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
