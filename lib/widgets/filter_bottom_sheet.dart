import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/sdg_impact.dart';
import '../providers/boutique_provider.dart';
import '../theme/app_theme.dart';
import 'sdg_badge.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late RangeValues _currentRange;
  late int _ecoScore;
  SdgGoalType? _sdgGoal;
  late ProductSortOption _sortOption;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<BoutiqueProvider>(context, listen: false);
    _currentRange = provider.priceRange;
    _ecoScore = provider.minEcoScore;
    _sdgGoal = provider.selectedSdgGoal;
    _sortOption = provider.sortOption;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: const BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter & Sort Curations',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(height: 24),

            // Sort Options
            Text(
              'Sort By',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildSortChip(ProductSortOption.featured, 'Featured'),
                _buildSortChip(ProductSortOption.priceLowToHigh, 'Price: Low → High'),
                _buildSortChip(ProductSortOption.priceHighToLow, 'Price: High → Low'),
                _buildSortChip(ProductSortOption.rating, 'Top Rated'),
                _buildSortChip(ProductSortOption.ecoScore, 'Highest Eco-Score'),
              ],
            ),
            const SizedBox(height: 20),

            // Price Range Slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Price Range',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '\$${_currentRange.start.round()} - \$${_currentRange.end.round()}',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
            RangeSlider(
              values: _currentRange,
              min: 0,
              max: 300,
              divisions: 30,
              activeColor: AppTheme.primary,
              inactiveColor: AppTheme.borderSubtle,
              onChanged: (values) {
                setState(() {
                  _currentRange = values;
                });
              },
            ),
            const SizedBox(height: 16),

            // Minimum Eco-Score Slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Minimum Eco-Score',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withAlpha(20),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$_ecoScore%+',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            Slider(
              value: _ecoScore.toDouble(),
              min: 50,
              max: 95,
              divisions: 9,
              activeColor: const Color(0xFF38A169),
              inactiveColor: AppTheme.borderSubtle,
              onChanged: (val) {
                setState(() {
                  _ecoScore = val.round();
                });
              },
            ),
            const SizedBox(height: 16),

            // UN SDG Focus Filter
            Text(
              'Filter by UN Sustainable Development Goal',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(
                  label: Text('All Goals', style: GoogleFonts.poppins(fontSize: 12)),
                  selected: _sdgGoal == null,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _sdgGoal = null);
                    }
                  },
                ),
                ChoiceChip(
                  label: const SdgBadge(goalType: SdgGoalType.sdg12, isCompact: true),
                  selected: _sdgGoal == SdgGoalType.sdg12,
                  onSelected: (selected) {
                    setState(() => _sdgGoal = selected ? SdgGoalType.sdg12 : null);
                  },
                ),
                ChoiceChip(
                  label: const SdgBadge(goalType: SdgGoalType.sdg8, isCompact: true),
                  selected: _sdgGoal == SdgGoalType.sdg8,
                  onSelected: (selected) {
                    setState(() => _sdgGoal = selected ? SdgGoalType.sdg8 : null);
                  },
                ),
                ChoiceChip(
                  label: const SdgBadge(goalType: SdgGoalType.sdg5, isCompact: true),
                  selected: _sdgGoal == SdgGoalType.sdg5,
                  onSelected: (selected) {
                    setState(() => _sdgGoal = selected ? SdgGoalType.sdg5 : null);
                  },
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      final provider =
                          Provider.of<BoutiqueProvider>(context, listen: false);
                      provider.resetFilters();
                      Navigator.pop(context);
                    },
                    child: const Text('Reset All'),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final provider =
                          Provider.of<BoutiqueProvider>(context, listen: false);
                      provider.setPriceRange(_currentRange);
                      provider.setMinEcoScore(_ecoScore);
                      provider.setSdgGoal(_sdgGoal);
                      provider.setSortOption(_sortOption);
                      Navigator.pop(context);
                    },
                    child: const Text('Apply Filters'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortChip(ProductSortOption option, String title) {
    final isSelected = _sortOption == option;
    return ChoiceChip(
      label: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          color: isSelected ? Colors.white : AppTheme.textPrimary,
        ),
      ),
      selected: isSelected,
      selectedColor: AppTheme.primary,
      backgroundColor: AppTheme.creamBg,
      onSelected: (val) {
        if (val) {
          setState(() => _sortOption = option);
        }
      },
    );
  }
}
