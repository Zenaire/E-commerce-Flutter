class ChatMessage {
  final String id;
  final String chatId;
  final String sender; // 'customer' | 'seller'
  final String text;
  final DateTime sentAt;
  final String? productId;

  const ChatMessage({
    required this.id,
    required this.chatId,
    required this.sender,
    required this.text,
    required this.sentAt,
    this.productId,
  });

  bool get isMe => sender == 'customer';

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate;
    try {
      parsedDate = DateTime.parse(
        json['sentAt'] as String? ?? '2026-10-14T08:00:00+07:00',
      );
    } catch (_) {
      parsedDate = DateTime.now();
    }

    return ChatMessage(
      id: json['id'] as String? ?? '',
      chatId: json['chatId'] as String? ?? '',
      sender: json['sender'] as String? ?? 'customer',
      text: json['text'] as String? ?? '',
      sentAt: parsedDate,
      productId: json['productId'] as String?,
    );
  }

  String get formattedTime {
    final hour = sentAt.hour.toString().padLeft(2, '0');
    final minute = sentAt.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
