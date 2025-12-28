import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/di/service_locator.dart';
import 'providers/drink_provider_refactored.dart';
import 'providers/intention_provider_refactored.dart';
import 'providers/user_provider_refactored.dart';
import 'screens/onboarding/age_verification_screen.dart';
import 'screens/home/home_screen.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await ServiceLocator.instance.init();

  runApp(const DrinkLessBuddyApp());
}

class DrinkLessBuddyApp extends StatelessWidget {
  const DrinkLessBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(
          create: (_) => ServiceLocator.get<UserProvider>(),
        ),
        ChangeNotifierProvider<DrinkProvider>(
          create: (_) => ServiceLocator.get<DrinkProvider>(),
        ),
        ChangeNotifierProvider<IntentionProvider>(
          create: (_) => ServiceLocator.get<IntentionProvider>(),
        ),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppConstants.primaryColor,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          fontFamily: 'Helvetica Neue',
        ),
        home: const AppInitializer(),
      ),
    );
  }
}

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final userProvider = context.read<UserProvider>();
    await userProvider.loadUserData();

    if (!mounted) return;

    // Check for errors
    if (userProvider.hasError) {
      _showErrorAndRetry(userProvider.error!.message);
      return;
    }

    // Navigate based on onboarding status
    final destination = userProvider.hasCompletedOnboarding
        ? const HomeScreen()
        : const AgeVerificationScreen();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => destination),
    );
  }

  void _showErrorAndRetry(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Initialization Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _initializeApp();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Initializing Drink Less Buddy...',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
