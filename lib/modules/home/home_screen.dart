import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/bindings/app_controller.dart';
import '../../app/routes/app_routes.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_dimensions.dart';
import '../../data/models/product_model.dart';
import '../../widgets/common/common_widgets.dart';
import '../../widgets/product/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  int _bannerIndex = 0;
  final PageController _bannerController = PageController();

  @override
  void initState() {
    super.initState();
    _startBannerAutoPlay();
  }

  void _startBannerAutoPlay() async {
    while (mounted) {
      await Future.delayed(const Duration(seconds: 4));
      if (mounted && _bannerController.hasClients) {
        final nextPage = (_bannerIndex + 1) % DummyData.banners.length;
        _bannerController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();
    final products = DummyData.products;

    return Scaffold(
      backgroundColor: AppColors.softWhite,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildAppBar(appController),
          SliverToBoxAdapter(child: const SizedBox(height: 12)),
          SliverToBoxAdapter(child: _buildSearchBar()),
          SliverToBoxAdapter(child: const SizedBox(height: 16)),
          SliverToBoxAdapter(child: _buildBannerSlider()),
          SliverToBoxAdapter(child: const SizedBox(height: 24)),
          SliverToBoxAdapter(child: _buildCategories()),
          SliverToBoxAdapter(child: const SizedBox(height: 24)),
          SliverToBoxAdapter(child: _buildFlashSale(products)),
          SliverToBoxAdapter(child: const SizedBox(height: 24)),
          SliverToBoxAdapter(child: _buildFeaturedProducts(products)),
          SliverToBoxAdapter(child: const SizedBox(height: 24)),
          SliverToBoxAdapter(child: _buildPopularBrands()),
          SliverToBoxAdapter(child: const SizedBox(height: 24)),
          SliverToBoxAdapter(child: _buildBestSellers(products)),
          SliverToBoxAdapter(child: const SizedBox(height: 24)),
          SliverToBoxAdapter(child: _buildSpecialOfferBanner()),
          SliverToBoxAdapter(child: const SizedBox(height: 24)),
          SliverToBoxAdapter(child: _buildNewArrivals(products)),
          SliverToBoxAdapter(child: const SizedBox(height: 24)),
        ],
      ),
    );
  }

  Widget _buildAppBar(AppController appController) {
    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: Colors.white,
      elevation: 0,
      toolbarHeight: 64,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(20, 48, 20, 0),
          child: Row(
            children: [
              // Logo
              Row(
                children: [
                  // Container(
                  //   width: 36,
                  //   height: 36,
                  //   decoration: BoxDecoration(
                  //     gradient: AppColors.primaryGradient,
                  //     borderRadius: BorderRadius.circular(10),
                  //   ),
                  //   child: const Center(
                  //     child: Text(
                  //       'L',
                  //       style: TextStyle(
                  //         fontFamily: 'Poppins',
                  //         fontSize: 20,
                  //         fontWeight: FontWeight.w800,
                  //         color: Colors.white,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(width: 8),
                  ShaderMask(
                    shaderCallback: (bounds) =>
                        AppColors.primaryGradient.createShader(bounds),
                    child: Text(
                      'LuxeMart',
                      style: AppTextStyles.headingMedium.copyWith(
                        color: Colors.white,
                        fontSize: 24
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Location
              // Row(
              //   children: [
              //     const Icon(
              //       Icons.location_on_outlined,
              //       color: AppColors.royalBlue,
              //       size: 16,
              //     ),
              //     const SizedBox(width: 4),
              //     Text(
              //       'New York, US',
              //       style: AppTextStyles.bodySmall.copyWith(
              //         color: AppColors.textDark,
              //         fontSize: 12,
              //       ),
              //     ),
              //     const Icon(
              //       Icons.keyboard_arrow_down_rounded,
              //       color: AppColors.textLight,
              //       size: 16,
              //     ),
              //   ],
              // ),
              // const Spacer(),
              // Actions
              Row(
                children: [
                  Obx(
                    () => Stack(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.notifications_outlined,
                            color: AppColors.elegantBlack,
                          ),
                          onPressed: () => Get.toNamed(AppRoutes.notifications),
                        ),
                        if (appController.notificationCount.value > 0)
                          Positioned(
                            right: 6,
                            top: 6,
                            child: Container(
                              width: 16,
                              height: 16,
                              decoration: const BoxDecoration(
                                color: AppColors.saleRed,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${appController.notificationCount.value}',
                                  style: const TextStyle(
                                    fontSize: 9,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // GestureDetector(
                  //   onTap: () => appController.setNavIndex(4),
                  //   child: Container(
                  //     width: 36,
                  //     height: 36,
                  //     decoration: BoxDecoration(
                  //       gradient: AppColors.primaryGradient,
                  //       shape: BoxShape.circle,
                  //     ),
                  //     child: const Center(
                  //       child: Text('👤', style: TextStyle(fontSize: 18)),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.pagePaddingH,
      ),
      child: GestureDetector(
        onTap: () => Get.toNamed(AppRoutes.search),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.borderGrey),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              const Icon(
                Icons.search_rounded,
                color: AppColors.textLight,
                size: 22,
              ),
              const SizedBox(width: 10),
              Text(
                'Search products, brands...',
                style: AppTextStyles.inputHint.copyWith(fontSize: 14),
              ),
              const Spacer(),
              Container(
                margin: const EdgeInsets.all(6),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.tune_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBannerSlider() {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _bannerController,
            onPageChanged: (index) => setState(() => _bannerIndex = index),
            itemCount: DummyData.banners.length,
            padEnds: false,
            itemBuilder: (context, index) =>
                _BannerCard(banner: DummyData.banners[index]),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            DummyData.banners.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _bannerIndex == index ? 20 : 6,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: _bannerIndex == index
                    ? AppColors.royalBlue
                    : AppColors.borderGrey,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategories() {
    return Column(
      children: [
        SectionHeader(
          title: 'Shop by Category',
          onActionTap: () => Get.find<AppController>().setNavIndex(1),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.pagePaddingH,
            ),
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemCount: DummyData.categories.length,
            itemBuilder: (context, index) {
              final cat = DummyData.categories[index];
              return _CategoryCard(category: cat);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFlashSale(List<ProductModel> products) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.pagePaddingH,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '⚡',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Flash Sale',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: _CountdownTimer()),
              TextButton(
                onPressed: () {},
                child: Text(
                  'See All',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.royalBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 290,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.pagePaddingH,
            ),
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemCount: products.where((p) => p.hasDiscount).length,
            itemBuilder: (context, index) {
              final discountedProducts = products
                  .where((p) => p.hasDiscount)
                  .toList();
              return ProductCard(product: discountedProducts[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedProducts(List<ProductModel> products) {
    final featured = products.where((p) => p.isFeatured).toList();
    return Column(
      children: [
        SectionHeader(title: 'Featured Products', onActionTap: () {}),
        const SizedBox(height: 16),
        SizedBox(
          height: 290,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.pagePaddingH,
            ),
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemCount: featured.length,
            itemBuilder: (context, index) =>
                ProductCard(product: featured[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildPopularBrands() {
    return Column(
      children: [
        SectionHeader(title: 'Popular Brands', onActionTap: () {}),
        const SizedBox(height: 16),
        SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.pagePaddingH,
            ),
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemCount: DummyData.brands.length,
            itemBuilder: (context, index) {
              final brand = DummyData.brands[index];
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.borderGrey),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      brand.logo,
                      style: const TextStyle(
                        fontSize: 24,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      brand.name,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBestSellers(List<ProductModel> products) {
    final bestSellers = products.where((p) => p.isBestSeller).toList();
    return Column(
      children: [
        SectionHeader(title: '🏆 Best Sellers', onActionTap: () {}),
        const SizedBox(height: 16),
        SizedBox(
          height: 290,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.pagePaddingH,
            ),
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemCount: bestSellers.length,
            itemBuilder: (context, index) =>
                ProductCard(product: bestSellers[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildSpecialOfferBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.pagePaddingH,
      ),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          gradient: AppColors.goldGradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.luxuryGold.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              top: -20,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.15),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '🎁 Refer & Earn',
                          style: AppTextStyles.headingSmall.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Earn \$20 for every friend you refer',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Invite Now',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.luxuryGoldDark,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewArrivals(List<ProductModel> products) {
    final newArrivals = products.where((p) => p.isNew).toList();
    return Column(
      children: [
        SectionHeader(title: '✨ New Arrivals', onActionTap: () {}),
        const SizedBox(height: 16),
        SizedBox(
          height: 290,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.pagePaddingH,
            ),
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemCount: newArrivals.length,
            itemBuilder: (context, index) =>
                ProductCard(product: newArrivals[index]),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// BANNER CARD
// ============================================================
class _BannerCard extends StatelessWidget {
  final BannerModel banner;

  const _BannerCard({required this.banner});

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Color>> gradients = {
      '1': [const Color(0xFF1A3C8F), const Color(0xFF6B21A8)],
      '2': [const Color(0xFF6B21A8), const Color(0xFF9333EA)],
      '3': [const Color(0xFFD4AF37), const Color(0xFFB8962E)],
    };

    final colors =
        gradients[banner.id] ?? [AppColors.royalBlue, AppColors.deepPurple];

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.pagePaddingH,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colors.first.withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            right: 20,
            bottom: -10,
            child: Text(
              banner.id == '1'
                  ? '🛍️'
                  : banner.id == '2'
                  ? '✨'
                  : '🔥',
              style: const TextStyle(fontSize: 80),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    banner.subtitle,
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  banner.title,
                  style: AppTextStyles.displaySmall.copyWith(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    banner.buttonText,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: colors.first,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// CATEGORY CARD
// ============================================================
class _CategoryCard extends StatelessWidget {
  final CategoryModel category;

  const _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    final color = AppColors
        .categoryColors[category.colorIndex % AppColors.categoryColors.length];

    return GestureDetector(
      onTap: () => Get.find<AppController>().setNavIndex(1),
      child: Column(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withOpacity(0.2)),
            ),
            child: Center(
              child: Text(category.icon, style: const TextStyle(fontSize: 28)),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            category.name,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textDark,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ============================================================
// COUNTDOWN TIMER
// ============================================================
class _CountdownTimer extends StatefulWidget {
  @override
  State<_CountdownTimer> createState() => __CountdownTimerState();
}

class __CountdownTimerState extends State<_CountdownTimer> {
  int _hours = 5;
  int _minutes = 43;
  int _seconds = 22;

  @override
  void initState() {
    super.initState();
    _tick();
  }

  void _tick() async {
    while (mounted) {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          if (_seconds > 0) {
            _seconds--;
          } else if (_minutes > 0) {
            _minutes--;
            _seconds = 59;
          } else if (_hours > 0) {
            _hours--;
            _minutes = 59;
            _seconds = 59;
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _TimerBox('${_hours.toString().padLeft(2, '0')}'),
        Text(
          ' : ',
          style: AppTextStyles.labelSmall.copyWith(fontWeight: FontWeight.w700),
        ),
        _TimerBox('${_minutes.toString().padLeft(2, '0')}'),
        Text(
          ' : ',
          style: AppTextStyles.labelSmall.copyWith(fontWeight: FontWeight.w700),
        ),
        _TimerBox('${_seconds.toString().padLeft(2, '0')}'),
      ],
    );
  }
}

class _TimerBox extends StatelessWidget {
  final String value;
  const _TimerBox(this.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.royalBlue,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        value,
        style: AppTextStyles.badge.copyWith(fontSize: 11, letterSpacing: 0.5),
      ),
    );
  }
}
