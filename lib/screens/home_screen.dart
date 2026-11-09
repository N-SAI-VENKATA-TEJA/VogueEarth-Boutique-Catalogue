import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/boutique_provider.dart';
import '../providers/cart_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/artisan_spotlight_card.dart';
import '../widgets/category_item.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatelessWidget {
  final Function(int) onTabChange;

  const HomeScreen({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    final boutique = Provider.of<BoutiqueProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Top Boutique Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.spa_rounded,
                              size: 16,
                              color: AppTheme.secondary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'ETHICAL & SUSTAINABLE BOUTIQUE',
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                                color: AppTheme.secondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'VogueEarth',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primary,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                    Consumer<CartProvider>(
                      builder: (_, cart, __) => Stack(
                        clipBehavior: Clip.none,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.shopping_bag_outlined,
                                size: 26, color: AppTheme.primary),
                            onPressed: () => onTabChange(3), // Navigate to Cart
                          ),
                          if (cart.itemCount > 0)
                            Positioned(
                              top: 6,
                              right: 6,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: AppTheme.terracotta,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 18,
                                  minHeight: 18,
                                ),
                                child: Text(
                                  '${cart.itemCount}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Search Bar & Filter trigger
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppTheme.cardBg,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppTheme.borderSubtle),
                        ),
                        child: TextField(
                          onChanged: (val) => boutique.setSearchQuery(val),
                          decoration: InputDecoration(
                            hintText: 'Search silk, khadi, jewelry, artisan...',
                            prefixIcon: const Icon(Icons.search_rounded,
                                color: AppTheme.primary),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            suffixIcon: boutique.searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear, size: 18),
                                    onPressed: () =>
                                        boutique.setSearchQuery(''),
                                  )
                                : null,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Material(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(14),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => const FilterBottomSheet(),
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(14.0),
                          child: Icon(Icons.tune_rounded, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // SDG Impact Hero Banner
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.fromLTRB(20, 14, 20, 16),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1B3B2B), Color(0xFF2C5E45)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withAlpha(60),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.secondaryLight.withAlpha(50),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'UN SDG 12 • 8 • 5 COMPLIANT',
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.secondaryLight,
                            ),
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.recycling_rounded,
                            color: AppTheme.secondaryLight, size: 20),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Luxury That Cares for Earth & Artisans',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '100% slow fashion, plastic-free packaging & direct fair-trade wages for women handloom weavers.',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.white.withAlpha(220),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '🌱 1,845 kg CO₂ saved to date',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF81E6D9),
                          ),
                        ),
                        InkWell(
                          onTap: () => onTabChange(4), // SDG dashboard
                          child: Row(
                            children: [
                              Text(
                                'View Impact',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.secondaryLight,
                                ),
                              ),
                              const Icon(Icons.chevron_right,
                                  size: 16, color: AppTheme.secondaryLight),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Horizontal Categories Selector
            SliverToBoxAdapter(
              child: SizedBox(
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
                      onTap: () {
                        boutique.selectCategory(cat.id);
                        onTabChange(1); // Jump to catalogue
                      },
                    );
                  },
                ),
              ),
            ),

            // Section 1: Curated Featured Collections
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Featured Sustainable Picks',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    InkWell(
                      onTap: () => onTabChange(1),
                      child: Text(
                        'See All',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Featured Horizontal Carousel
            SliverToBoxAdapter(
              child: SizedBox(
                height: 290,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: boutique.featuredProducts.length,
                  itemBuilder: (context, index) {
                    final product = boutique.featuredProducts[index];
                    return Container(
                      width: 200,
                      margin: const EdgeInsets.only(right: 14),
                      child: ProductCard(product: product),
                    );
                  },
                ),
              ),
            ),

            // Section 2: Rural Artisan Cooperatives Spotlight
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Artisans Behind the Craft',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        Text(
                          'SDG 8 (Decent Work) & SDG 5 (Women Empowerment)',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Artisan horizontal list
            SliverToBoxAdapter(
              child: SizedBox(
                height: 180,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: boutique.artisans.length,
                  itemBuilder: (context, index) {
                    return ArtisanSpotlightCard(artisan: boutique.artisans[index]);
                  },
                ),
              ),
            ),

            // Section 3: Trending Sustainable Handcrafted Curations
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 26, 20, 14),
                child: Text(
                  'Conscious Boutique Showcase',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
            ),

            // 2-column Grid of products
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.62,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = boutique.allProducts[index];
                    return ProductCard(product: product);
                  },
                  childCount: boutique.allProducts.length,
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 30),
            ),
          ],
        ),
      ),
    );
  }
}
