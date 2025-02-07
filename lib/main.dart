import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/tasks_page.dart';
import 'pages/transactions_page.dart';
import 'pages/profile_page.dart';
//import 'pages/login_page.dart';
import 'utils/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;
  runApp(MyApp(initialDarkMode: isDarkMode));
}

class MyApp extends StatefulWidget {
  final bool initialDarkMode;
  
  const MyApp({
    super.key,
    required this.initialDarkMode,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    isDarkMode = widget.initialDarkMode;
  }

  void toggleTheme() async {
    setState(() {
      isDarkMode = !isDarkMode;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Delivery Tasks',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryGreen,
          primary: AppColors.primaryGreen,
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
      ),
    );
  }
}

class ResponsiveLayout extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onThemeToggle;

  const ResponsiveLayout({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  int _selectedIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          const TasksPage(),
          const TransactionsPage(),
          ProfilePage(
            isDarkMode: widget.isDarkMode,
            onThemeToggle: widget.onThemeToggle,
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.task_alt),
            label: 'Tasks',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            label: 'Transactions',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
