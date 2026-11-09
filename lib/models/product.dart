import 'artisan.dart';
import 'sdg_impact.dart';

class Product {
  final String id;
  final String name;
  final String categoryId;
  final double price;
  final double? originalPrice;
  final String description;
  final List<String> images;
  final Artisan artisan;
  final List<String> materials;
  final int ecoScore; // 1 to 100
  final List<SdgGoalType> sdgGoals;
  final List<String> sizes;
  final List<String> colors;
  final double rating;
  final int reviewsCount;
  final bool isTrending;
  final bool isFeatured;
  final double carbonSavedKg;
  final double waterSavedLiters;

  const Product({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.price,
    this.originalPrice,
    required this.description,
    required this.images,
    required this.artisan,
    required this.materials,
    required this.ecoScore,
    required this.sdgGoals,
    this.sizes = const [],
    this.colors = const [],
    this.rating = 4.8,
    this.reviewsCount = 42,
    this.isTrending = false,
    this.isFeatured = false,
    required this.carbonSavedKg,
    required this.waterSavedLiters,
  });

  bool get hasDiscount => originalPrice != null && originalPrice! > price;

  int get discountPercentage {
    if (!hasDiscount) return 0;
    return (((originalPrice! - price) / originalPrice!) * 100).round();
  }
}
