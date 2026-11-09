import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../theme/app_theme.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Sai Verma');
  final _phoneController = TextEditingController(text: '+91 98765 43210');
  final _addressController =
      TextEditingController(text: '42, Heritage Enclave, Green Meadows');
  final _cityController = TextEditingController(text: 'Bengaluru');
  final _zipController = TextEditingController(text: '560001');

  bool _ecoPackaging = true;
  bool _artisanTip = true;
  String _selectedPaymentMethod = 'UPI / NetBanking';

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  void _completeOrder(CartProvider cart) {
    if (!_formKey.currentState!.validate()) return;

    final totalCarbonSaved = cart.totalCarbonSavedKg;
    final totalWaterSaved = cart.totalWaterSavedLiters;
    final totalAmount = cart.totalAmount + (_artisanTip ? 5.0 : 0.0);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFE8F5E9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                size: 52,
                color: Color(0xFF2E7D32),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Order Placed Successfully!',
              textAlign: TextAlign.center,
              style: GoogleFonts.playfairDisplay(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Order ID: #VE-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.secondary,
              ),
            ),
            const SizedBox(height: 14),

            // SDG Impact Certificate Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F8F4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFC6E2D2)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.workspace_premium_rounded,
                          color: Color(0xFF2E7D32), size: 18),
                      const SizedBox(width: 6),
                      Text(
                        'Conscious Impact Certificate',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1B5E20),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Through this order, you supported local rural women weavers and prevented ${totalCarbonSaved.toStringAsFixed(1)} kg CO₂ from entering the atmosphere (SDG 12 & 8)!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: const Color(0xFF2E7D32),
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '💧 ${totalWaterSaved.toStringAsFixed(0)} Liters water conserved',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1B5E20),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Total Charged: \$${totalAmount.toStringAsFixed(2)}',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  cart.clearCart();
                  Navigator.of(ctx).pop(); // dismiss dialog
                  Navigator.of(context).pop(); // exit checkout
                },
                child: const Text('Return to Boutique'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Conscious Checkout'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Shipping Address
              Text(
                'Delivery Information',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Recipient Full Name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Please enter recipient name' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Please enter contact phone' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Street Address',
                  prefixIcon: Icon(Icons.home_outlined),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Please enter shipping address' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _cityController,
                      decoration: const InputDecoration(
                        labelText: 'City',
                        prefixIcon: Icon(Icons.location_city_outlined),
                      ),
                      validator: (val) => val == null || val.isEmpty ? 'Enter city' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _zipController,
                      decoration: const InputDecoration(
                        labelText: 'Postal Code',
                        prefixIcon: Icon(Icons.pin_drop_outlined),
                      ),
                      validator: (val) => val == null || val.isEmpty ? 'Enter PIN/ZIP' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Sustainable Packaging & Social Impact
              Text(
                'Ethical Commitments (SDG 12 & 8)',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.cardBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.borderSubtle),
                ),
                child: Column(
                  children: [
                    SwitchListTile(
                      value: _ecoPackaging,
                      activeTrackColor: AppTheme.primary.withAlpha(180),
                      title: Text(
                        '100% Plastic-Free Compostable Box',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        'Zero landfill waste, cornstarch tape & handmade seed paper note.',
                        style: GoogleFonts.poppins(fontSize: 11, color: AppTheme.textSecondary),
                      ),
                      onChanged: (val) => setState(() => _ecoPackaging = val),
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      value: _artisanTip,
                      activeTrackColor: AppTheme.primary.withAlpha(180),
                      title: Text(
                        'Add \$5.00 Direct Artisan Welfare Contribution',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        '100% donated to rural women handloom weavers health fund (SDG 5).',
                        style: GoogleFonts.poppins(fontSize: 11, color: AppTheme.textSecondary),
                      ),
                      onChanged: (val) => setState(() => _artisanTip = val),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Payment Method
              Text(
                'Payment Method',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.cardBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.borderSubtle),
                ),
                child: RadioGroup<String>(
                  groupValue: _selectedPaymentMethod,
                  onChanged: (String? val) {
                    if (val != null) setState(() => _selectedPaymentMethod = val);
                  },
                  child: Column(
                    children: [
                      RadioListTile<String>(
                        value: 'UPI / NetBanking',
                        title: Text('Instant UPI / NetBanking / GPay',
                            style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500)),
                        subtitle: Text('Fast & zero carbon footprint digital payment',
                            style: GoogleFonts.poppins(fontSize: 11, color: AppTheme.textMuted)),
                      ),
                      const Divider(height: 1),
                      RadioListTile<String>(
                        value: 'Credit / Debit Card',
                        title: Text('Credit / Debit Card (Visa, MasterCard)',
                            style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500)),
                      ),
                      const Divider(height: 1),
                      RadioListTile<String>(
                        value: 'Cash on Delivery',
                        title: Text('Cash / Pay on Delivery',
                            style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Final Bill Summary
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F6F0),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE8E0D2)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Subtotal', style: GoogleFonts.poppins(fontSize: 13)),
                        Text('\$${cart.subtotal.toStringAsFixed(2)}',
                            style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    if (cart.discountAmount > 0) ...[
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Conscious Discount (${cart.appliedPromoCode})',
                              style: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFF2E7D32))),
                          Text('-\$${cart.discountAmount.toStringAsFixed(2)}',
                              style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF2E7D32))),
                        ],
                      ),
                    ],
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Eco Carbon-Neutral Shipping', style: GoogleFonts.poppins(fontSize: 13)),
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
                    if (_artisanTip) ...[
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Artisan Guild Contribution',
                              style: GoogleFonts.poppins(fontSize: 13, color: AppTheme.secondary)),
                          Text('+\$5.00',
                              style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.secondary)),
                        ],
                      ),
                    ],
                    const Divider(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Payable',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primary,
                          ),
                        ),
                        Text(
                          '\$${(cart.totalAmount + (_artisanTip ? 5.0 : 0.0)).toStringAsFixed(2)}',
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
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () => _completeOrder(cart),
                  icon: const Icon(Icons.lock_outline_rounded, color: Colors.white),
                  label: Text(
                    'Confirm & Pay \$${(cart.totalAmount + (_artisanTip ? 5.0 : 0.0)).toStringAsFixed(2)}',
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
  }
}
