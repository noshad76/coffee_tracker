import 'package:flutter/material.dart';

import '../../app/theme/app_theme.dart';

class AppToast {
  static void show(
    BuildContext context,
    String message, {
    IconData? icon,
    bool isError = false,
  }) {
    final palette = AppTheme.paletteOf(context);
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        elevation: 8,
        backgroundColor: palette.surfaceRaised,
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 84),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isError
                ? palette.stateDanger.withValues(alpha: 0.6)
                : palette.brand500.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        duration: const Duration(milliseconds: 2200),
        content: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: isError
                    ? palette.stateDanger.withValues(alpha: 0.15)
                    : palette.brand500.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon ?? (isError ? Icons.error_outline : Icons.check),
                size: 16,
                color: isError ? palette.stateDanger : palette.brand300,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: palette.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
