import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../theme/app_theme.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  final VoidCallback onExplore;

  const CartScreen({super.key, required this.onExplore});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _couponController = TextEditingController();
  String? _couponError;

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conscious Cart'),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, _) {
          if (cart.items.isEmpty) {
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
                        Icons.shopping_bag_outlined,
                        size: 56,
                        color: AppTheme.primary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Your Bag is Empty',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Support traditional artisans and sustainable fashion by adding items to your cart.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: widget.onExplore,
                      icon: const Icon(Icons.explore_outlined, color: Colors.white),
                      label: const Text('Start Exploring'),
                    ),
                  ],
                ),
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              // Ecological Impact Banner
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(20, 10, 20, 16),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDF7ED),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFC8E6C9)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.eco_rounded, color: Color(0xFF2E7D32), size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Conscious Impact of This Cart:',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1B5E20),
                              ),
                            ),
                            Text(
                              '🌱 ${cart.totalCarbonSavedKg.toStringAsFixed(1)} kg CO₂ prevented • 💧 ${cart.totalWaterSavedLiters.toStringAsFixed(0)}L water conserved',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: const Color(0xFF2E7D32),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Items List
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = cart.items[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.cardBg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppTheme.borderSubtle),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(6),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                item.product.images.first,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 80,
                                  height: 80,
                                  color: AppTheme.sage.withAlpha(40),
                                  child: const Icon(Icons.shopping_bag, color: AppTheme.primary),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Item Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item.product.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.playfairDisplay(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: AppTheme.textPrimary,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        icon: const Icon(Icons.close, size: 18, color: AppTheme.textMuted),
                                        onPressed: () => cart.removeItem(index),
                                      ),
                                    ],
                                  ),
                                  if (item.selectedSize != null || item.selectedColor != null) ...[
                                    const SizedBox(height: 2),
                                    Text(
                                      '${item.selectedSize ?? ''}${item.selectedSize != null && item.selectedColor != null ? ' • ' : ''}${item.selectedColor ?? ''}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        color: AppTheme.textMuted,
                                      ),
                                    ),
                                  ],
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '\$${item.product.price.toStringAsFixed(0)}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: AppTheme.primary,
                                        ),
                                      ),
                                      // Quantity Controls
                                      Container(
                                        decoration: BoxDecoration(
                                          color: AppTheme.creamBg,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: AppTheme.borderSubtle),
                                        ),
                                        child: Row(
                                          children: [
                                            InkWell(
                                              onTap: () => cart.decrementQuantity(index),
                                              child: const Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                child: Icon(Icons.remove, size: 14),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 6),
                                              child: Text(
                                                '${item.quantity}',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () => cart.incrementQuantity(index),
                                              child: const Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                child: Icon(Icons.add, size: 14),
                                              ),
                                            ),
                                          ],
                                        ),
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
                    childCount: cart.items.length,
                  ),
                ),
              ),

              // Conscious Promo Code Box
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Apply Conscious Coupon',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _couponController,
                              textCapitalization: TextCapitalization.characters,
                              decoration: InputDecoration(
                                hintText: 'Try "ECOSAVER" (15% off)',
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                isDense: true,
                                errorText: _couponError,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                            ),
                            onPressed: () {
                              final success = cart.applyPromoCode(_couponController.text);
                              setState(() {
                                if (success) {
                                  _couponError = null;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Color(0xFF2E7D32),
                                      content: Text('Promo Code ECOSAVER Applied: 15% Off! 🎉'),
                                    ),
                                  );
                                } else {
                                  _couponError = 'Invalid code. Use ECOSAVER';
                                }
                              });
                            },
                            child: const Text('Apply'),
                          ),
                        ],
                      ),
                      if (cart.appliedPromoCode != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle, size: 14, color: Color(0xFF2E7D32)),
                              const SizedBox(width: 6),
                              Text(
                                '${cart.appliedPromoCode} applied (-15%)',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF2E7D32),
                                ),
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: () {
                                  cart.removePromoCode();
                                  _couponController.clear();
                                  setState(() => _couponError = null);
                                },
                                child: Text(
                                  'Remove',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w500,
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

              // Cost Summary
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppTheme.cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.borderSubtle),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Subtotal', style: GoogleFonts.poppins(fontSize: 13, color: AppTheme.textSecondary)),
                          Text('\$${cart.subtotal.toStringAsFixed(2)}',
                              style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      if (cart.discountAmount > 0) ...[
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Discount (15%)',
                                style: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFF2E7D32))),
                            Text('-\$${cart.discountAmount.toStringAsFixed(2)}',
                                style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF2E7D32))),
                          ],
                        ),
                      ],
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Shipping (Carbon Neutral)',
                              style: GoogleFonts.poppins(fontSize: 13, color: AppTheme.textSecondary)),
                          Text(
                            cart.shippingFee == 0 ? 'FREE' : '\$${cart.shippingFee.toStringAsFixed(2)}',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: cart.shippingFee == 0 ? const Color(0xFF2E7D32) : AppTheme.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Artisan Fair-Trade GST (5%)',
                              style: GoogleFonts.poppins(fontSize: 13, color: AppTheme.textSecondary)),
                          Text('\$${cart.estimatedTax.toStringAsFixed(2)}',
                              style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Estimated Total',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          Text(
                            '\$${cart.totalAmount.toStringAsFixed(2)}',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Checkout CTA button
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CheckoutScreen()),
                      );
                    },
                    icon: const Icon(Icons.arrow_forward_rounded, color: Colors.white),
                    label: Text(
                      'Proceed to Checkout • \$${cart.totalAmount.toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
