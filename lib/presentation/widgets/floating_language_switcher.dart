import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/localization/locale_provider.dart';
import '../../core/theme/app_colors.dart';

class FloatingLanguageSwitcher extends StatelessWidget {
  const FloatingLanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        return FloatingActionButton(
          onPressed: () => _showLanguageDialog(context, localeProvider),
          backgroundColor: AppColors.primary,
          child: Text(
            localeProvider.locale.languageCode.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        );
      },
    );
  }

  void _showLanguageDialog(BuildContext context, LocaleProvider localeProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.language, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                'Select Language',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageOption(
                context,
                'English',
                'EN',
                'en',
                localeProvider,
                Icons.flag,
              ),
              const SizedBox(height: 8),
              _buildLanguageOption(
                context,
                'Монгол',
                'MN',
                'mn',
                localeProvider,
                Icons.flag,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    String languageName,
    String languageCode,
    String localeCode,
    LocaleProvider localeProvider,
    IconData icon,
  ) {
    final isSelected = localeProvider.locale.languageCode == localeCode;
    
    return InkWell(
      onTap: () {
        localeProvider.setLanguage(localeCode);
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              localeCode == 'en' 
                ? 'Language changed to English' 
                : 'Хэл Монгол руу өөрчлөгдлөө',
            ),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    languageName,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    languageCode,
                    style: TextStyle(
                      color: isSelected ? AppColors.primary : AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.primary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
} 