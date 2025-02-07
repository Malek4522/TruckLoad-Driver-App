import 'package:flutter/material.dart';
import '../pages/login_page.dart';
import '../utils/app_colors.dart';
import '../utils/app_localizations.dart';
import '../layouts/responsive_layout.dart';

class ProfilePage extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onThemeToggle;
  final Locale currentLocale;
  final Function(Locale) onLocaleChange;

  const ProfilePage({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
    required this.currentLocale,
    required this.onLocaleChange,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late AppLanguage _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = AppLanguage.values.firstWhere(
      (lang) => lang.locale.languageCode == widget.currentLocale.languageCode,
      orElse: () => AppLanguage.EN,
    );
  }

  Widget _buildInfoItem(String label, String value, {IconData? icon, Widget? trailing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF1E6B5C).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF1E6B5C),
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                if (label == 'Delivery Types')
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: value.split(', ').map((type) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E6B5C).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        type,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF1E6B5C),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )).toList(),
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          value,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      if (trailing != null) trailing,
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final loc = AppLocalizations.of(context);
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          loc.get('profile'),
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                                color: Colors.white,
                              ),
                              onPressed: widget.onThemeToggle,
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(0.2),
                                padding: const EdgeInsets.all(12),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.logout, color: Colors.white),
                              onPressed: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => LoginPage(
                                      onLoginSuccess: () {
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) => ResponsiveLayout(
                                              isDarkMode: widget.isDarkMode,
                                              onThemeToggle: widget.onThemeToggle,
                                              currentLocale: widget.currentLocale,
                                              onLocaleChange: widget.onLocaleChange,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  (route) => false,
                                );
                                
                              },
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.red.withOpacity(0.8),
                                padding: const EdgeInsets.all(12),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'David Russel',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.circle,
                                      size: 8,
                                      color: Colors.green,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      loc.get('online'),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'PO 12345',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  top: 24,
                  left: 16,
                  right: 16,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        loc.get('personal_info'),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    _buildInfoItem(
                      loc.get('full_name'),
                      'David Michael Russel',
                      icon: Icons.person_outline,
                    ),
                    _buildInfoItem(
                      loc.get('email'),
                      'david.russel@example.com',
                      icon: Icons.email_outlined,
                    ),
                    _buildInfoItem(
                      loc.get('phone'),
                      '+48 123 456 789',
                      icon: Icons.phone_outlined,
                    ),
                    const Divider(height: 32, indent: 16, endIndent: 16),
                    _buildInfoItem(
                      loc.get('language'),
                      _selectedLanguage.displayName,
                      icon: Icons.language_outlined,
                      trailing: PopupMenuButton<AppLanguage>(
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Color(0xFF1E6B5C),
                        ),
                        onSelected: (AppLanguage language) {
                          setState(() {
                            _selectedLanguage = language;
                          });
                          widget.onLocaleChange(language.locale);
                        },
                        itemBuilder: (BuildContext context) {
                          return AppLanguage.values.map((AppLanguage language) {
                            return PopupMenuItem<AppLanguage>(
                              value: language,
                              child: Text(
                                language.displayName,
                                style: TextStyle(
                                  fontWeight: language == _selectedLanguage 
                                      ? FontWeight.bold 
                                      : FontWeight.normal,
                                ),
                              ),
                            );
                          }).toList();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        loc.get('vehicle_info'),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    _buildInfoItem(
                      loc.get('vehicle_type'),
                      'Delivery Van',
                      icon: Icons.local_shipping_outlined,
                    ),
                    _buildInfoItem(
                      loc.get('car_model'),
                      'Mercedes-Benz Sprinter',
                      icon: Icons.directions_car_outlined,
                    ),
                    _buildInfoItem(
                      loc.get('license_plate'),
                      'WA 12345',
                      icon: Icons.badge_outlined,
                    ),
                    const Divider(height: 32, indent: 16, endIndent: 16),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        loc.get('delivery_capabilities'),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    _buildInfoItem(
                      loc.get('max_weight'),
                      '1,500 lbs',
                      icon: Icons.scale_outlined,
                    ),
                    _buildInfoItem(
                      loc.get('max_volume'),
                      '12.7 m³',
                      icon: Icons.view_in_ar_outlined,
                    ),
                    _buildInfoItem(
                      loc.get('cargo_dimensions'),
                      '170" × 70" × 77"',
                      icon: Icons.straighten_outlined,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            loc.get('delivery_types'),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: DeliveryType.values.map((type) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E6B5C).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                type.name,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF1E6B5C),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
} 