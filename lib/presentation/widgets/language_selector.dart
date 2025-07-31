import 'package:flutter/material.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_colors.dart';

class LanguageSelector extends StatelessWidget {
  final Locale currentLocale;
  final Function(Locale) onLanguageChanged;

  const LanguageSelector({
    super.key,
    required this.currentLocale,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Language',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildLanguageOption(
            context,
            'English',
            'EN',
            const Locale('en'),
            currentLocale.languageCode == 'en',
          ),
          const SizedBox(height: 12),
          _buildLanguageOption(
            context,
            'Монгол',
            'MN',
            const Locale('mn'),
            currentLocale.languageCode == 'mn',
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    String languageName,
    String languageCode,
    Locale locale,
    bool isSelected,
  ) {
    return InkWell(
      onTap: () => onLanguageChanged(locale),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    languageName,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    languageCode,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isSelected ? AppColors.primary : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 