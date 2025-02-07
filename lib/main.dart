import 'package:flutter/material.dart';
import 'pages/tasks_page.dart';
import 'pages/transactions_page.dart';
import 'pages/profile_page.dart';
import 'utils/app_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
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
