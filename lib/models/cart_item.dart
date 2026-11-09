import 'product.dart';

class CartItem {
  final Product product;
  int quantity;
  final String? selectedSize;
  final String? selectedColor;

  CartItem({
    required this.product,
    this.quantity = 1,
    this.selectedSize,
    this.selectedColor,
  });

  double get totalPrice => product.price * quantity;
  double get totalCarbonSaved => product.carbonSavedKg * quantity;
  double get totalWaterSaved => product.waterSavedLiters * quantity;
}
