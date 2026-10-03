import 'dart:io';
import 'package:flutter/material.dart';

import '../../app/theme/app_theme.dart';
import '../../features/tracking/models/tracking_models.dart';

class PhotoDetailDialog extends StatelessWidget {
  const PhotoDetailDialog({super.key, required this.drink});

  final DrinkRecord drink;

  static void show(BuildContext context, DrinkRecord drink) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.85),
      builder: (context) => PhotoDetailDialog(drink: drink),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppTheme.paletteOf(context);
    final photoFile = drink.photoPath != null ? File(drink.photoPath!) : null;
    final fileExists = photoFile != null && photoFile.existsSync();

    return Dialog(
      backgroundColor: palette.surface,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.largeCard),
        side: BorderSide(color: palette.stone800),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadii.largeCard),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Photo Header / Image
              Stack(
                children: [
                  if (fileExists)
                    AspectRatio(
                      aspectRatio: 1,
                      child: Image.file(
                        photoFile,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          color: palette.surfaceRaised,
                          child: Icon(
                            Icons.broken_image_rounded,
                            size: 48,
                            color: palette.textMuted,
                          ),
                        ),
                      ),
                    )
                  else
                    Container(
                      height: 200,
                      color: palette.surfaceRaised,
                      child: Center(
                        child: Icon(
                          Icons.local_cafe_rounded,
                          size: 64,
                          color: palette.brand400,
                        ),
                      ),
                    ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Content details
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            drink.name,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: palette.brand500.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(
                              AppRadii.control,
                            ),
                          ),
                          child: Text(
                            '${drink.caffeineMg} mg',
                            style: TextStyle(
                              color: palette.brand300,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${TimeOfDay.fromDateTime(drink.localTime).format(context)} • ${drink.consumedAtUtc.toLocal().month}/${drink.consumedAtUtc.toLocal().day}/${drink.consumedAtUtc.toLocal().year} • ${drink.location == 'cafe' ? (drink.cafeName ?? 'At Cafe') : 'Home Brew'}',
                      style: TextStyle(color: palette.textMuted, fontSize: 12),
                    ),
                    if (drink.note != null && drink.note!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: palette.surfaceRaised,
                          borderRadius: BorderRadius.circular(AppRadii.control),
                          border: Border.all(color: palette.stone800),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.format_quote_rounded,
                              size: 16,
                              color: palette.brand400,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                drink.note!,
                                style: TextStyle(
                                  color: palette.textPrimary,
                                  fontSize: 13,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
