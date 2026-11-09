import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import '../theme/app_theme.dart';
import 'product_detail_screen.dart';

class WishlistScreen extends StatelessWidget {
  final VoidCallback onExplore;

  const WishlistScreen({super.key, required this.onExplore});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Conscious Wishlist'),
      ),
      body: Consumer2<WishlistProvider, CartProvider>(
        builder: (context, wishlist, cart, _) {
          if (wishlist.items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF3ECE1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_border_rounded,
                        size: 56,
                        color: AppTheme.terracotta,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Your Wishlist is Empty',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Save your favourite handloom silks, jewelry, and sustainable boutique pieces here.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: onExplore,
                      icon: const Icon(Icons.explore_outlined, color: Colors.white),
                      label: const Text('Explore Boutique'),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: wishlist.items.length,
            itemBuilder: (context, index) {
              final product = wishlist.items[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.borderSubtle),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(8),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Product Thumbnail
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ProductDetailScreen(productId: product.id),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          product.images.first,
                          width: 85,
                          height: 85,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 85,
                            height: 85,
                            color: AppTheme.sage.withAlpha(40),
                            child: const Icon(Icons.image, color: AppTheme.primary),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),

                    // Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'By ${product.artisan.name} • ${product.artisan.village}',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: AppTheme.secondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '\$${product.price.toStringAsFixed(0)}',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.primary,
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline_rounded,
                                      color: AppTheme.textMuted,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      wishlist.removeItem(product.id);
                                    },
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      minimumSize: Size.zero,
                                    ),
                                    onPressed: () {
                                      cart.addItem(
                                        product,
                                        size: product.sizes.isNotEmpty
                                            ? product.sizes.first
                                            : null,
                                        color: product.colors.isNotEmpty
                                            ? product.colors.first
                                            : null,
                                      );
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          behavior: SnackBarBehavior.floating,
                                          backgroundColor: AppTheme.primary,
                                          duration: const Duration(seconds: 1),
                                          content: Text('Added to cart! 🛍️'),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Add to Cart',
                                      style: GoogleFonts.poppins(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
