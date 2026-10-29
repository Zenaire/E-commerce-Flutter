import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/product.dart';

class ProductRepository {
  static const String _productsAssetPath = 'assets/data/products.json';

  /// Memuat daftar produk dari assets/data/products.json secara lokal
  static Future<List<Product>> loadProducts() async {
    try {
      final String jsonString = await rootBundle.loadString(_productsAssetPath);
      final dynamic decoded = json.decode(jsonString);

      if (decoded is List) {
        return decoded
            .whereType<Map<String, dynamic>>()
            .map((item) => Product.fromJson(item))
            .toList();
      }
      return [];
    } catch (e) {
      // Fallback aman mengembalikan list kosong jika file bermasalah
      return [];
    }
  }
}
