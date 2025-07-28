import 'package:flutter/material.dart';
import '../../domain/entities/apk_version.dart';

class VersionUpdateDialog extends StatelessWidget {
  final ApkVersion latestVersion;
  final String currentVersion;
  final VoidCallback onUpdate;
  final VoidCallback? onSkip;

  const VersionUpdateDialog({
    super.key,
    required this.latestVersion,
    required this.currentVersion,
    required this.onUpdate,
    this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          Icon(
            Icons.system_update,
            color: Colors.blue,
            size: 28,
          ),
          const SizedBox(width: 12),
          const Text(
            'Update Available',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'A new version of the app is available.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 16),
          _buildVersionInfo('Current Version', currentVersion),
          const SizedBox(height: 8),
          _buildVersionInfo('Latest Version', latestVersion.version),
          const SizedBox(height: 16),
          if (latestVersion.category.description.isNotEmpty) ...[
            Text(
              'What\'s New:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              latestVersion.category.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ],
      ),
      actions: [
        if (onSkip != null)
          TextButton(
            onPressed: onSkip,
            child: const Text(
              'Skip',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ElevatedButton(
          onPressed: onUpdate,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Update Now',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildVersionInfo(String label, String version) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            version,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }
} 