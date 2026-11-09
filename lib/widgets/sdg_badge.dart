import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/sdg_impact.dart';

class SdgBadge extends StatelessWidget {
  final SdgGoalType goalType;
  final bool isCompact;

  const SdgBadge({
    super.key,
    required this.goalType,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final impact = SdgImpact.fromType(goalType);

    if (isCompact) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: BoxDecoration(
          color: impact.color.withAlpha(35),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: impact.color.withAlpha(90), width: 0.8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(impact.icon, size: 11, color: impact.color),
            const SizedBox(width: 3),
            Text(
              impact.code,
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: impact.color,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: impact.color.withAlpha(25),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: impact.color.withAlpha(80), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(impact.icon, size: 14, color: impact.color),
          const SizedBox(width: 6),
          Text(
            '${impact.code}: ${impact.badgeText}',
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: impact.color,
            ),
          ),
        ],
      ),
    );
  }
}
