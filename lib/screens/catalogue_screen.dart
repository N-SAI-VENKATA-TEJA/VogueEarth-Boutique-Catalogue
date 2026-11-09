import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/boutique_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/category_item.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/product_card.dart';

class CatalogueScreen extends StatelessWidget {
  const CatalogueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final boutique = Provider.of<BoutiqueProvider>(context);
    final products = boutique.filteredProducts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Boutique Catalogue'),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const FilterBottomSheet(),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.cardBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.borderSubtle),
              ),
              child: TextField(
                onChanged: (val) => boutique.setSearchQuery(val),
                decoration: InputDecoration(
                  hintText: 'Search handloom, organic cotton, jewelry...',
                  prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.primary),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  suffixIcon: boutique.searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () => boutique.setSearchQuery(''),
                        )
                      : null,
                ),
              ),
            ),
          ),

          // Categories Horizontal Selector
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: boutique.categories.length,
              itemBuilder: (context, index) {
                final cat = boutique.categories[index];
                return CategoryItem(
                  category: cat,
                  isSelected: boutique.selectedCategoryId == cat.id,
                  onTap: () => boutique.selectCategory(cat.id),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // Result Summary & Sort
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Showing ${products.length} conscious pieces',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textSecondary,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => const FilterBottomSheet(),
                    );
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.sort_rounded, size: 16, color: AppTheme.primary),
                      const SizedBox(width: 4),
                      Text(
                        'Filter / Sort',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Main Catalogue Grid
          Expanded(
            child: products.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.search_off_rounded,
                              size: 64, color: AppTheme.sage),
                          const SizedBox(height: 16),
                          Text(
                            'No Boutique Pieces Found',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try loosening your search terms or resetting filters.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () => boutique.resetFilters(),
                            child: const Text('Reset All Filters'),
                          ),
                        ],
                      ),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.62,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return ProductCard(product: products[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
