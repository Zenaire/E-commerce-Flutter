import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/chat_item.dart';
import '../models/chat_message.dart';

class ChatRepository {
  static const String _chatsPath = 'assets/data/chats.json';
  static const String _messagesPath = 'assets/data/messages.json';

  /// Memuat daftar percakapan toko dari assets/data/chats.json
  static Future<List<ChatItem>> loadChats() async {
    try {
      final String jsonString = await rootBundle.loadString(_chatsPath);
      final dynamic decoded = json.decode(jsonString);

      if (decoded is Map<String, dynamic> && decoded['chats'] is List) {
        return (decoded['chats'] as List)
            .whereType<Map<String, dynamic>>()
            .map((item) => ChatItem.fromJson(item))
            .toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  /// Memuat pesan percakapan berdasarkan chatId dari assets/data/messages.json
  static Future<List<ChatMessage>> loadMessages(String chatId) async {
    try {
      final String jsonString = await rootBundle.loadString(_messagesPath);
      final dynamic decoded = json.decode(jsonString);

      if (decoded is Map<String, dynamic> && decoded['messages'] is List) {
        return (decoded['messages'] as List)
            .whereType<Map<String, dynamic>>()
            .where((item) => item['chatId'] == chatId)
            .map((item) => ChatMessage.fromJson(item))
            .toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }
}
