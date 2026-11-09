import 'package:flutter/material.dart';

enum SdgGoalType {
  sdg12, // Responsible Consumption & Production
  sdg8,  // Decent Work & Economic Growth
  sdg5,  // Gender Equality
}

class SdgImpact {
  final SdgGoalType goalType;
  final String title;
  final String code;
  final String badgeText;
  final String description;
  final IconData icon;
  final Color color;

  const SdgImpact({
    required this.goalType,
    required this.title,
    required this.code,
    required this.badgeText,
    required this.description,
    required this.icon,
    required this.color,
  });

  static const SdgImpact sdg12 = SdgImpact(
    goalType: SdgGoalType.sdg12,
    code: 'SDG 12',
    title: 'Responsible Consumption & Production',
    badgeText: 'Eco-Friendly & Zero-Waste',
    description: 'Promotes sustainable fabrics, organic natural dyes, upcycled raw materials, and plastic-free packaging to prevent landfill waste.',
    icon: Icons.recycling_rounded,
    color: Color(0xFFCF8D2A),
  );

  static const SdgImpact sdg8 = SdgImpact(
    goalType: SdgGoalType.sdg8,
    code: 'SDG 8',
    title: 'Decent Work & Economic Growth',
    badgeText: 'Fair Trade Artisan Wages',
    description: 'Guarantees fair-trade compensation, safe handloom working environments, and direct-to-consumer revenue share without exploitative middlemen.',
    icon: Icons.work_outline_rounded,
    color: Color(0xFFA21942),
  );

  static const SdgImpact sdg5 = SdgImpact(
    goalType: SdgGoalType.sdg5,
    code: 'SDG 5',
    title: 'Gender Equality',
    badgeText: 'Women-Led Craft Guilds',
    description: 'Over 85% of our boutique craft cooperatives are founded and operated by rural women artisans, ensuring economic independence and leadership.',
    icon: Icons.diversity_1_rounded,
    color: Color(0xFFFF3A21),
  );

  static SdgImpact fromType(SdgGoalType type) {
    switch (type) {
      case SdgGoalType.sdg12:
        return sdg12;
      case SdgGoalType.sdg8:
        return sdg8;
      case SdgGoalType.sdg5:
        return sdg5;
    }
  }
}
