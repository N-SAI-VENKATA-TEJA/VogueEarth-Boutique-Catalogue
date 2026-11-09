import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import '../screens/product_detail_screen.dart';
import '../theme/app_theme.dart';
import 'sdg_badge.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final bool isHorizontal;

  const ProductCard({
    super.key,
    required this.product,
    this.isHorizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<WishlistProvider, CartProvider>(
      builder: (context, wishlist, cart, _) {
        final isFav = wishlist.isFavorite(product.id);

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductDetailScreen(productId: product.id),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.borderSubtle.withAlpha(160)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image Container with Badges
                Expanded(
                  flex: 11,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(15),
                        ),
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: const Color(0xFFEFECE6),
                          child: Image.network(
                            product.images.first,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return const Center(
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppTheme.primary,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: const Color(0xFFE9E5DD),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.eco_rounded,
                                        size: 36,
                                        color: AppTheme.sage,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        'Conscious Boutique',
                                        style: GoogleFonts.poppins(
                                          fontSize: 10,
                                          color: AppTheme.textMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      // Eco Score Badge (Top-left)
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withAlpha(170),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.eco_rounded,
                                size: 12,
                                color: Color(0xFF68D391),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${product.ecoScore}% Eco',
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Wishlist heart button (Top-right)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Material(
                          color: Colors.white.withAlpha(220),
                          shape: const CircleBorder(),
                          elevation: 2,
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: () {
                              wishlist.toggleFavorite(product);
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: AppTheme.primary,
                                  duration: const Duration(seconds: 1),
                                  content: Text(
                                    isFav
                                        ? 'Removed from your Wishlist'
                                        : 'Added to your Wishlist ❤️',
                                    style: GoogleFonts.poppins(fontSize: 13),
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(7.0),
                              child: Icon(
                                isFav
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                size: 18,
                                color: isFav
                                    ? const Color(0xFFE53E3E)
                                    : AppTheme.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Discount Tag if available
                      if (product.hasDiscount)
                        Positioned(
                          bottom: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.terracotta,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '-${product.discountPercentage}% OFF',
                              style: GoogleFonts.poppins(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Details Area
                Expanded(
                  flex: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Artisan name & cooperative
                            Row(
                              children: [
                                const Icon(
                                  Icons.verified_user_rounded,
                                  size: 11,
                                  color: AppTheme.secondary,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    product.artisan.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: AppTheme.secondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),

                            // Product Title
                            Text(
                              product.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimary,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 5),

                            // SDG tags row
                            Wrap(
                              spacing: 4,
                              runSpacing: 2,
                              children: product.sdgGoals
                                  .take(2)
                                  .map((goal) => SdgBadge(
                                        goalType: goal,
                                        isCompact: true,
                                      ))
                                  .toList(),
                            ),
                          ],
                        ),

                        // Price and Quick Add Button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '\$${product.price.toStringAsFixed(0)}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: AppTheme.primary,
                                      ),
                                    ),
                                    if (product.hasDiscount) ...[
                                      const SizedBox(width: 4),
                                      Text(
                                        '\$${product.originalPrice!.toStringAsFixed(0)}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          color: AppTheme.textMuted,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                Text(
                                  '🌱 ${product.carbonSavedKg}kg CO₂ saved',
                                  style: GoogleFonts.poppins(
                                    fontSize: 9,
                                    color: AppTheme.sage,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),

                            // Mini Add to Cart Button
                            Material(
                              color: AppTheme.primary,
                              borderRadius: BorderRadius.circular(8),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: () {
                                  cart.addItem(
                                    product,
                                    size: product.sizes.isNotEmpty
                                        ? product.sizes.first
                                        : null,
                                    color: product.colors.isNotEmpty
                                        ? product.colors.first
                                        : null,
                                  );
                                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: AppTheme.primary,
                                      duration: const Duration(seconds: 1),
                                      content: Text(
                                        'Added "${product.name}" to cart 🛍️',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(fontSize: 12),
                                      ),
                                    ),
                                  );
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(7.0),
                                  child: Icon(
                                    Icons.add_shopping_cart_rounded,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
