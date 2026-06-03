import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/bindings/app_controller.dart';
import '../../app/routes/app_routes.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_dimensions.dart';
import '../../data/models/product_model.dart';
import '../common/common_widgets.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final double? width;

  const ProductCard({super.key, required this.product, this.width});

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();

    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.productDetail, arguments: product),
      child: Container(
        width: width ?? 160,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Stack(
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppDimensions.radiusLG),
                      topRight: Radius.circular(AppDimensions.radiusLG),
                    ),
                  ),
                  child: Center(
                    child: _buildProductImage(product),
                  ),
                ),
                // Discount Badge
                if (product.hasDiscount)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: DiscountBadge(percent: product.discountPercent),
                  ),
                // Wishlist Button
                Positioned(
                  top: 8,
                  right: 8,
                  child: Obx(() => GestureDetector(
                        onTap: () => appController.toggleWishlist(product.id),
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Icon(
                            appController.isInWishlist(product.id)
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            size: 16,
                            color: appController.isInWishlist(product.id)
                                ? AppColors.errorRed
                                : AppColors.textLight,
                          ),
                        ),
                      )),
                ),
                // New Badge
                if (product.isNew)
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.royalBlue,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'NEW',
                        style: AppTextStyles.badge.copyWith(fontSize: 9),
                      ),
                    ),
                  ),
              ],
            ),
            // Product Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.brand,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.royalBlue,
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      product.name,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    StarRating(
                      rating: product.rating,
                      size: 12,
                      reviewCount: product.reviewCount,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '\$${product.price.toStringAsFixed(2)}',
                                style: AppTextStyles.priceSmall.copyWith(fontSize: 13),
                              ),
                              if (product.hasDiscount)
                                Text(
                                  '\$${product.originalPrice.toStringAsFixed(2)}',
                                  style: AppTextStyles.priceStrikethrough,
                                ),
                            ],
                          ),
                        ),
                        // Quick Add Button
                        GestureDetector(
                          onTap: () => appController.addToCart(product),
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.add_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(ProductModel product) {
    // Using emoji as placeholder since we don't have actual images
    const Map<String, String> productEmojis = {
      '1': '📱',
      '2': '📱',
      '3': '👟',
      '4': '⌚',
      '5': '👔',
      '6': '🎧',
      '7': '💻',
      '8': '💄',
    };

    return Text(
      productEmojis[product.id] ?? '🛍️',
      style: const TextStyle(fontSize: 56),
    );
  }
}

// ============================================================
// HORIZONTAL PRODUCT CARD (List View)
// ============================================================
class ProductListCard extends StatelessWidget {
  final ProductModel product;

  const ProductListCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();

    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.productDetail, arguments: product),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
              ),
              child: const Center(child: Text('🛍️', style: TextStyle(fontSize: 40))),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.brand,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.royalBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.name,
                    style: AppTextStyles.labelLarge,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  StarRating(rating: product.rating, size: 12, reviewCount: product.reviewCount),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: AppTextStyles.priceSmall,
                      ),
                      if (product.hasDiscount) ...[
                        const SizedBox(width: 6),
                        Text(
                          '\$${product.originalPrice.toStringAsFixed(2)}',
                          style: AppTextStyles.priceStrikethrough,
                        ),
                        const SizedBox(width: 6),
                        DiscountBadge(percent: product.discountPercent, fontSize: 9),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            // Actions
            Column(
              children: [
                Obx(() => GestureDetector(
                      onTap: () => appController.toggleWishlist(product.id),
                      child: Icon(
                        appController.isInWishlist(product.id)
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: appController.isInWishlist(product.id)
                            ? AppColors.errorRed
                            : AppColors.textLight,
                        size: 20,
                      ),
                    )),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () => appController.addToCart(product),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Add',
                      style: AppTextStyles.badge.copyWith(fontSize: 11),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
