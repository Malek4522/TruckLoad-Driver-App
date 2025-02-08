import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'pages/tasks_page.dart';
import 'pages/transactions_page.dart';
import 'pages/profile_page.dart';
import 'utils/app_colors.dart';
import 'utils/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;
  final languageCode = prefs.getString('languageCode') ?? 'en';
  runApp(MyApp(
    initialDarkMode: isDarkMode,
    initialLocale: Locale(languageCode),
  ));
}

class MyApp extends StatefulWidget {
  final bool initialDarkMode;
  final Locale initialLocale;
  
  const MyApp({
    super.key,
    required this.initialDarkMode,
    required this.initialLocale,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool isDarkMode;
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    isDarkMode = widget.initialDarkMode;
    _locale = widget.initialLocale;
  }

  void toggleTheme() async {
    setState(() {
      isDarkMode = !isDarkMode;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }

  void setLocale(Locale newLocale) async {
    setState(() {
      _locale = newLocale;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', newLocale.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Delivery Tasks',
      locale: _locale,
      supportedLocales: const [
        Locale('en'),
        Locale('fr'),
        Locale('ar'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryBlue,
          primary: AppColors.primaryBlue,
          brightness: isDarkMode ? Brightness.dark : Brightness.light,
        ),
        scaffoldBackgroundColor: isDarkMode 
            ? AppColors.darkBackground 
            : AppColors.lightBackground,
        cardColor: isDarkMode 
            ? AppColors.darkCard 
            : AppColors.lightCard,
        textTheme: TextTheme(
          bodyLarge: TextStyle(
            color: isDarkMode 
                ? AppColors.darkText 
                : AppColors.lightText,
          ),
          bodyMedium: TextStyle(
            color: isDarkMode 
                ? AppColors.darkTextSecondary 
                : AppColors.lightTextSecondary,
          ),
        ),
        useMaterial3: true,
      ),
      // Option 1: Start with Login Page
      /*home: Builder(
        builder: (context) => LoginPage(
          onLoginSuccess: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ResponsiveLayout(
                  isDarkMode: isDarkMode,
                  onThemeToggle: toggleTheme,
                ),
              ),
            );
          },
        ),
      ),*/
      
      // Option 2: Start with Tasks Page (ResponsiveLayout)
      home: ResponsiveLayout(
        isDarkMode: isDarkMode,
        onThemeToggle: toggleTheme,
        currentLocale: _locale,
        onLocaleChange: setLocale,
      ),
    );
  }
}

class ResponsiveLayout extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onThemeToggle;
  final Locale currentLocale;
  final Function(Locale) onLocaleChange;

  const ResponsiveLayout({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
    required this.currentLocale,
    required this.onLocaleChange,
  });

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  int _selectedIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        switch (_selectedIndex) {
          case 0:
            return const TasksPage();
          case 1:
            return const TransactionsPage();
          case 2:
            return ProfilePage(
              isDarkMode: widget.isDarkMode,
              onThemeToggle: widget.onThemeToggle,
              currentLocale: widget.currentLocale,
              onLocaleChange: widget.onLocaleChange,
            );
          default:
            return const TasksPage();
        }
      }),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.task_alt),
            label: AppLocalizations.of(context).get('tasks'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.account_balance_wallet_outlined),
            label: AppLocalizations.of(context).get('transactions'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.person),
            label: AppLocalizations.of(context).get('profile'),
          ),
        ],
      ),
    );
  }
}
