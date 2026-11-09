import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];
  String? _appliedPromoCode;
  double _discountRate = 0.0;

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  String? get appliedPromoCode => _appliedPromoCode;
  double get discountRate => _discountRate;

  double get subtotal =>
      _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get discountAmount => subtotal * _discountRate;

  double get shippingFee {
    if (subtotal == 0) return 0.0;
    return subtotal >= 150.0 ? 0.0 : 12.0; // Free shipping above $150
  }

  double get estimatedTax => (subtotal - discountAmount) * 0.05; // 5% fair-trade GST

  double get totalAmount {
    if (subtotal == 0) return 0.0;
    return (subtotal - discountAmount) + shippingFee + estimatedTax;
  }

  double get totalCarbonSavedKg =>
      _items.fold(0.0, (sum, item) => sum + item.totalCarbonSaved);

  double get totalWaterSavedLiters =>
      _items.fold(0.0, (sum, item) => sum + item.totalWaterSaved);

  void addItem(Product product, {String? size, String? color, int quantity = 1}) {
    final existingIndex = _items.indexWhere((item) =>
        item.product.id == product.id &&
        item.selectedSize == size &&
        item.selectedColor == color);

    if (existingIndex >= 0) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(
        CartItem(
          product: product,
          quantity: quantity,
          selectedSize: size,
          selectedColor: color,
        ),
      );
    }
    notifyListeners();
  }

  void incrementQuantity(int index) {
    if (index >= 0 && index < _items.length) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  void decrementQuantity(int index) {
    if (index >= 0 && index < _items.length) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      notifyListeners();
    }
  }

  bool applyPromoCode(String code) {
    final trimmed = code.trim().toUpperCase();
    if (trimmed == 'ECOSAVER' || trimmed == 'SDG2026') {
      _appliedPromoCode = trimmed;
      _discountRate = 0.15; // 15% conscious shopping discount
      notifyListeners();
      return true;
    }
    return false;
  }

  void removePromoCode() {
    _appliedPromoCode = null;
    _discountRate = 0.0;
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _appliedPromoCode = null;
    _discountRate = 0.0;
    notifyListeners();
  }
}
