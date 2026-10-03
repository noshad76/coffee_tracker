import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DrinkArtwork extends StatelessWidget {
  const DrinkArtwork({super.key, required this.id, this.size = 40});
  final String id;
  final double size;

  @override
  Widget build(BuildContext context) {
    String cleanId = id;
    if (cleanId.startsWith('custom:')) {
      final parts = cleanId.split(':');
      cleanId = parts.length >= 5 ? parts[4] : 'mug';
    }
    final assetId = switch (cleanId) {
      'cold_brew' => 'coldbrew',
      'matcha_latte' => 'matcha',
      'black_tea' => 'tea',
      _ => cleanId,
    };
    return SvgPicture.asset(
      'assets/drinks/$assetId.svg',
      width: size,
      height: size,
      excludeFromSemantics: true,
    );
  }
}
