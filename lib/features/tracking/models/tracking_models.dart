import 'package:flutter/foundation.dart';

@immutable
class DrinkRecord {
  const DrinkRecord({
    required this.id,
    required this.name,
    required this.caffeineMg,
    required this.volumeMl,
    required this.consumedAtUtc,
    required this.priceCents,
    required this.temperature,
    required this.location,
    required this.cupStyle,
    this.cafeName,
    this.note,
  });

  final int id;
  final String name;
  final int caffeineMg;
  final int volumeMl;
  final DateTime consumedAtUtc;
  final int priceCents;
  final String temperature;
  final String location;
  final String cupStyle;
  final String? cafeName;
  final String? note;

  DateTime get localTime => consumedAtUtc.toLocal();
}

@immutable
class FeatureIdea {
  const FeatureIdea({
    required this.id,
    required this.title,
    required this.description,
    required this.anonymous,
    required this.voted,
    required this.createdAtUtc,
  });

  final int id;
  final String title;
  final String description;
  final bool anonymous;
  final bool voted;
  final DateTime createdAtUtc;
}

@immutable
class TrackingSnapshot {
  const TrackingSnapshot({required this.drinks, required this.ideas});
  final List<DrinkRecord> drinks;
  final List<FeatureIdea> ideas;
}

@immutable
class DrinkDraft {
  const DrinkDraft({
    required this.name,
    required this.caffeineMg,
    required this.volumeMl,
    required this.consumedAtUtc,
    required this.priceCents,
    required this.temperature,
    required this.location,
    required this.cupStyle,
    this.cafeName,
    this.note,
  });
  final String name;
  final int caffeineMg;
  final int volumeMl;
  final DateTime consumedAtUtc;
  final int priceCents;
  final String temperature;
  final String location;
  final String cupStyle;
  final String? cafeName;
  final String? note;
}
