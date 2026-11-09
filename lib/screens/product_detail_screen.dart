import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/sdg_impact.dart';
import '../providers/boutique_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import '../theme/app_theme.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _selectedImageIndex = 0;
  String? _selectedSize;
  String? _selectedColor;

  @override
  Widget build(BuildContext context) {
    final boutique = Provider.of<BoutiqueProvider>(context);
    final product = boutique.getProductById(widget.productId);

    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Product Not Found')),
        body: const Center(child: Text('Product could not be located.')),
      );
    }

    _selectedSize ??= product.sizes.isNotEmpty ? product.sizes.first : null;
    _selectedColor ??= product.colors.isNotEmpty ? product.colors.first : null;

    return Consumer2<WishlistProvider, CartProvider>(
      builder: (context, wishlist, cart, _) {
        final isFav = wishlist.isFavorite(product.id);

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              // Custom Silver App Bar with Image Carousel
              SliverAppBar(
                expandedHeight: 380,
                pinned: true,
                backgroundColor: AppTheme.creamBg,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withAlpha(220),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.white.withAlpha(220),
                      child: IconButton(
                        icon: Icon(
                          isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          color: isFav ? const Color(0xFFE53E3E) : AppTheme.textPrimary,
                        ),
                        onPressed: () {
                          wishlist.toggleFavorite(product);
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: AppTheme.primary,
                              duration: const Duration(seconds: 1),
                              content: Text(
                                isFav ? 'Removed from Wishlist' : 'Saved to Wishlist ❤️',
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      PageView.builder(
                        itemCount: product.images.length,
                        onPageChanged: (index) {
                          setState(() {
                            _selectedImageIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Image.network(
                            product.images[index],
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: const Color(0xFFE6E1D8),
                              child: const Icon(Icons.image_not_supported, size: 48),
                            ),
                          );
                        },
                      ),

                      // Image pagination dots
                      if (product.images.length > 1)
                        Positioned(
                          bottom: 16,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              product.images.length,
                              (i) => Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                width: _selectedImageIndex == i ? 20 : 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: _selectedImageIndex == i
                                      ? AppTheme.primary
                                      : Colors.white.withAlpha(180),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                          ),
                        ),

                      // Eco Badge Top Left
                      Positioned(
                        bottom: 16,
                        left: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withAlpha(190),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.eco_rounded, size: 14, color: Color(0xFF68D391)),
                              const SizedBox(width: 5),
                              Text(
                                '${product.ecoScore}% Eco-Sustainability Score',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Product Info & Impact Sections
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Artisan Guild Tag
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppTheme.secondary.withAlpha(25),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppTheme.secondary.withAlpha(60)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.verified, size: 14, color: AppTheme.secondary),
                            const SizedBox(width: 6),
                            Text(
                              'Handcrafted by ${product.artisan.name} • ${product.artisan.village}',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Product Title
                      Text(
                        product.name,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Pricing & Rating
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '\$${product.price.toStringAsFixed(2)}',
                                style: GoogleFonts.poppins(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.primary,
                                ),
                              ),
                              if (product.hasDiscount) ...[
                                const SizedBox(width: 8),
                                Text(
                                  '\$${product.originalPrice!.toStringAsFixed(2)}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    decoration: TextDecoration.lineThrough,
                                    color: AppTheme.textMuted,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppTheme.terracotta,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'SAVE ${product.discountPercentage}%',
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 20),
                              const SizedBox(width: 3),
                              Text(
                                '${product.rating}',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                ' (${product.reviewsCount})',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: AppTheme.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Environmental Savings Bar
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F8F4),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFC6E2D2)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildEcoStat(
                              Icons.cloud_done_outlined,
                              '${product.carbonSavedKg} kg',
                              'Carbon Avoided',
                            ),
                            Container(width: 1, height: 32, color: const Color(0xFFC6E2D2)),
                            _buildEcoStat(
                              Icons.water_drop_outlined,
                              '${product.waterSavedLiters.round()} L',
                              'Water Conserved',
                            ),
                            Container(width: 1, height: 32, color: const Color(0xFFC6E2D2)),
                            _buildEcoStat(
                              Icons.spa_outlined,
                              '100%',
                              'Biodegradable',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // UN Sustainable Development Goals (SDG Alignment)
                      Text(
                        'UN SDG Impact Alignment',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Every item directly advances specific United Nations Sustainable Development Goals:',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Column(
                        children: product.sdgGoals.map((goalType) {
                          final impact = SdgImpact.fromType(goalType);
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.cardBg,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: impact.color.withAlpha(60)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: impact.color.withAlpha(25),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(impact.icon, size: 20, color: impact.color),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            impact.code,
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              color: impact.color,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              impact.title,
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: AppTheme.textPrimary,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        impact.description,
                                        style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          color: AppTheme.textSecondary,
                                          height: 1.35,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),

                      // Artisan Profile & Heritage Story
                      Text(
                        'Meet the Artisan',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.cardBg,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppTheme.borderSubtle),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 26,
                                  backgroundImage: NetworkImage(product.artisan.imageUrl),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.artisan.name,
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        '${product.artisan.craftSpecialty} (${product.artisan.yearsOfExperience} yrs exp)',
                                        style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          color: AppTheme.secondary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        'Cooperative: ${product.artisan.cooperativeName}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          color: AppTheme.textMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '"${product.artisan.story}"',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                                color: AppTheme.textSecondary,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Description
                      Text(
                        'Curator Note',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.description,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                          height: 1.55,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Materials Breakdown
                      Text(
                        'Sustainable Materials',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: product.materials.map((m) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5EFE6),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.check_circle_outline, size: 14, color: AppTheme.primary),
                                const SizedBox(width: 5),
                                Text(
                                  m,
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),

                      // Sizes & Colors if available
                      if (product.sizes.isNotEmpty) ...[
                        Text(
                          'Select Dimension / Size',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: product.sizes.map((size) {
                            final isSel = _selectedSize == size;
                            return ChoiceChip(
                              label: Text(size, style: GoogleFonts.poppins(fontSize: 12)),
                              selected: isSel,
                              selectedColor: AppTheme.primary,
                              labelStyle: TextStyle(color: isSel ? Colors.white : AppTheme.textPrimary),
                              onSelected: (_) => setState(() => _selectedSize = size),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                      ],

                      if (product.colors.isNotEmpty) ...[
                        Text(
                          'Artisan Natural Dye Hue',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: product.colors.map((colorName) {
                            final isSel = _selectedColor == colorName;
                            return ChoiceChip(
                              label: Text(colorName, style: GoogleFonts.poppins(fontSize: 12)),
                              selected: isSel,
                              selectedColor: AppTheme.primary,
                              labelStyle: TextStyle(color: isSel ? Colors.white : AppTheme.textPrimary),
                              onSelected: (_) => setState(() => _selectedColor = colorName),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Bottom Bar with Add to Cart CTA
          bottomNavigationBar: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: AppTheme.cardBg,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(12),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: AppTheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        cart.addItem(
                          product,
                          size: _selectedSize,
                          color: _selectedColor,
                        );
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: AppTheme.primary,
                            content: Row(
                              children: [
                                const Icon(Icons.check_circle_rounded, color: Colors.white),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    '${product.name} added to cart!',
                                    style: GoogleFonts.poppins(fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
                      label: Text(
                        'Add to Cart • \$${product.price.toStringAsFixed(0)}',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEcoStat(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF2E7D32)),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1B5E20),
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 10,
            color: const Color(0xFF4A7C59),
          ),
        ),
      ],
    );
  }
}
