import 'package:flutter/material.dart';

import '../models/chat_item.dart';
import '../services/chat_repository.dart';

class ListChatPage extends StatefulWidget {
  const ListChatPage({super.key});

  @override
  State<ListChatPage> createState() => _ListChatPageState();
}

class _ListChatPageState extends State<ListChatPage> {
  bool _showUnreadOnly = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<ChatItem> _chats = [];
  bool _isLoading = true;

  static const Color primaryColor = Color(0xFF475569);
  static const Color backgroundColor = Color(0xFFF8FAFC);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color textPrimaryColor = Color(0xFF1F2937);
  static const Color textSecondaryColor = Color(0xFF6B7280);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color badgeBgColor = Color(0xFFF8FAFC);
  static const Color unreadBadgeColor = Color(0xFFDC2626);
  static const Color onlineColor = Color(0xFF16A34A);

  @override
  void initState() {
    super.initState();
    _fetchChats();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchChats() async {
    final loaded = await ChatRepository.loadChats();
    if (!mounted) return;
    setState(() {
      _chats = loaded;
      _isLoading = false;
    });
  }

  List<ChatItem> get _filteredChats {
    return _chats.where((chat) {
      if (_showUnreadOnly && chat.unreadCount == 0) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchesName = chat.storeName.toLowerCase().contains(query);
        final matchesMsg = chat.lastMessage.toLowerCase().contains(query);
        final matchesCat = chat.storeCategory.toLowerCase().contains(query);
        if (!matchesName && !matchesMsg && !matchesCat) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  int get _unreadCountTotal {
    return _chats.where((c) => c.unreadCount > 0).length;
  }

  @override
  Widget build(BuildContext context) {
    final visibleChats = _filteredChats;

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
              'Chat List',
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
                      color: badgeBgColor,
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
          // 1. Search Bar Sesuai Desain Stitch
          Container(
            color: surfaceColor,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9), // Inset Soft Pill Fill
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(fontSize: 13, color: textPrimaryColor),
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val.trim();
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Cari percakapan toko atau layanan...',
                  hintStyle: TextStyle(fontSize: 13, color: textSecondaryColor),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: textSecondaryColor,
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),

          // 2. Filter Pills (Semua & Belum Dibaca)
          Container(
            color: surfaceColor,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Row(
              children: [
                _buildFilterPill(
                  label: 'Semua',
                  count: _chats.length,
                  isSelected: !_showUnreadOnly,
                  countBadgeColor: primaryColor,
                  onTap: () {
                    setState(() => _showUnreadOnly = false);
                  },
                ),
                const SizedBox(width: 10),
                _buildFilterPill(
                  label: 'Belum Dibaca',
                  count: _unreadCountTotal,
                  isSelected: _showUnreadOnly,
                  countBadgeColor: unreadBadgeColor,
                  onTap: () {
                    setState(() => _showUnreadOnly = true);
                  },
                ),
              ],
            ),
          ),

          const Divider(height: 1, thickness: 1, color: borderColor),

          // 3. Card Banner Edukasi Layanan Bantuan Siaga 24/7
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: badgeBgColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: borderColor.withValues(alpha: 0.7)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.headset_mic_rounded,
                        color: primaryColor,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Layanan Bantuan Resmi Siaga 24/7',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: textPrimaryColor,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Rata-rata respon toko resmi kurang dari 5 menit',
                          style: TextStyle(
                            fontSize: 11,
                            color: textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.verified_outlined,
                    color: primaryColor,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),

          // 4. Daftar Kartu Percakapan
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                    ),
                  )
                : visibleChats.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 44,
                          color: textSecondaryColor,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Tidak ada percakapan ditemukan',
                          style: TextStyle(
                            fontSize: 13,
                            color: textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: visibleChats.length,
                    itemBuilder: (context, index) {
                      final chat = visibleChats[index];
                      return _buildChatCard(chat);
                    },
                  ),
          ),

          // 5. Footer Informasi Enkripsi
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.circle, size: 5, color: textSecondaryColor),
                SizedBox(width: 6),
                Text(
                  'Percakapan dilindungi dengan enkripsi ujung ke ujung',
                  style: TextStyle(fontSize: 11, color: textSecondaryColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Filter Pill Button
  Widget _buildFilterPill({
    required String label,
    required int count,
    required bool isSelected,
    required Color countBadgeColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : surfaceColor,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: isSelected ? primaryColor : borderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? Colors.white : textPrimaryColor,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.25)
                    : countBadgeColor,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                count.toString(),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Item Kartu Percakapan sesuai referensi Stitch
  Widget _buildChatCard(ChatItem chat) {
    final hasUnread = chat.unreadCount > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.pushNamed(
              context,
              '/detailChat_page',
              arguments: {
                'contactName': chat.storeName,
                'chatId': chat.id,
                'storeCategory': chat.storeCategory,
                'isOnline': chat.isOnline,
                'avatarUrl': chat.avatarUrl,
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                // Avatar Toko dengan Indikator Online
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: borderColor, width: 1.5),
                      ),
                      child: ClipOval(
                        child: Image.network(
                          chat.avatarUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: badgeBgColor,
                              child: const Icon(
                                Icons.storefront_rounded,
                                size: 24,
                                color: primaryColor,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    if (chat.isOnline)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: onlineColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: surfaceColor, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 12),

                // Nama Toko & Preview Pesan Terakhir
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              chat.storeName,
                              style: const TextStyle(
                                fontSize: 13,
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
                      const SizedBox(height: 3),
                      Text(
                        chat.lastMessage,
                        style: TextStyle(
                          fontSize: 12,
                          color: hasUnread
                              ? textPrimaryColor
                              : textSecondaryColor,
                          fontWeight: hasUnread
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Waktu & Badge Pesan Belum Dibaca / Checklist
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      chat.formattedTime,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: hasUnread
                            ? FontWeight.w700
                            : FontWeight.normal,
                        color: hasUnread ? primaryColor : textSecondaryColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    if (hasUnread)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: const BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          chat.unreadCount.toString(),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      )
                    else
                      const Icon(
                        Icons.done_all_rounded,
                        size: 16,
                        color: textSecondaryColor,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
