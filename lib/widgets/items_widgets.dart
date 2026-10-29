import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/product_repository.dart';
import 'product_image.dart';

class ItemsWidgets extends StatefulWidget {
  final List<Product>? products;
  final bool isLoading;
  final String selectedCategory;
  final String searchQuery;
  final void Function(Product product)? onAddToCart;

  const ItemsWidgets({
    super.key,
    this.products,
    this.isLoading = false,
    this.selectedCategory = 'Semua',
    this.searchQuery = '',
    this.onAddToCart,
  });

  @override
  State<ItemsWidgets> createState() => _ItemsWidgetsState();
}

class _ItemsWidgetsState extends State<ItemsWidgets> {
  static const Color primaryColor = Color(0xFF475569);
  static const Color accentColor = Color(0xFF7DD3FC);
  static const Color textPrimaryColor = Color(0xFF1F2937);
  static const Color textSecondaryColor = Color(0xFF6B7280);
  static const Color textMutedColor = Color(0xFF9CA3AF);
  static const Color borderColor = Color(0xFFE2E8F0);

  List<Product> _loadedProducts = [];
  bool _internalLoading = true;

  @override
  void initState() {
    super.initState();

    if (widget.products == null) {
      _loadProductsLocally();
    } else {
      _internalLoading = false;
    }
  }

  @override
  void didUpdateWidget(covariant ItemsWidgets oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.products != null && oldWidget.products == null) {
      _internalLoading = false;
    } else if (widget.products == null && oldWidget.products != null) {
      _internalLoading = true;
      _loadProductsLocally();
    }
  }

  Future<void> _loadProductsLocally() async {
    try {
      final list = await ProductRepository.loadProducts();
      if (!mounted) return;

      setState(() {
        _loadedProducts = list;
        _internalLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _loadedProducts = [];
        _internalLoading = false;
      });
    }
  }

  List<Product> _getFilteredProducts() {
    final source = widget.products ?? _loadedProducts;
    final query = widget.searchQuery.trim().toLowerCase();

    return source.where((product) {
      final matchesCategory =
          widget.selectedCategory == 'Semua' ||
          product.category.toLowerCase() ==
              widget.selectedCategory.toLowerCase();

      final matchesSearch =
          query.isEmpty ||
          product.name.toLowerCase().contains(query) ||
          product.brand.toLowerCase().contains(query) ||
          product.description.toLowerCase().contains(query);

      return matchesCategory && matchesSearch;
    }).toList();
  }

  void _onAddToCart(BuildContext context, Product product) {
    if (widget.onAddToCart == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fitur keranjang belum terhubung.')),
      );
      return;
    }

    widget.onAddToCart!(product);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF16A34A),
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '${product.name} dimasukkan ke keranjang',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: textPrimaryColor,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final loading = widget.isLoading || _internalLoading;

    if (loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
          ),
        ),
      );
    }

    final filteredProducts = _getFilteredProducts();

    if (filteredProducts.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: Color(0xFFF1F5F9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.search_off_rounded,
                  color: textSecondaryColor,
                  size: 28,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Produk Tidak Ditemukan',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: textPrimaryColor,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Coba gunakan kata kunci lain atau pilih kategori lain.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: textSecondaryColor),
              ),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.66,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final product = filteredProducts[index];

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: borderColor, width: 1),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: ProductImage(
                        imageUrl: product.imageUrl,
                        fallbackImageUrl: product.fallbackImageUrl,
                        width: double.infinity,
                        height: 128,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF7D6),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: Color(0xFF7DD3FC),
                              size: 11,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              product.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Text(
                          'Free Ongkir',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF475569),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.category.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          color: primaryColor,
                          letterSpacing: 0.4,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: textPrimaryColor,
                          height: 1.2,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        product.formattedPrice,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: textPrimaryColor,
                        ),
                      ),
                      if (product.originalPrice > product.price) ...[
                        const SizedBox(height: 2),
                        Text(
                          product.formattedOriginalPrice,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: textMutedColor,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 32,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                product.description.isNotEmpty
                                    ? product.description
                                    : 'Pilihan terbaik',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w700,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => _onAddToCart(context, product),
                              borderRadius: BorderRadius.circular(10),
                              child: Ink(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: accentColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.add_shopping_cart_rounded,
                                  color: Color(0xFF0F172A),
                                  size: 18,
                                ),
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
        );
      },
    );
  }
}
