import 'package:flutter/material.dart';
import '../models/artisan.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../models/sdg_impact.dart';
import '../services/boutique_data_service.dart';

enum ProductSortOption {
  featured,
  priceLowToHigh,
  priceHighToLow,
  rating,
  ecoScore,
}

class BoutiqueProvider with ChangeNotifier {
  final List<Product> _allProducts = BoutiqueDataService.products;
  final List<Category> _categories = BoutiqueDataService.categories;
  final List<Artisan> _artisans = BoutiqueDataService.artisans;

  String _selectedCategoryId = 'cat_all';
  String _searchQuery = '';
  RangeValues _priceRange = const RangeValues(0, 300);
  int _minEcoScore = 80;
  SdgGoalType? _selectedSdgGoal;
  ProductSortOption _sortOption = ProductSortOption.featured;

  List<Product> get allProducts => _allProducts;
  List<Category> get categories => _categories;
  List<Artisan> get artisans => _artisans;
  String get selectedCategoryId => _selectedCategoryId;
  String get searchQuery => _searchQuery;
  RangeValues get priceRange => _priceRange;
  int get minEcoScore => _minEcoScore;
  SdgGoalType? get selectedSdgGoal => _selectedSdgGoal;
  ProductSortOption get sortOption => _sortOption;

  List<Product> get featuredProducts =>
      _allProducts.where((p) => p.isFeatured).toList();

  List<Product> get trendingProducts =>
      _allProducts.where((p) => p.isTrending).toList();

  List<Product> get filteredProducts {
    List<Product> list = _allProducts.where((product) {
      // Category filter
      if (_selectedCategoryId != 'cat_all' &&
          product.categoryId != _selectedCategoryId) {
        return false;
      }

      // Search query filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchesName = product.name.toLowerCase().contains(query);
        final matchesDesc = product.description.toLowerCase().contains(query);
        final matchesArtisan =
            product.artisan.name.toLowerCase().contains(query);
        final matchesMaterials =
            product.materials.any((m) => m.toLowerCase().contains(query));
        if (!matchesName && !matchesDesc && !matchesArtisan && !matchesMaterials) {
          return false;
        }
      }

      // Price range filter
      if (product.price < _priceRange.start || product.price > _priceRange.end) {
        return false;
      }

      // Eco score filter
      if (product.ecoScore < _minEcoScore) {
        return false;
      }

      // SDG filter
      if (_selectedSdgGoal != null &&
          !product.sdgGoals.contains(_selectedSdgGoal)) {
        return false;
      }

      return true;
    }).toList();

    // Sorting
    switch (_sortOption) {
      case ProductSortOption.priceLowToHigh:
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case ProductSortOption.priceHighToLow:
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      case ProductSortOption.rating:
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case ProductSortOption.ecoScore:
        list.sort((a, b) => b.ecoScore.compareTo(a.ecoScore));
        break;
      case ProductSortOption.featured:
        // Keep initial curated order
        break;
    }

    return list;
  }

  void selectCategory(String categoryId) {
    _selectedCategoryId = categoryId;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setPriceRange(RangeValues values) {
    _priceRange = values;
    notifyListeners();
  }

  void setMinEcoScore(int score) {
    _minEcoScore = score;
    notifyListeners();
  }

  void setSdgGoal(SdgGoalType? goal) {
    _selectedSdgGoal = goal;
    notifyListeners();
  }

  void setSortOption(ProductSortOption option) {
    _sortOption = option;
    notifyListeners();
  }

  void resetFilters() {
    _selectedCategoryId = 'cat_all';
    _searchQuery = '';
    _priceRange = const RangeValues(0, 300);
    _minEcoScore = 80;
    _selectedSdgGoal = null;
    _sortOption = ProductSortOption.featured;
    notifyListeners();
  }

  Product? getProductById(String id) {
    try {
      return _allProducts.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}
