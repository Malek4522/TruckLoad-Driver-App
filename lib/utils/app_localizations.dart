import 'package:flutter/material.dart';

enum AppLanguage {
  EN('English', Locale('en')),
  FR('Français', Locale('fr')),
  AR('العربية', Locale('ar'));

  final String displayName;
  final Locale locale;
  
  const AppLanguage(this.displayName, this.locale);
}

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // General
      'app_name': 'Delivery Tasks',
      'ok': 'OK',
      'cancel': 'Cancel',
      'save': 'Save',
      'delete': 'Delete',
      'edit': 'Edit',
      
      // Navigation & Pages
      'tasks': 'Tasks',
      'my_tasks': 'My Tasks',
      'all_tasks': 'All Tasks',
      'transactions': 'Transactions',
      'profile': 'Profile',
      'login': 'Login',
      'welcome_back': 'Welcome Back',
      'sign_in': 'Sign in to continue',
      'email_phone': 'Email or Phone',
      'password': 'Password',
      'sign_in_button': 'Sign In',
      'email_placeholder': 'Enter your email',
      'phone_placeholder': 'Enter your phone number',
      'password_placeholder': 'Enter your password',
      
      // Task Status
      'awaiting': 'Awaiting',
      'rejected': 'Rejected',
      'in_way': 'In Way',
      'arrived': 'Arrived',
      'completed': 'Completed',
      'accident': 'Accident',
      
      // Task Actions
      'accept': 'Accept',
      'decline': 'Decline',
      'mark_arrived': 'Mark as Arrived',
      'mark_completed': 'Mark as Completed',
      'report_accident': 'Report Accident',
      
      // Task Details
      'pickup': 'Pickup',
      'delivery': 'Delivery',
      'distance': 'Distance',
      'weight': 'Weight',
      'volume': 'Volume',
      'amount': 'Amount',
      'company': 'Company',
      'phone_number': 'Phone Number',
      'description': 'Description',
      'delivery_types': 'Delivery Types',
      'estimated_duration': 'Estimated Duration',
      'task_details': 'Task Details',
      'route_info': 'Route Information',
      'package_info': 'Package Information',
      
      // Transactions
      'recent_transactions': 'Recent Transactions',
      'all_transactions': 'All Transactions',
      'transaction_id': 'Transaction ID',
      'date': 'Date',
      'status': 'Status',
      'earnings': 'Earnings',
      'total_earnings': 'Total Earnings',
      'today': 'Today',
      'this_week': 'This Week',
      'this_month': 'This Month',
      'insights': 'Insights',
      'today_earnings': 'Today\'s Earnings',
      'pending_amount': 'Pending Amount',
      'last_month': 'Last Month',
      'avg_per_day': 'Avg. per Day',
      'active': 'Active',
      'history': 'History',
      'yesterday': 'Yesterday',
      
      // Profile
      'profile': 'Profile',
      'personal_info': 'Personal Information',
      'full_name': 'Full Name',
      'email': 'Email',
      'phone': 'Phone',
      'language': 'Language',
      'theme': 'Theme',
      'dark_mode': 'Dark Mode',
      'light_mode': 'Light Mode',
      'logout': 'Logout',
      'online_status': 'ONLINE',
      'offline_status': 'OFFLINE',
      'driver_id': 'Driver ID',
      
      // Vehicle Info
      'vehicle_info': 'Vehicle Information',
      'vehicle_type': 'Vehicle Type',
      'car_model': 'Car Model',
      'license_plate': 'License Plate',
      'delivery_capabilities': 'Delivery Capabilities',
      'max_weight': 'Maximum Weight',
      'max_volume': 'Maximum Volume',
      'cargo_dimensions': 'Cargo Dimensions',
      'temperature_range': 'Temperature Range',
    },
    'fr': {
      // General
      'app_name': 'Tâches de Livraison',
      'ok': 'OK',
      'cancel': 'Annuler',
      'save': 'Enregistrer',
      'delete': 'Supprimer',
      'edit': 'Modifier',
      
      // Navigation & Pages
      'tasks': 'Tâches',
      'my_tasks': 'Mes Tâches',
      'all_tasks': 'Toutes les Tâches',
      'transactions': 'Transactions',
      'profile': 'Profil',
      'login': 'Connexion',
      'welcome_back': 'Bienvenue',
      'sign_in': 'Connectez-vous pour continuer',
      'email_phone': 'Email ou Téléphone',
      'password': 'Mot de passe',
      'sign_in_button': 'Se Connecter',
      'email_placeholder': 'Entrez votre email',
      'phone_placeholder': 'Entrez votre numéro de téléphone',
      'password_placeholder': 'Entrez votre mot de passe',
      
      // Task Status
      'awaiting': 'En Attente',
      'rejected': 'Refusé',
      'in_way': 'En Route',
      'arrived': 'Arrivé',
      'completed': 'Terminé',
      'accident': 'Accident',
      
      // Task Actions
      'accept': 'Accepter',
      'decline': 'Refuser',
      'mark_arrived': 'Marquer comme Arrivé',
      'mark_completed': 'Marquer comme Terminé',
      'report_accident': 'Signaler un Accident',
      
      // Task Details
      'pickup': 'Ramassage',
      'delivery': 'Livraison',
      'distance': 'Distance',
      'weight': 'Poids',
      'volume': 'Volume',
      'amount': 'Montant',
      'company': 'Entreprise',
      'phone_number': 'Numéro de Téléphone',
      'description': 'Description',
      'delivery_types': 'Types de Livraison',
      'estimated_duration': 'Durée Estimée',
      'task_details': 'Détails de la Tâche',
      'route_info': 'Informations sur l\'Itinéraire',
      'package_info': 'Informations sur le Colis',
      
      // Transactions
      'recent_transactions': 'Transactions Récentes',
      'all_transactions': 'Toutes les Transactions',
      'transaction_id': 'ID de Transaction',
      'date': 'Date',
      'status': 'Statut',
      'earnings': 'Gains',
      'total_earnings': 'Gains Totaux',
      'today': 'Aujourd\'hui',
      'this_week': 'Cette Semaine',
      'this_month': 'Ce Mois',
      'insights': 'Aperçu',
      'today_earnings': 'Gains du Jour',
      'pending_amount': 'Montant en Attente',
      'last_month': 'Mois Dernier',
      'avg_per_day': 'Moy. par Jour',
      'active': 'Actif',
      'history': 'Historique',
      'yesterday': 'Hier',
      
      // Profile
      'profile': 'Profil',
      'personal_info': 'Informations Personnelles',
      'full_name': 'Nom Complet',
      'email': 'Email',
      'phone': 'Téléphone',
      'language': 'Langue',
      'theme': 'Thème',
      'dark_mode': 'Mode Sombre',
      'light_mode': 'Mode Clair',
      'logout': 'Déconnexion',
      'online_status': 'EN LIGNE',
      'offline_status': 'HORS LIGNE',
      'driver_id': 'ID du Chauffeur',
      
      // Vehicle Info
      'vehicle_info': 'Informations du Véhicule',
      'vehicle_type': 'Type de Véhicule',
      'car_model': 'Modèle de Voiture',
      'license_plate': 'Plaque d\'Immatriculation',
      'delivery_capabilities': 'Capacités de Livraison',
      'max_weight': 'Poids Maximum',
      'max_volume': 'Volume Maximum',
      'cargo_dimensions': 'Dimensions de Cargo',
      'temperature_range': 'Plage de Température',
    },
    'ar': {
      // General
      'app_name': 'مهام التوصيل',
      'ok': 'موافق',
      'cancel': 'إلغاء',
      'save': 'حفظ',
      'delete': 'حذف',
      'edit': 'تعديل',
      
      // Navigation & Pages
      'tasks': 'المهام',
      'my_tasks': 'مهامي',
      'all_tasks': 'كل المهام',
      'transactions': 'المعاملات',
      'profile': 'الملف الشخصي',
      'login': 'تسجيل الدخول',
      'welcome_back': 'مرحباً بعودتك',
      'sign_in': 'سجل دخول للمتابعة',
      'email_phone': 'البريد الإلكتروني أو الهاتف',
      'password': 'كلمة المرور',
      'sign_in_button': 'تسجيل الدخول',
      'email_placeholder': 'أدخل بريدك الإلكتروني',
      'phone_placeholder': 'أدخل رقم هاتفك',
      'password_placeholder': 'أدخل كلمة المرور',
      
      // Task Status
      'awaiting': 'قيد الانتظار',
      'rejected': 'مرفوض',
      'in_way': 'في الطريق',
      'arrived': 'وصل',
      'completed': 'مكتمل',
      'accident': 'حادث',
      
      // Task Actions
      'accept': 'قبول',
      'decline': 'رفض',
      'mark_arrived': 'تحديد كواصل',
      'mark_completed': 'تحديد كمكتمل',
      'report_accident': 'الإبلاغ عن حادث',
      
      // Task Details
      'pickup': 'نقطة الاستلام',
      'delivery': 'نقطة التسليم',
      'distance': 'المسافة',
      'weight': 'الوزن',
      'volume': 'الحجم',
      'amount': 'المبلغ',
      'company': 'الشركة',
      'phone_number': 'رقم الهاتف',
      'description': 'الوصف',
      'delivery_types': 'أنواع التوصيل',
      'estimated_duration': 'المدة المتوقعة',
      'task_details': 'تفاصيل المهمة',
      'route_info': 'معلومات المسار',
      'package_info': 'معلومات الطرد',
      
      // Transactions
      'recent_transactions': 'المعاملات الأخيرة',
      'all_transactions': 'جميع المعاملات',
      'transaction_id': 'رقم المعاملة',
      'date': 'التاريخ',
      'status': 'الحالة',
      'earnings': 'الأرباح',
      'total_earnings': 'إجمالي الأرباح',
      'today': 'اليوم',
      'this_week': 'هذا الأسبوع',
      'this_month': 'هذا الشهر',
      'insights': 'نظرة عامة',
      'today_earnings': 'أرباح اليوم',
      'pending_amount': 'المبلغ المعلق',
      'last_month': 'الشهر الماضي',
      'avg_per_day': 'المتوسط اليومي',
      'active': 'نشط',
      'history': 'السجل',
      'yesterday': 'أمس',
      
      // Profile
      'profile': 'الملف الشخصي',
      'personal_info': 'المعلومات الشخصية',
      'full_name': 'الاسم الكامل',
      'email': 'البريد الإلكتروني',
      'phone': 'الهاتف',
      'language': 'اللغة',
      'theme': 'المظهر',
      'dark_mode': 'الوضع الداكن',
      'light_mode': 'الوضع الفاتح',
      'logout': 'تسجيل الخروج',
      'online_status': 'متصل',
      'offline_status': 'غير متصل',
      'driver_id': 'رقم السائق',
      
      // Vehicle Info
      'vehicle_info': 'معلومات المركبة',
      'vehicle_type': 'نوع المركبة',
      'car_model': 'موديل السيارة',
      'license_plate': 'رقم اللوحة',
      'delivery_capabilities': 'قدرات التوصيل',
      'max_weight': 'الوزن الأقصى',
      'max_volume': 'الحجم الأقصى',
      'cargo_dimensions': 'أبعاد الشحن',
      'temperature_range': 'نطاق درجة الحرارة',
    },
  };

  String get(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'fr', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
} 