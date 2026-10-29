import 'package:flutter/material.dart';

import '../models/product.dart';
import 'product_image.dart';

class CartItemData {
  final Product product;
  final String variant;
  final String badgeText;
  int quantity;

  CartItemData({
    required this.product,
    this.variant = '',
    this.badgeText = '',
    this.quantity = 1,
  });

  int get totalPrice => product.price * quantity;
}

class CartItemsamples extends StatelessWidget {
  final List<CartItemData> cartItems;
  final Function(int index) onIncrease;
  final Function(int index) onDecrease;
  final Function(int index) onDelete;

  const CartItemsamples({
    super.key,
    required this.cartItems,
    required this.onIncrease,
    required this.onDecrease,
    required this.onDelete,
  });

  static const Color primaryColor = Color(0xFF475569);
  static const Color accentColor = Color(0xFF7DD3FC);
  static const Color textPrimaryColor = Color(0xFF1F2937);
  static const Color textSecondaryColor = Color(0xFF6B7280);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color badgeBgColor = Color(0xFFF8FAFC);

  String _formatRupiah(int price) {
    return 'Rp ${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    if (cartItems.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 52, horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: borderColor),
        ),
        child: Center(
          child: Column(
            children: [
              Container(
                width: 84,
                height: 84,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF475569), Color(0xFF7DD3FC)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  size: 36,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Keranjangmu masih kosong',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: textPrimaryColor,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Jelajahi produk pilihan dan tambahkan ke keranjangmu untuk checkout nanti.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: textSecondaryColor,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Column(
        children: [
          for (int i = 0; i < cartItems.length; i++)
            _buildCartCard(context, cartItems[i], i),
        ],
      ),
    );
  }

  Widget _buildCartCard(BuildContext context, CartItemData item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF475569).withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: badgeBgColor,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: borderColor),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: ProductImage(
                    imageUrl: item.product.imageUrl,
                    fallbackImageUrl: item.product.fallbackImageUrl,
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (item.badgeText.isNotEmpty)
                Positioned(
                  left: 6,
                  bottom: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      item.badgeText,
                      style: const TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: textPrimaryColor,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => onDelete(index),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 6.0),
                        child: Icon(
                          Icons.delete_outline_rounded,
                          color: Color(0xFF9CA3AF),
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: badgeBgColor,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: borderColor),
                  ),
                  child: Text(
                    item.variant.isNotEmpty ? item.variant : 'Varian standard',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatRupiah(item.product.price),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: primaryColor,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () => onDecrease(index),
                            borderRadius: BorderRadius.circular(8),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 5,
                              ),
                              child: Icon(
                                Icons.remove_rounded,
                                size: 14,
                                color: textPrimaryColor,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Text(
                              '${item.quantity}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: textPrimaryColor,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () => onIncrease(index),
                            borderRadius: BorderRadius.circular(8),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 5,
                              ),
                              child: Icon(
                                Icons.add_rounded,
                                size: 14,
                                color: textPrimaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
