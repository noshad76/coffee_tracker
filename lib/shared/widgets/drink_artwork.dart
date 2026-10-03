import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DrinkArtwork extends StatelessWidget {
  const DrinkArtwork({super.key, required this.id, this.size = 40});
  final String id;
  final double size;

  @override
  Widget build(BuildContext context) {
    final assetId = switch (id) {
      'cold_brew' => 'coldbrew',
      'matcha_latte' => 'matcha',
      'black_tea' => 'tea',
      _ => id,
    };
    return SvgPicture.asset(
      'assets/drinks/$assetId.svg',
      width: size,
      height: size,
      excludeFromSemantics: true,
    );
  }
}
