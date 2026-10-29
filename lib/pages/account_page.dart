import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  static const Color primaryColor = Color(0xFF475569);
  static const Color backgroundColor = Color(0xFFF8FAFC);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color textPrimaryColor = Color(0xFF1F2937);
  static const Color textSecondaryColor = Color(0xFF6B7280);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color badgeBgColor = Color(0xFFF8FAFC);
  static const Color errorColor = Color(0xFFDC2626);
  static const Color errorBgColor = Color(0xFFFEF2F2);
  static const Color badgeAlertBgColor = Color(0xFFFFE4E6);
  static const Color badgeAlertTextColor = Color(0xFFE11D48);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 16,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF475569), Color(0xFF64748B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Icon(
                  Icons.bolt_rounded,
                  color: Color(0xFF7DD3FC),
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Archev Digital Store',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18,
                letterSpacing: -0.3,
              ),
            ),
            const Spacer(),
            const Text(
              'Account',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/Reika-X.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.white.withValues(alpha: 0.2),
                      child: const Icon(
                        Icons.person,
                        size: 20,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Profil Card Section (Light Blue Gradient Surface)
            _buildProfileCard(),
            const SizedBox(height: 24),

            // 2. Kelompok Menu: Keamanan & Akun
            _buildSectionHeader('KEAMANAN & AKUN'),
            const SizedBox(height: 10),
            _buildMenuCard(
              children: [
                _buildMenuItem(
                  icon: Icons.lock_outline_rounded,
                  iconColor: primaryColor,
                  iconBgColor: badgeBgColor,
                  title: 'Ubah Kata Sandi',
                  subtitle: 'Perbarui kata sandi secara berkala',
                  onTap: () {
                    Navigator.pushNamed(context, '/change_pass_page');
                  },
                ),
                const Divider(height: 1, thickness: 1, color: borderColor),
                _buildMenuItem(
                  icon: Icons.chat_bubble_outline_rounded,
                  iconColor: primaryColor,
                  iconBgColor: badgeBgColor,
                  title: 'Pesan & Obrolan',
                  subtitle: 'Konsultasi teknisi & toko resmi',
                  badgeText: '2 Baru',
                  onTap: () {
                    Navigator.pushNamed(context, '/listChat_page');
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 3. Kelompok Menu: Informasi Aplikasi
            _buildSectionHeader('INFORMASI APLIKASI'),
            const SizedBox(height: 10),
            _buildMenuCard(
              children: [
                _buildMenuItem(
                  icon: Icons.info_outline_rounded,
                  iconColor: primaryColor,
                  iconBgColor: badgeBgColor,
                  title: 'Tentang Archev Digital Store',
                  subtitle: 'v1.2.0 - Proyek Flutter',
                  onTap: () {
                    _showAboutDialog(context);
                  },
                ),
                const Divider(height: 1, thickness: 1, color: borderColor),
                _buildMenuItem(
                  icon: Icons.help_outline_rounded,
                  iconColor: primaryColor,
                  iconBgColor: badgeBgColor,
                  title: 'Bantuan & Panduan',
                  subtitle: 'Pusat solusi belanja gadget',
                  onTap: () {
                    _showHelpDialog(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 4. Kelompok Menu: Sesi (Logout)
            _buildSectionHeader('SESI'),
            const SizedBox(height: 10),
            _buildMenuCard(
              children: [
                _buildMenuItem(
                  icon: Icons.logout_rounded,
                  iconColor: errorColor,
                  iconBgColor: errorBgColor,
                  title: 'Keluar',
                  titleColor: errorColor,
                  subtitle: 'Akhiri sesi di perangkat ini',
                  chevronColor: errorColor,
                  onTap: () {
                    _showLogoutDialog(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 5. Footer Keamanan Sesi
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.verified_user_outlined,
                  size: 14,
                  color: textSecondaryColor,
                ),
                SizedBox(width: 6),
                Text(
                  'Sesi Terenkripsi & Terlindungi',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: textSecondaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // Header teks kategori menu kapital
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        color: textSecondaryColor,
      ),
    );
  }

  // Profile Card Header sesuai desain Stitch (Avatar dengan badge verified, nama, email student)
  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        gradient: const LinearGradient(
          colors: [
            Color(0xFFEFF6FF), // Soft Blue tint di atas
            Color(0xFFFFFFFF), // Putih solid di bawah
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar dengan Verified Badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2.5),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withValues(alpha: 0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
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
                          size: 32,
                          color: primaryColor,
                        ),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                right: -2,
                bottom: -2,
                child: Container(
                  padding: const EdgeInsets.all(2.5),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    size: 16,
                    color: primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),

          // Info Anggota
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pill Member
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: badgeBgColor,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: primaryColor.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.bolt_rounded, size: 12, color: primaryColor),
                      SizedBox(width: 4),
                      Text(
                        'Archev Digital Store Member',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),

                // Nama Profil
                const Text(
                  'Just Reika',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: textPrimaryColor,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 2),

                // Email Profil
                const Text(
                  'just.reika@archev.com',
                  style: TextStyle(fontSize: 12, color: textSecondaryColor),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Wrapper Container Putih untuk Group Item Menu
  Widget _buildMenuCard({required List<Widget> children}) {
    return Container(
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
      child: Column(children: children),
    );
  }

  // Baris Item Menu
  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    Color? titleColor,
    required String subtitle,
    String? badgeText,
    Color? chevronColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              // Icon Box
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),

              // Title & Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: titleColor ?? textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 11,
                        color: textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),

              // Opsional Badge Pill (misal "2 Baru")
              if (badgeText != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: badgeAlertBgColor,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    badgeText,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: badgeAlertTextColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],

              // Chevron Right
              Icon(
                Icons.chevron_right_rounded,
                color: chevronColor ?? const Color(0xFF94A3B8),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Dialog Informasi Tentang Aplikasi
  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: surfaceColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: const [
              Icon(Icons.info_outline_rounded, color: primaryColor),
              SizedBox(width: 8),
              Text(
                'Tentang Archev Digital Store',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: textPrimaryColor,
                ),
              ),
            ],
          ),
          content: const Text(
            'Archev Digital Store adalah aplikasi e-commerce elektronik konsumen untuk proyek tugas sekolah. Versi saat ini v1.2.0.',
            style: TextStyle(
              fontSize: 13,
              color: textSecondaryColor,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Tutup',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Dialog Bantuan & Panduan
  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: surfaceColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: const [
              Icon(Icons.help_outline_rounded, color: primaryColor),
              SizedBox(width: 8),
              Text(
                'Bantuan & Panduan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: textPrimaryColor,
                ),
              ),
            ],
          ),
          content: const Text(
            'Untuk pertanyaan seputar pemesanan produk, Anda dapat menghubungi toko melalui menu Pesan & Obrolan.',
            style: TextStyle(
              fontSize: 13,
              color: textSecondaryColor,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Mengerti',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Dialog Konfirmasi Logout
  void _showLogoutDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );
        return ScaleTransition(
          scale: Tween<double>(begin: 0.85, end: 1.0).animate(curvedAnimation),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: surfaceColor,
          elevation: 8,
          contentPadding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: const BoxDecoration(
                  color: errorBgColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: errorColor,
                  size: 26,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Konfirmasi Keluar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: textPrimaryColor,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Apakah Anda yakin ingin keluar dari akun Archev Digital Store?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: textSecondaryColor,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        side: const BorderSide(color: borderColor),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        'Batal',
                        style: TextStyle(
                          color: textSecondaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: errorColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        final messenger = ScaffoldMessenger.of(context);
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/login_page',
                          (route) => false,
                        );
                        messenger.showSnackBar(
                          const SnackBar(
                            content: Text('Anda telah keluar dari akun'),
                            backgroundColor: textPrimaryColor,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: const Text(
                        'Keluar',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
