import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../../../shared/widgets/coffee_card.dart';
import '../../tracking/models/tracking_models.dart';
import '../metabolism_estimate.dart';

class MetabolismCard extends StatelessWidget {
  const MetabolismCard({super.key, required this.drinks, required this.now});
  final List<DrinkRecord> drinks;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final palette = AppTheme.paletteOf(context);
    final estimate = MetabolismEstimate(drinks, now);
    final below = estimate.below50At;
    final status = below == null
        ? 'Over 72h estimate'
        : below == now
        ? 'Below 50 mg now'
        : 'Est. below 50 mg ${TimeOfDay.fromDateTime(below).format(context)}';
    return CoffeeCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.nightlight_round, size: 16, color: palette.stateInfo),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Metabolism & Sleep Cutoff',
                  style: TextStyle(
                    color: palette.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                status,
                style: TextStyle(color: palette.stateInfo, fontSize: 10),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Semantics(
            label:
                'Estimated caffeine now ${estimate.remainingAt(now).round()} milligrams. $status. Six hour half-life.',
            child: SizedBox(
              height: 80,
              width: double.infinity,
              child: CustomPaint(
                painter: _MetabolismPainter(estimate, palette),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final label in ['Now', '+3h', '+6h (Half-life)', '+12h'])
                Text(
                  label,
                  style: TextStyle(color: palette.textSubtle, fontSize: 9),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetabolismPainter extends CustomPainter {
  const _MetabolismPainter(this.estimate, this.palette);
  final MetabolismEstimate estimate;
  final CoffeePalette palette;

  @override
  void paint(Canvas canvas, Size size) {
    final maximum = math.max(100.0, estimate.remainingAt(estimate.now) * 1.12);
    double yFor(double mg) =>
        size.height - (mg / maximum).clamp(0, 1) * size.height;
    final linePaint = Paint()
      ..color = palette.brand500
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    final thresholdPaint = Paint()
      ..color = palette.stateDanger
      ..strokeWidth = 1.5;
    final y50 = yFor(50);
    for (var x = 0.0; x < size.width; x += 8) {
      canvas.drawLine(
        Offset(x, y50),
        Offset(math.min(x + 4, size.width), y50),
        thresholdPaint,
      );
    }
    final path = Path();
    for (var step = 0; step <= 48; step++) {
      final x = step / 48 * size.width;
      final at = estimate.now.add(Duration(minutes: step * 15));
      final y = yFor(estimate.remainingAt(at));
      if (step == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, linePaint);
    final label = TextPainter(
      text: TextSpan(
        text: 'Sleep impact limit (50mg)',
        style: TextStyle(color: palette.stateDanger, fontSize: 8),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: size.width);
    label.paint(
      canvas,
      Offset(math.max(0, size.width - label.width), math.max(0, y50 - 14)),
    );
  }

  @override
  bool shouldRepaint(covariant _MetabolismPainter oldDelegate) =>
      oldDelegate.estimate.now != estimate.now ||
      oldDelegate.estimate.drinks != estimate.drinks ||
      oldDelegate.palette != palette;
}
