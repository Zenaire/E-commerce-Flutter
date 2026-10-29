class Product {
  final String id;
  final String name;
  final String brand;
  final String category;
  final String description;
  final int price;
  final int originalPrice;
  final double rating;
  final int reviewCount;
  final int stock;
  final String imageUrl;
  final String fallbackImageUrl;
  final bool isFeatured;
  final bool isAvailable;

  const Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    this.description = '',
    required this.price,
    required this.originalPrice,
    required this.rating,
    required this.reviewCount,
    required this.stock,
    required this.imageUrl,
    required this.fallbackImageUrl,
    this.isFeatured = false,
    this.isAvailable = true,
  });

  /// Factory constructor untuk parsing JSON dengan fallback aman
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Produk Tanpa Nama',
      brand: json['brand'] as String? ?? 'Umum',
      category: json['category'] as String? ?? 'Elektronik',
      description: json['description'] as String? ?? '',
      price: (json['price'] as num?)?.toInt() ?? 0,
      originalPrice: (json['originalPrice'] as num?)?.toInt() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      imageUrl: json['imageUrl'] as String? ?? '',
      fallbackImageUrl: json['fallbackImageUrl'] as String? ?? '',
      isFeatured: json['isFeatured'] as bool? ?? false,
      isAvailable: json['isAvailable'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'category': category,
      'description': description,
      'price': price,
      'originalPrice': originalPrice,
      'rating': rating,
      'reviewCount': reviewCount,
      'stock': stock,
      'imageUrl': imageUrl,
      'fallbackImageUrl': fallbackImageUrl,
      'isFeatured': isFeatured,
      'isAvailable': isAvailable,
    };
  }

  /// Menghitung persentase diskon jika harga asli lebih tinggi
  int get discountPercent {
    if (originalPrice > price && originalPrice > 0) {
      return (((originalPrice - price) / originalPrice) * 100).round();
    }
    return 0;
  }

  /// Format harga Indonesia: misal "Rp 13.999.000"
  String get formattedPrice {
    return 'Rp ${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  /// Format harga asli Indonesia: misal "Rp 16.499.000"
  String get formattedOriginalPrice {
    return 'Rp ${originalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }
}
