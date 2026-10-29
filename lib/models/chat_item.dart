class ChatItem {
  final String id;
  final String storeName;
  final String storeCategory;
  final String avatarUrl;
  final String lastMessage;
  final DateTime lastMessageAt;
  final int unreadCount;
  final bool isOnline;
  final String? productId;

  const ChatItem({
    required this.id,
    required this.storeName,
    required this.storeCategory,
    required this.avatarUrl,
    required this.lastMessage,
    required this.lastMessageAt,
    required this.unreadCount,
    required this.isOnline,
    this.productId,
  });

  factory ChatItem.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate;
    try {
      parsedDate = DateTime.parse(
        json['lastMessageAt'] as String? ?? '2026-10-14T08:00:00+07:00',
      );
    } catch (_) {
      parsedDate = DateTime.now();
    }

    return ChatItem(
      id: json['id'] as String? ?? '',
      storeName: json['storeName'] as String? ?? 'Toko Mitra',
      storeCategory: json['storeCategory'] as String? ?? 'Elektronik',
      avatarUrl: json['avatarUrl'] as String? ?? '',
      lastMessage: json['lastMessage'] as String? ?? '',
      lastMessageAt: parsedDate,
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
      isOnline: json['isOnline'] as bool? ?? false,
      productId: json['productId'] as String?,
    );
  }

  /// Teks waktu ringkas untuk daftar chat (misal: "08:15", "Kemarin", dsb.)
  String get formattedTime {
    final hour = lastMessageAt.hour.toString().padLeft(2, '0');
    final minute = lastMessageAt.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
