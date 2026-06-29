import 'package:flutter/material.dart';

enum AppFlashType { error, success, update, warning, info }

void showAppFlashMessage(
  BuildContext context, {
  required String message,
  AppFlashType type = AppFlashType.info,
}) {
  final (color, icon) = switch (type) {
    AppFlashType.error => (Colors.red.shade700, Icons.error_outline),
    AppFlashType.success => (Colors.green.shade700, Icons.check_circle_outline),
    AppFlashType.update => (Colors.blue.shade700, Icons.info_outline),
    AppFlashType.warning => (
      Colors.orange.shade800,
      Icons.warning_amber_rounded,
    ),
    AppFlashType.info => (Colors.blueGrey.shade700, Icons.info_outline),
  };

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        backgroundColor: color,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
}
