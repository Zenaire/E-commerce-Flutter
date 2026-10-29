import 'package:flutter/material.dart';

import '../models/product.dart';
import '../widgets/cart_itemSamples.dart';
import 'account_page.dart';
import 'cart_page.dart';
import 'home_page_content.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const Color primaryColor = Color(0xFF475569);
  static const Color textSecondaryColor = Color(0xFF6B7280);

  int _currentIndex = 0;
  late final PageController _pageController;

  // State keranjang bersama untuk Home dan Cart
  final List<CartItemData> _cartItems = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Tambah produk ke keranjang.
  /// Jika produk sudah ada, naikkan kuantitasnya. Jika belum, tambahkan item baru.
  void _addToCart(Product product) {
    setState(() {
      final existingIndex = _cartItems.indexWhere(
        (item) => item.product.id == product.id,
      );
      if (existingIndex >= 0) {
        _cartItems[existingIndex].quantity++;
      } else {
        _cartItems.add(CartItemData(product: product));
      }
    });
  }

  void _increaseQuantity(int index) {
    setState(() {
      _cartItems[index].quantity++;
    });
  }

  void _decreaseQuantity(int index) {
    if (_cartItems[index].quantity > 1) {
      setState(() {
        _cartItems[index].quantity--;
      });
    }
  }

  void _deleteItem(int index) {
    setState(() {
      _cartItems.removeAt(index);
    });
  }

  void _clearCart() {
    setState(() {
      _cartItems.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      extendBody: true,
      body: Container(
        color: const Color(0xFFF8FAFC),
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: [
            HomePageContent(onAddToCart: _addToCart),
            CartPage(
              cartItems: _cartItems,
              onIncrease: _increaseQuantity,
              onDecrease: _decreaseQuantity,
              onDelete: _deleteItem,
              onClearCart: _clearCart,
            ),
            const AccountPage(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(26),
              bottom: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withValues(alpha: 0.12),
                blurRadius: 20,
                offset: const Offset(0, -6),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                  _pageController.jumpToPage(index);
                });
              },
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedItemColor: primaryColor,
              unselectedItemColor: textSecondaryColor,
              selectedFontSize: 11,
              unselectedFontSize: 11,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home_rounded),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart_outlined),
                  activeIcon: Icon(Icons.shopping_cart_rounded),
                  label: 'Keranjang',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline_rounded),
                  activeIcon: Icon(Icons.person_rounded),
                  label: 'Akun',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
