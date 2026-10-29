import 'package:flutter/material.dart';

import '../widgets/cart_appbar.dart';
import '../widgets/cart_bottomNavbar.dart';
import '../widgets/cart_itemSamples.dart';

class CartPage extends StatefulWidget {
  final List<CartItemData> cartItems;
  final void Function(int index) onIncrease;
  final void Function(int index) onDecrease;
  final void Function(int index) onDelete;
  final VoidCallback onClearCart;

  const CartPage({
    super.key,
    required this.cartItems,
    required this.onIncrease,
    required this.onDecrease,
    required this.onDelete,
    required this.onClearCart,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final TextEditingController _couponController = TextEditingController();
  bool _isCouponApplied = false;
  static const int _couponDiscountAmount = 150000;

  static const Color primaryColor = Color(0xFF475569);
  static const Color backgroundColor = Color(0xFFF8FAFC);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color textPrimaryColor = Color(0xFF1F2937);
  static const Color textSecondaryColor = Color(0xFF6B7280);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color badgeBgColor = Color(0xFFF8FAFC);

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  // Perhitungan Subtotal Produk
  int get _subtotal {
    int total = 0;
    for (final item in widget.cartItems) {
      total += item.totalPrice;
    }
    return total;
  }

  // Total unit barang
  int get _totalUnits {
    int units = 0;
    for (final item in widget.cartItems) {
      units += item.quantity;
    }
    return units;
  }

  // Total Pembayaran Akhir
  int get _totalPayment {
    final sub = _subtotal;
    if (sub == 0) return 0;
    final discount = _isCouponApplied ? _couponDiscountAmount : 0;
    final total = sub - discount;
    return total > 0 ? total : 0;
  }

  void _deleteItem(int index) {
    final name = widget.cartItems[index].product.name;
    widget.onDelete(index);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$name dihapus dari keranjang'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: textPrimaryColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _clearCart() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: surfaceColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Kosongkan Keranjang?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: textPrimaryColor,
            ),
          ),
          content: const Text(
            'Semua produk yang ada di keranjang belanja akan dihapus.',
            style: TextStyle(fontSize: 13, color: textSecondaryColor),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              onPressed: () {
                Navigator.pop(context);
                widget.onClearCart();
                setState(() {
                  _isCouponApplied = false;
                });
              },
              child: const Text('Hapus Semua'),
            ),
          ],
        );
      },
    );
  }

  void _applyCoupon() {
    final code = _couponController.text.trim();
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan kode kupon terlebih dahulu'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _isCouponApplied = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Kupon "$code" berhasil diterapkan! (-Rp 150.000)'),
        backgroundColor: primaryColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _removeCoupon() {
    setState(() {
      _isCouponApplied = false;
      _couponController.clear();
    });
  }

  String _formatRupiah(int price) {
    return 'Rp ${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // AppBar Keranjang Terintegrasi
            CartAppBar(
              itemCount: widget.cartItems.length,
              onClearCart: widget.cartItems.isNotEmpty ? _clearCart : null,
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 8, bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Daftar Item Keranjang
                    CartItemsamples(
                      cartItems: widget.cartItems,
                      onIncrease: widget.onIncrease,
                      onDecrease: widget.onDecrease,
                      onDelete: _deleteItem,
                    ),

                    if (widget.cartItems.isNotEmpty) ...[
                      const SizedBox(height: 16),

                      // 2. Kupon & Promosi Sesuai Stitch
                      _buildCouponSection(),
                      const SizedBox(height: 16),

                      // 3. Ringkasan Pesanan (Order Summary Card)
                      _buildOrderSummaryCard(),
                      const SizedBox(height: 16),

                      // 4. Banner Jaminan Garansi Resmi
                      _buildWarrantyNotice(),
                    ],
                  ],
                ),
              ),
            ),

            // Sticky Bottom Bar Checkout
            if (widget.cartItems.isNotEmpty)
              CartBottomnavbar(
                totalAmount: _totalPayment,
                onCheckout: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Memproses pesanan (${_formatRupiah(_totalPayment)})...',
                      ),
                      backgroundColor: primaryColor,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  // Section Kupon & Promosi
  Widget _buildCouponSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Kupon & Promosi',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: textPrimaryColor,
                ),
              ),
              Text(
                '1 Kupon Aktif',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Input Box Kupon
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.local_offer_outlined,
                  color: primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _couponController,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: textPrimaryColor,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'ELEKTROHEMAT',
                      hintStyle: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _applyCoupon,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                  ),
                  child: const Text(
                    'Terapkan',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),

          // Banner Kupon Berhasil Diterapkan
          if (_isCouponApplied) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: badgeBgColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: primaryColor.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: primaryColor,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Kupon berhasil diterapkan',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: textPrimaryColor,
                          ),
                        ),
                        Text(
                          'Potongan langsung diskon hemat',
                          style: TextStyle(
                            fontSize: 10,
                            color: textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    '-Rp 150.000',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: _removeCoupon,
                    child: const Icon(
                      Icons.close_rounded,
                      size: 16,
                      color: textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Ringkasan Pesanan Card
  Widget _buildOrderSummaryCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.receipt_long_outlined, color: primaryColor, size: 18),
              SizedBox(width: 8),
              Text(
                'Ringkasan Pesanan',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: textPrimaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Subtotal Produk
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal Produk ($_totalUnits unit)',
                style: const TextStyle(fontSize: 12, color: textSecondaryColor),
              ),
              Text(
                _formatRupiah(_subtotal),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: textPrimaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Diskon Kupon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    'Diskon Kupon',
                    style: TextStyle(fontSize: 12, color: textSecondaryColor),
                  ),
                  if (_isCouponApplied) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: badgeBgColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'ELEKTROHEMAT',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              Text(
                _isCouponApplied ? '-Rp 150.000' : 'Rp 0',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _isCouponApplied ? primaryColor : textSecondaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Biaya Pengiriman
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Biaya Pengiriman',
                style: TextStyle(fontSize: 12, color: textSecondaryColor),
              ),
              Row(
                children: const [
                  Text(
                    'Rp 40.000',
                    style: TextStyle(
                      fontSize: 11,
                      decoration: TextDecoration.lineThrough,
                      color: textSecondaryColor,
                    ),
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Gratis',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF16A34A),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Biaya Layanan & Asuransi
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Biaya Layanan & Asuransi',
                style: TextStyle(fontSize: 12, color: textSecondaryColor),
              ),
              Text(
                'Rp 0',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: textPrimaryColor,
                ),
              ),
            ],
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Divider(height: 1, thickness: 1, color: borderColor),
          ),

          // Total Pembayaran
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Total Pembayaran',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: textPrimaryColor,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Sudah termasuk PPN 11%',
                    style: TextStyle(fontSize: 10, color: textSecondaryColor),
                  ),
                ],
              ),
              Text(
                _formatRupiah(_totalPayment),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Jaminan Garansi Resmi Banner
  Widget _buildWarrantyNotice() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: badgeBgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor.withValues(alpha: 0.6)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(Icons.verified_user_outlined, size: 18, color: primaryColor),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Garansi Resmi 100% Original',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: textPrimaryColor,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Pengembalian mudah 14 hari bila rusak atau cacat produksi.',
                  style: TextStyle(
                    fontSize: 10,
                    color: textSecondaryColor,
                    height: 1.3,
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
