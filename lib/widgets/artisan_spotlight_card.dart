import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/artisan.dart';
import '../theme/app_theme.dart';

class ArtisanSpotlightCard extends StatelessWidget {
  final Artisan artisan;

  const ArtisanSpotlightCard({
    super.key,
    required this.artisan,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 290,
      margin: const EdgeInsets.only(right: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderSubtle),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.network(
                  artisan.imageUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 50,
                    height: 50,
                    color: AppTheme.sage.withAlpha(50),
                    child: const Icon(Icons.person, color: AppTheme.primary),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            artisan.name,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (artisan.isWomenLed) ...[
                          const SizedBox(width: 4),
                          const Tooltip(
                            message: 'Women Artisan Led Cooperative (SDG 5)',
                            child: Icon(
                              Icons.female_rounded,
                              size: 16,
                              color: Color(0xFFFF3A21),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      artisan.craftSpecialty,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: AppTheme.secondary,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '📍 ${artisan.village}, ${artisan.region}',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Text(
              '"${artisan.story}"',
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontStyle: FontStyle.italic,
                color: AppTheme.textSecondary,
                height: 1.35,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.primary.withAlpha(15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.verified, size: 12, color: AppTheme.primary),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    artisan.cooperativeName,
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
