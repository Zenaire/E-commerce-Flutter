import 'package:flutter/material.dart';

class ChangePassPage extends StatefulWidget {
  const ChangePassPage({super.key});

  @override
  State<ChangePassPage> createState() => _ChangePassPageState();
}

class _ChangePassPageState extends State<ChangePassPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _currentPasswdController =
      TextEditingController();
  final TextEditingController _newPasswdController = TextEditingController();
  final TextEditingController _confirmPasswdController =
      TextEditingController();

  bool _isCurrentPasswordHidden = true;
  bool _isNewPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;

  static const Color primaryColor = Color(0xFF475569);
  static const Color backgroundColor = Color(0xFFF8FAFC);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color textPrimaryColor = Color(0xFF1F2937);
  static const Color textSecondaryColor = Color(0xFF6B7280);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color badgeBgColor = Color(0xFFF8FAFC);
  static const Color successColor = Color(0xFF16A34A);
  static const Color errorColor = Color(0xFFDC2626);

  @override
  void initState() {
    super.initState();
    // Re-render saat password baru diketik untuk memperbarui indikator kekuatan sandi
    _newPasswdController.addListener(_onNewPasswordChanged);
  }

  void _onNewPasswordChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _newPasswdController.removeListener(_onNewPasswordChanged);
    _currentPasswdController.dispose();
    _newPasswdController.dispose();
    _confirmPasswdController.dispose();
    super.dispose();
  }

  // Evaluasi kekuatan kata sandi
  bool get _hasMin8Chars => _newPasswdController.text.length >= 8;
  bool get _hasAlphaNum {
    final text = _newPasswdController.text;
    final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(text);
    final hasNumber = RegExp(r'[0-9]').hasMatch(text);
    return hasLetter && hasNumber;
  }

  int get _passwordStrengthScore {
    final text = _newPasswdController.text;
    if (text.isEmpty) return 0;
    int score = 0;
    if (text.length >= 6) score++;
    if (_hasMin8Chars) score++;
    if (_hasAlphaNum) score++;
    return score; // 0..3
  }

  String get _passwordStrengthLabel {
    final text = _newPasswdController.text;
    if (text.isEmpty) return 'Belum terisi';
    final score = _passwordStrengthScore;
    if (score == 1) return 'Lemah';
    if (score == 2) return 'Sedang';
    return 'Kuat';
  }

  Color get _passwordStrengthColor {
    final score = _passwordStrengthScore;
    if (score == 0) return const Color(0xFFCBD5E1);
    if (score == 1) return errorColor;
    if (score == 2) return const Color(0xFFF59E0B); // Amber
    return successColor;
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
              'Change Password',
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Kartu Banner Edukasi Keamanan
                _buildSecurityBanner(),
                const SizedBox(height: 20),

                // 2. Input Field: Kata Sandi Saat Ini
                _buildFieldLabel('Kata Sandi Saat Ini'),
                const SizedBox(height: 8),
                _buildPasswordField(
                  controller: _currentPasswdController,
                  hintText: '••••••••',
                  prefixIcon: Icons.lock_outline_rounded,
                  isHidden: _isCurrentPasswordHidden,
                  onToggleVisibility: () {
                    setState(() {
                      _isCurrentPasswordHidden = !_isCurrentPasswordHidden;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Kata sandi saat ini tidak boleh kosong';
                    }
                    if (value.length < 6) {
                      return 'Kata sandi minimal 6 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // 3. Input Field: Kata Sandi Baru
                _buildFieldLabel('Kata Sandi Baru'),
                const SizedBox(height: 8),
                _buildPasswordField(
                  controller: _newPasswdController,
                  hintText: '••••••••',
                  prefixIcon: Icons.key_rounded,
                  isHidden: _isNewPasswordHidden,
                  onToggleVisibility: () {
                    setState(() {
                      _isNewPasswordHidden = !_isNewPasswordHidden;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Kata sandi baru tidak boleh kosong';
                    }
                    if (value.length < 6) {
                      return 'Kata sandi minimal 6 karakter';
                    }
                    if (value == _currentPasswdController.text) {
                      return 'Kata sandi baru tidak boleh sama dengan kata sandi saat ini';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 6),
                const Text(
                  'Minimal 8 karakter termasuk huruf & angka',
                  style: TextStyle(fontSize: 11, color: textSecondaryColor),
                ),
                const SizedBox(height: 14),

                // 4. Kartu Indikator Kekuatan Kata Sandi
                _buildStrengthCard(),
                const SizedBox(height: 20),

                // 5. Input Field: Konfirmasi Kata Sandi Baru
                _buildFieldLabel('Konfirmasi Kata Sandi Baru'),
                const SizedBox(height: 8),
                _buildPasswordField(
                  controller: _confirmPasswdController,
                  hintText: '••••••••',
                  prefixIcon: Icons.shield_outlined,
                  isHidden: _isConfirmPasswordHidden,
                  onToggleVisibility: () {
                    setState(() {
                      _isConfirmPasswordHidden = !_isConfirmPasswordHidden;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Konfirmasi kata sandi tidak boleh kosong';
                    }
                    if (value != _newPasswdController.text) {
                      return 'Konfirmasi kata sandi tidak cocok';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 28),

                // 6. Tombol Submit "Simpan Kata Sandi"
                _buildSubmitButton(),
                const SizedBox(height: 12),

                // 7. Tombol Batal
                _buildCancelButton(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Banner Informasi Edukasi Keamanan
  Widget _buildSecurityBanner() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        gradient: const LinearGradient(
          colors: [
            Color(0xFFEFF6FF), // Soft Blue Accent
            Color(0xFFFFFFFF),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: primaryColor,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(Icons.shield_rounded, color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Keamanan Akun Prioritas Kami',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: textPrimaryColor,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Demi keamanan akun Archev Digital Store Anda, gunakan kombinasi kata sandi yang kuat dan jangan bagikan kepada siapapun.',
                  style: TextStyle(
                    fontSize: 12,
                    color: textSecondaryColor,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Label teks input
  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: textPrimaryColor,
      ),
    );
  }

  // Field Reusable Kata Sandi
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    required bool isHidden,
    required VoidCallback onToggleVisibility,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isHidden,
      style: const TextStyle(fontSize: 14, color: textPrimaryColor),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: textSecondaryColor, fontSize: 13),
        prefixIcon: Icon(prefixIcon, color: textSecondaryColor, size: 20),
        suffixIcon: IconButton(
          icon: Icon(
            isHidden
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: textSecondaryColor,
            size: 20,
          ),
          onPressed: onToggleVisibility,
        ),
        filled: true,
        fillColor: surfaceColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor, width: 1.5),
        ),
      ),
      validator: validator,
    );
  }

  // Kartu Indikator Kekuatan Sandi & Checklist Sesuai Stitch
  Widget _buildStrengthCard() {
    final score = _passwordStrengthScore;
    final color = _passwordStrengthColor;

    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: badgeBgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Kekuatan Sandi',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: textPrimaryColor,
                ),
              ),
              Text(
                _passwordStrengthLabel,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // 3 Bar Indikator Kekuatan
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: score >= 1 ? color : const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: score >= 2 ? color : const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: score >= 3 ? color : const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Checklist 1: Minimal 8 karakter
          Row(
            children: [
              Icon(
                _hasMin8Chars
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
                size: 16,
                color: _hasMin8Chars ? successColor : textSecondaryColor,
              ),
              const SizedBox(width: 8),
              Text(
                'Minimal 8 karakter',
                style: TextStyle(
                  fontSize: 11,
                  color: _hasMin8Chars ? textPrimaryColor : textSecondaryColor,
                  fontWeight: _hasMin8Chars
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Checklist 2: Mengandung kombinasi huruf & angka
          Row(
            children: [
              Icon(
                _hasAlphaNum
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
                size: 16,
                color: _hasAlphaNum ? successColor : textSecondaryColor,
              ),
              const SizedBox(width: 8),
              Text(
                'Mengandung kombinasi huruf & angka',
                style: TextStyle(
                  fontSize: 11,
                  color: _hasAlphaNum ? textPrimaryColor : textSecondaryColor,
                  fontWeight: _hasAlphaNum
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Tombol Submit Utama: "✓ Simpan Kata Sandi"
  Widget _buildSubmitButton() {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: _handlePassChange,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.check_rounded, size: 18, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Simpan Kata Sandi',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Tombol Batal
  Widget _buildCancelButton() {
    return SizedBox(
      height: 48,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimaryColor,
          elevation: 0,
          side: const BorderSide(color: borderColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () => Navigator.pop(context),
        child: const Text(
          'Batal',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textPrimaryColor,
          ),
        ),
      ),
    );
  }

  // Penanganan Submit Form & Dialog Konfirmasi Berhasil
  void _handlePassChange() {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _showSuccessDialog();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap periksa kembali isian kata sandi Anda'),
          backgroundColor: errorColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // Dialog Sukses Diperbarui
  void _showSuccessDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
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
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: Color(0xFFDCFCE7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: successColor,
                  size: 34,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Berhasil Diperbarui!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: textPrimaryColor,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Kata sandi Anda telah berhasil diubah secara lokal. Silakan gunakan kata sandi baru untuk sesi Anda.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: textSecondaryColor,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Kembali ke Akun',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
