import 'package:flutter/material.dart';
import '../models/product.dart';

class WishlistProvider with ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => List.unmodifiable(_items);

  int get itemCount => _items.length;

  bool isFavorite(String productId) {
    return _items.any((p) => p.id == productId);
  }

  void toggleFavorite(Product product) {
    final index = _items.indexWhere((p) => p.id == product.id);
    if (index >= 0) {
      _items.removeAt(index);
    } else {
      _items.add(product);
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.removeWhere((p) => p.id == productId);
    notifyListeners();
  }

  void clearWishlist() {
    _items.clear();
    notifyListeners();
  }
}
