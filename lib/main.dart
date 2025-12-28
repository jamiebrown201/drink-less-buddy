import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/di/service_locator.dart';
import 'core/design/app_theme.dart';
import 'core/animations/slide_fade_transition.dart';
import 'screens/onboarding/age_verification_screen.dart';
import 'screens/home/home_screen.dart';
import 'providers/drink_provider_refactored.dart';
import 'providers/intention_provider_refactored.dart';
import 'providers/user_provider_refactored.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

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
        title: 'Drink Less Buddy',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppTheme.primaryBlue,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          fontFamily: AppTheme.fontFamily,
          scaffoldBackgroundColor: AppTheme.backgroundCream,
          // Custom text theme
          textTheme: const TextTheme(
            displayLarge: AppTheme.displayLarge,
            displayMedium: AppTheme.displayMedium,
            headlineLarge: AppTheme.headlineLarge,
            headlineMedium: AppTheme.headlineMedium,
            titleLarge: AppTheme.titleLarge,
            titleMedium: AppTheme.titleMedium,
            bodyLarge: AppTheme.bodyLarge,
            bodyMedium: AppTheme.bodyMedium,
            bodySmall: AppTheme.bodySmall,
            labelLarge: AppTheme.labelLarge,
            labelMedium: AppTheme.labelMedium,
          ),
          // Button theme
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacing24,
                vertical: AppTheme.spacing16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
            ),
          ),
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
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    final userProvider = context.read<UserProvider>();
    await userProvider.loadUserData();

    if (!mounted) return;

    // Handle errors
    if (userProvider.hasError) {
      _showErrorAndRetry(userProvider.error!.message);
      return;
    }

    // Navigate with custom transition
    final destination = userProvider.hasCompletedOnboarding
        ? const HomeScreen()
        : const AgeVerificationScreen();

    Navigator.of(context).pushReplacement(
      SlideFadeRoute(page: destination),
    );
  }

  void _showErrorAndRetry(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
        title: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: AppTheme.dangerRose,
            ),
            const SizedBox(width: AppTheme.spacing12),
            const Text('Initialization Error'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _checkFirstLaunch();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundCream,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.primaryBlue,
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacing24),
            Text(
              'Initializing...',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
