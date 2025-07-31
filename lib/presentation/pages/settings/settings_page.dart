import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../widgets/language_selector.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Locale _currentLocale = const Locale('en');

  @override
  void initState() {
    super.initState();
    // TODO: Load saved locale from SharedPreferences
    _loadSavedLocale();
  }

  void _loadSavedLocale() {
    // TODO: Implement loading saved locale
    // For now, default to English
    setState(() {
      _currentLocale = const Locale('en');
    });
  }

  void _saveLocale(Locale locale) {
    // TODO: Save locale to SharedPreferences
    setState(() {
      _currentLocale = locale;
    });
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          locale.languageCode == 'en' 
            ? 'Language changed to English' 
            : 'Хэл Монгол руу өөрчлөгдлөө',
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).settings,
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Language Settings Section
              Text(
                'Language Settings',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              LanguageSelector(
                currentLocale: _currentLocale,
                onLanguageChanged: _saveLocale,
              ),
              const SizedBox(height: 32),
              
              // App Information Section
              Text(
                'App Information',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                context,
                'App Name',
                AppLocalizations.of(context).appName,
                Icons.apps,
              ),
              const SizedBox(height: 12),
              _buildInfoCard(
                context,
                'Version',
                '1.0.0',
                Icons.info,
              ),
              const SizedBox(height: 12),
              _buildInfoCard(
                context,
                'Build Number',
                '1',
                Icons.build,
              ),
              const SizedBox(height: 32),
              
              // Support Section
              Text(
                'Support',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              _buildActionCard(
                context,
                AppLocalizations.of(context).help,
                'Get help and support',
                Icons.help,
                () {
                  // TODO: Navigate to help page
                },
              ),
              const SizedBox(height: 12),
              _buildActionCard(
                context,
                AppLocalizations.of(context).contactUs,
                'Contact our support team',
                Icons.contact_support,
                () {
                  // TODO: Navigate to contact page
                },
              ),
              const SizedBox(height: 12),
              _buildActionCard(
                context,
                AppLocalizations.of(context).about,
                'Learn more about the app',
                Icons.info_outline,
                () {
                  // TODO: Navigate to about page
                },
              ),
              const SizedBox(height: 32),
              
              // Legal Section
              Text(
                'Legal',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              _buildActionCard(
                context,
                AppLocalizations.of(context).privacyPolicy,
                'Read our privacy policy',
                Icons.privacy_tip,
                () {
                  // TODO: Navigate to privacy policy
                },
              ),
              const SizedBox(height: 12),
              _buildActionCard(
                context,
                AppLocalizations.of(context).termsOfService,
                'Read our terms of service',
                Icons.description,
                () {
                  // TODO: Navigate to terms of service
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textSecondary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
} 