import 'package:e_commerce_template/data/filters/product_filters.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../data/models/product_model.dart';
import '../../widgets/common/common_widgets.dart';
import '../../widgets/product/product_card.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String _selectedCategory = 'All';
  bool _isGridView = true;
  String _sortBy = 'Popular';
  final List<String> _sortOptions = [
    'Popular',
    'Newest',
    'Price: Low to High',
    'Price: High to Low',
    'Rating',
  ];
  final List<String> _allCategories = [
    'All',
    'Electronics',
    'Fashion',
    'Beauty',
    'Sports',
    'Home',
    'Jewelry',
    'Watches',
  ];

  ProductFilters _filters = const ProductFilters();

  List<ProductModel> get _filteredProducts {
    var products = DummyData.products;

    // Category filter
    if (_selectedCategory != 'All') {
      products = products
          .where((p) => p.category == _selectedCategory)
          .toList();
    }

    // Price filter
    products = products
        .where(
          (p) =>
              p.price >= _filters.priceRange.start &&
              p.price <= _filters.priceRange.end,
        )
        .toList();

    // Brand filter
    if (_filters.selectedBrands.isNotEmpty) {
      products = products
          .where((p) => _filters.selectedBrands.contains(p.brand))
          .toList();
    }

    // Rating filter
    if (_filters.minRating > 0) {
      products = products.where((p) => p.rating >= _filters.minRating).toList();
    }

    // Sort by price order filter
    switch (_sortBy) {
      case 'Newest':
        products.sort((a, b) => b.id.compareTo(a.id));
        break;
      case 'Price: Low to High':
        products.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Price: High to Low':
        products.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Rating':
        products.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      default:
        products.sort((a, b) => b.soldCount.compareTo(a.soldCount));
    }
    return products;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softWhite,
      body: Column(
        children: [
          _buildHeader(),
          _buildCategoryTabs(),
          _buildFilterBar(),
          Expanded(child: _buildProductGrid()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 52, 20, 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderGrey),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  const Icon(
                    Icons.search_rounded,
                    color: AppColors.textLight,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search in category...',
                        hintStyle: AppTextStyles.inputHint.copyWith(
                          fontSize: 13,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                        filled: false,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _showFilterSheet,
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.tune_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      color: Colors.white,
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemCount: _allCategories.length,
        itemBuilder: (context, index) {
          final cat = _allCategories[index];
          final isSelected = cat == _selectedCategory;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                gradient: isSelected ? AppColors.primaryGradient : null,
                color: isSelected ? null : AppColors.lightGrey,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  cat,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: isSelected ? Colors.white : AppColors.textMedium,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterBar() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              Text(
                '${_filteredProducts.length} Products',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textMedium,
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: _showSortSheet,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.borderGrey),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.swap_vert_rounded,
                        size: 16,
                        color: AppColors.textMedium,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _sortBy,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w500,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _isGridView = true),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: _isGridView
                            ? AppColors.royalBlueSurface
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        Icons.grid_view_rounded,
                        size: 18,
                        color: _isGridView
                            ? AppColors.royalBlue
                            : AppColors.textLight,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _isGridView = false),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: !_isGridView
                            ? AppColors.royalBlueSurface
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        Icons.view_list_rounded,
                        size: 18,
                        color: !_isGridView
                            ? AppColors.royalBlue
                            : AppColors.textLight,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (_filters.isActive)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // Price chip
                  if (_filters.priceRange.start > 0 ||
                      _filters.priceRange.end < 2000)
                    _buildActiveChip(
                      '\$${_filters.priceRange.start.toInt()}–\$${_filters.priceRange.end.toInt()}',
                      () => setState(
                        () => _filters = ProductFilters(
                          selectedBrands: _filters.selectedBrands,
                          minRating: _filters.minRating,
                        ),
                      ),
                    ),
                  // Brand chips
                  ..._filters.selectedBrands.map(
                    (b) => _buildActiveChip(
                      b,
                      () => setState(
                        () => _filters = ProductFilters(
                          priceRange: _filters.priceRange,
                          selectedBrands: _filters.selectedBrands..remove(b),
                          minRating: _filters.minRating,
                        ),
                      ),
                    ),
                  ),
                  // Rating chip
                  if (_filters.minRating > 0)
                    _buildActiveChip(
                      '${_filters.minRating.toInt()}★ & up',
                      () => setState(
                        () => _filters = ProductFilters(
                          priceRange: _filters.priceRange,
                          selectedBrands: _filters.selectedBrands,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildActiveChip(String label, VoidCallback onRemove) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.royalBlueSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.royalBlue.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.royalBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.close_rounded,
              size: 14,
              color: AppColors.royalBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid() {
    final products = _filteredProducts;
    if (products.isEmpty) {
      return const EmptyStateWidget(
        emoji: '🔍',
        title: 'No Products Found',
        subtitle: 'Try a different category or search term.',
      );
    }
    if (_isGridView) {
      return GridView.builder(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 0.68,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) => ProductCard(product: products[index]),
      );
    } else {
      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
        itemCount: products.length,
        itemBuilder: (context, index) =>
            ProductListCard(product: products[index]),
      );
    }
  }

  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.borderGrey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('Sort By', style: AppTextStyles.headingMedium),
            const SizedBox(height: 16),
            ..._sortOptions
                .map(
                  (option) => GestureDetector(
                    onTap: () {
                      setState(() => _sortBy = option);
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: _sortBy == option
                            ? AppColors.royalBlueSurface
                            : AppColors.lightGrey,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _sortBy == option
                              ? AppColors.royalBlue.withOpacity(0.3)
                              : Colors.transparent,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            option,
                            style: AppTextStyles.labelLarge.copyWith(
                              color: _sortBy == option
                                  ? AppColors.royalBlue
                                  : AppColors.textDark,
                              fontSize: 14,
                            ),
                          ),
                          const Spacer(),
                          if (_sortBy == option)
                            const Icon(
                              Icons.check_rounded,
                              color: AppColors.royalBlue,
                              size: 18,
                            ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        builder: (context, scrollController) => _FilterSheet(
          scrollController: scrollController,
          initialFilters: _filters, // pass current state in
          onApply: (filters) {
            // receive result back
            setState(() => _filters = filters);
          },
        ),
      ),
    );
  }
}

// Filter bottom sheet
class _FilterSheet extends StatefulWidget {
  final ScrollController scrollController;
  final ProductFilters initialFilters;
  final ValueChanged<ProductFilters> onApply;

  const _FilterSheet({
    required this.scrollController,
    required this.initialFilters,
    required this.onApply,
  });

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late RangeValues _priceRange;
  late List<String> _selectedBrands;
  late double _minRating;

  @override
  void initState() {
    super.initState();

    _priceRange = widget.initialFilters.priceRange;
    _selectedBrands = List.from(widget.initialFilters.selectedBrands);
    _minRating = widget.initialFilters.minRating;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderGrey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Filter', style: AppTextStyles.headingMedium),
              TextButton(
                onPressed: () {
                  setState(() {
                    _priceRange = const RangeValues(0, 2000);
                    _selectedBrands = [];
                    _minRating = 0;
                  });
                },
                child: Text(
                  'Reset All',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.royalBlue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text('Price Range', style: AppTextStyles.headingSmall),
          const SizedBox(height: 4),
          Text(
            '\$${_priceRange.start.toInt()} - \$${_priceRange.end.toInt()}',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.royalBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
          RangeSlider(
            values: _priceRange,
            min: 0,
            max: 2000,
            divisions: 40,
            activeColor: AppColors.royalBlue,
            inactiveColor: AppColors.borderGrey,
            onChanged: (vals) => setState(() => _priceRange = vals),
          ),
          const SizedBox(height: 16),
          Text('Brands', style: AppTextStyles.headingSmall),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: DummyData.brands.map((brand) {
              final isSelected = _selectedBrands.contains(brand.name);
              return GestureDetector(
                onTap: () => setState(
                  () => isSelected
                      ? _selectedBrands.remove(brand.name)
                      : _selectedBrands.add(brand.name),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: isSelected ? AppColors.primaryGradient : null,
                    color: isSelected ? null : AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    brand.name,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: isSelected ? Colors.white : AppColors.textMedium,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Text('Minimum Rating', style: AppTextStyles.headingSmall),
          const SizedBox(height: 8),
          Row(
            children: [1, 2, 3, 4, 5].map((r) {
              final isSelected = _minRating == r.toDouble();
              return GestureDetector(
                onTap: () => setState(() => _minRating = r.toDouble()),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: isSelected ? AppColors.primaryGradient : null,
                    color: isSelected ? null : AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star_rounded,
                        size: 14,
                        color: isSelected ? Colors.white : AppColors.luxuryGold,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '$r+',
                        style: AppTextStyles.caption.copyWith(
                          color: isSelected ? Colors.white : AppColors.textDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const Spacer(),
          PremiumButton(
            text: 'Apply Filters',
            onTap: () {
              widget.onApply(
                ProductFilters(
                  priceRange: _priceRange,
                  selectedBrands: _selectedBrands,
                  minRating: _minRating,
                ),
              );
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
