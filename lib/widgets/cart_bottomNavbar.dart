import 'package:flutter/material.dart';

class CartBottomnavbar extends StatefulWidget {
  final int totalAmount;
  final VoidCallback? onCheckout;

  const CartBottomnavbar({super.key, this.totalAmount = 0, this.onCheckout});

  @override
  State<CartBottomnavbar> createState() => _CartBottomnavbarState();
}

class _CartBottomnavbarState extends State<CartBottomnavbar> {
  static const Color accentColor = Color(0xFF7DD3FC);

  double _buttonScale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _buttonScale = 0.96;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _buttonScale = 1.0;
    });
  }

  void _onTapCancel() {
    setState(() {
      _buttonScale = 1.0;
    });
  }

  String _formatRupiah(int price) {
    return 'Rp ${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF475569), Color(0xFF64748B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: const Border(top: BorderSide(color: Colors.transparent)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF475569).withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total checkout',
                    style: TextStyle(fontSize: 11, color: Colors.white70),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _formatRupiah(widget.totalAmount),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTapDown: _onTapDown,
              onTapUp: _onTapUp,
              onTapCancel: _onTapCancel,
              onTap:
                  widget.onCheckout ??
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Memproses pesanan Anda...'),
                        backgroundColor: Color(0xFF475569),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
              child: AnimatedScale(
                scale: _buttonScale,
                duration: const Duration(milliseconds: 120),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF7DD3FC).withValues(alpha: 0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'Checkout',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
