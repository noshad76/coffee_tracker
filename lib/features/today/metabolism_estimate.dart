import 'dart:math' as math;

import '../tracking/models/tracking_models.dart';

/// Display estimate matching the prototype's 6-hour half-life and 50 mg line.
/// This is a simple visualization, not an individual sleep prediction.
class MetabolismEstimate {
  const MetabolismEstimate(this.drinks, this.now);
  final List<DrinkRecord> drinks;
  final DateTime now;

  double remainingAt(DateTime at) {
    var total = 0.0;
    for (final drink in drinks) {
      final elapsedHours = at.difference(drink.localTime).inMinutes / 60;
      if (elapsedHours >= 0) {
        total += drink.caffeineMg * math.pow(0.5, elapsedHours / 6);
      }
    }
    return total;
  }

  DateTime? get below50At {
    if (remainingAt(now) <= 50) return now;
    for (var minutes = 15; minutes <= 72 * 60; minutes += 15) {
      final at = now.add(Duration(minutes: minutes));
      if (remainingAt(at) <= 50) return at;
    }
    return null;
  }
}
