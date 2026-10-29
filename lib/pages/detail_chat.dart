import 'package:flutter/material.dart';

import '../models/chat_message.dart';
import '../services/chat_repository.dart';

class ChatScreen extends StatefulWidget {
  final String contactName;
  final String? chatId;
  final String? storeCategory;
  final bool? isOnline;
  final String? avatarUrl;

  const ChatScreen({
    super.key,
    required this.contactName,
    this.chatId,
    this.storeCategory,
    this.isOnline,
    this.avatarUrl,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = true;

  static const Color primaryColor = Color(0xFF475569);
  static const Color backgroundColor = Color(0xFFF8FAFC);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color textPrimaryColor = Color(0xFF1F2937);
  static const Color textSecondaryColor = Color(0xFF6B7280);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color sellerBubbleColor = Color(0xFFF8FAFC);
  static const Color onlineColor = Color(0xFF16A34A);

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    final effectiveChatId = widget.chatId ?? 'chat_001';
    final loaded = await ChatRepository.loadMessages(effectiveChatId);

    if (!mounted) return;

    setState(() {
      if (loaded.isNotEmpty) {
        _messages.addAll(loaded);
      } else {
        // Fallback default jika chat tidak ditemukan di JSON
        _messages.addAll([
          ChatMessage(
            id: 'fb_1',
            chatId: effectiveChatId,
            sender: 'seller',
            text:
                'Halo Kak Siti! Ada yang bisa kami bantu terkait pesanan atau produk elektronik hari ini?',
            sentAt: DateTime.now().subtract(const Duration(minutes: 10)),
          ),
          ChatMessage(
            id: 'fb_2',
            chatId: effectiveChatId,
            sender: 'customer',
            text:
                'Halo min, mau tanya apakah unit di toko ini bergaransi resmi?',
            sentAt: DateTime.now().subtract(const Duration(minutes: 5)),
          ),
          ChatMessage(
            id: 'fb_3',
            chatId: effectiveChatId,
            sender: 'seller',
            text:
                'Betul sekali kak! Semua unit yang dijual di Archev Digital Store bergaransi resmi.',
            sentAt: DateTime.now().subtract(const Duration(minutes: 2)),
          ),
        ]);
      }
      _isLoading = false;
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _messages.add(
          ChatMessage(
            id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
            chatId: widget.chatId ?? 'chat_001',
            sender: 'customer',
            text: text,
            sentAt: DateTime.now(),
          ),
        );
      });
      _messageController.clear();
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: surfaceColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 0,
        shape: const Border(bottom: BorderSide(color: borderColor, width: 1)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: textPrimaryColor, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Icon(Icons.bolt_rounded, color: Colors.white, size: 20),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Chat Detail',
              style: TextStyle(
                color: textPrimaryColor,
                fontWeight: FontWeight.w700,
                fontSize: 18,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: borderColor, width: 1.5),
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/Reika-X.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: sellerBubbleColor,
                      child: const Icon(
                        Icons.person,
                        size: 20,
                        color: primaryColor,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Sub-Header Info Toko / Partner Sesuai Desain Stitch
          _buildStoreHeader(),

          // 2. Daftar Pesan (Chat Bubbles)
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                    ),
                  )
                : ListView(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    children: [
                      // Badge Pill "HARI INI"
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: sellerBubbleColor,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Text(
                            'HARI INI',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: textSecondaryColor,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // List of Bubble Messages
                      ..._messages.map((msg) => _buildMessageBubble(msg)),

                      // Pill Enkripsi Ujung Percakapan
                      const SizedBox(height: 12),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: surfaceColor,
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: borderColor),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.lock_outline_rounded,
                                size: 12,
                                color: textSecondaryColor,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Pesan terenkripsi dan langsung dijawab oleh tim support',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: textSecondaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          ),

          // 3. Input Bar Bawah (Ketik pesan... & Tombol Kirim)
          _buildBottomInputBar(),
        ],
      ),
    );
  }

  // Header Toko di bawah AppBar sesuai Stitch
  Widget _buildStoreHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: surfaceColor,
        border: Border(bottom: BorderSide(color: borderColor, width: 1)),
      ),
      child: Row(
        children: [
          // Avatar Headset / Toko
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: sellerBubbleColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: borderColor),
                ),
                child: Center(
                  child:
                      widget.avatarUrl != null && widget.avatarUrl!.isNotEmpty
                      ? ClipOval(
                          child: Image.network(
                            widget.avatarUrl!,
                            width: 42,
                            height: 42,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                                  Icons.headset_mic_rounded,
                                  color: primaryColor,
                                  size: 22,
                                ),
                          ),
                        )
                      : const Icon(
                          Icons.headset_mic_rounded,
                          color: primaryColor,
                          size: 22,
                        ),
                ),
              ),
              Positioned(
                right: -1,
                bottom: -1,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: (widget.isOnline ?? true)
                        ? onlineColor
                        : textSecondaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: surfaceColor, width: 1.5),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),

          // Nama Toko & Status Layanan
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        widget.contactName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: textPrimaryColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.check_circle_rounded,
                      size: 14,
                      color: primaryColor,
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${widget.storeCategory ?? "Layanan Pelanggan"} • Online',
                      style: const TextStyle(
                        fontSize: 11,
                        color: textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Badge Pill Respon Cepat
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: sellerBubbleColor,
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Text(
              'Respon < 2 mnt',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Bubble Chat untuk Seller vs Customer
  Widget _buildMessageBubble(ChatMessage message) {
    final isMe = message.isMe;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: Column(
        crossAxisAlignment: isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isMe
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar mini di samping kiri untuk seller
              if (!isMe) ...[
                Container(
                  width: 28,
                  height: 28,
                  margin: const EdgeInsets.only(right: 8, top: 4),
                  decoration: BoxDecoration(
                    color: sellerBubbleColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: borderColor),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.headset_mic_rounded,
                      size: 14,
                      color: primaryColor,
                    ),
                  ),
                ),
              ],

              // Kontainer Balon Obrolan
              Flexible(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.72,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isMe ? primaryColor : sellerBubbleColor,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isMe ? 16 : 4),
                      bottomRight: Radius.circular(isMe ? 4 : 16),
                    ),
                    border: Border.all(
                      color: isMe
                          ? primaryColor
                          : borderColor.withValues(alpha: 0.6),
                    ),
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: isMe ? Colors.white : textPrimaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),

          // Waktu pesan & checklist centang
          Padding(
            padding: EdgeInsets.only(left: isMe ? 0 : 36, right: isMe ? 4 : 0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message.formattedTime,
                  style: const TextStyle(
                    fontSize: 10,
                    color: textSecondaryColor,
                  ),
                ),
                if (isMe) ...[
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.done_all_rounded,
                    size: 14,
                    color: primaryColor,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Input Bar Pengiriman Pesan
  Widget _buildBottomInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: surfaceColor,
        border: const Border(top: BorderSide(color: borderColor, width: 1)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 46,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9), // Soft Pill Input
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        style: const TextStyle(
                          fontSize: 13,
                          color: textPrimaryColor,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Ketik pesan...',
                          hintStyle: TextStyle(
                            fontSize: 13,
                            color: textSecondaryColor,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    const Icon(
                      Icons.chat_bubble_outline_rounded,
                      size: 20,
                      color: textSecondaryColor,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),

            // Tombol Kirim Bulat Biru
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: _sendMessage,
                icon: const Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                tooltip: 'Kirim Pesan',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
