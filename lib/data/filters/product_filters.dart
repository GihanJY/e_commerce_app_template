import 'package:flutter/material.dart';

class ProductFilters {
  final RangeValues priceRange;
  final List<String> selectedBrands;
  final double minRating;

  const ProductFilters({
    this.priceRange = const RangeValues(0, 2000),
    this.selectedBrands = const [],
    this.minRating = 0,
  });

    bool get isActive =>
      priceRange.start > 0 ||
      priceRange.end < 2000 ||
      selectedBrands.isNotEmpty ||
      minRating > 0;
}
