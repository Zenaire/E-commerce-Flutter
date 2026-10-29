import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _buildNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneOrUsernameController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;

  static const Color primaryColor = Color(0xFF475569);
  static const Color backgroundColor = Color(0xFFF8FAFC);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color textPrimaryColor = Color(0xFF1F2937);
  static const Color textSecondaryColor = Color(0xFF6B7280);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color inputBgColor = Color(0xFFF8FAFC);
  static const Color errorColor = Color(0xFFDC2626);

  @override
  void dispose() {
    _buildNameController.dispose();
    _emailController.dispose();
    _phoneOrUsernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Header: Logo App, Judul & Subjudul
  Widget _buildHeader() {
    return Column(
      children: [
        // App Icon Box dengan aksen lencana kecil di sudut kanan atas
        Center(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withValues(alpha: 0.28),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.bolt_rounded,
                    size: 44,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                right: -4,
                top: -4,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: surfaceColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.bolt_rounded,
                    size: 16,
                    color: primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // Judul Utama
        const Text(
          'Buat Akun',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: textPrimaryColor,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 6),

        // Subjudul
        const Text(
          'Daftar sekarang untuk mulai berbelanja di\nArchev Digital Store',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            color: textSecondaryColor,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  // Input Field Nama Lengkap
  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nama Lengkap',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: textPrimaryColor,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _buildNameController,
          style: const TextStyle(fontSize: 14, color: textPrimaryColor),
          decoration: InputDecoration(
            hintText: 'Nama Lengkap Anda',
            hintStyle: const TextStyle(color: textSecondaryColor, fontSize: 13),
            prefixIcon: const Icon(
              Icons.person_outline_rounded,
              color: textSecondaryColor,
              size: 20,
            ),
            filled: true,
            fillColor: inputBgColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: primaryColor, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: errorColor),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: errorColor, width: 1.5),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Nama tidak boleh kosong';
            }
            return null;
          },
        ),
      ],
    );
  }

  // Input Field Email
  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Email',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: textPrimaryColor,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(fontSize: 14, color: textPrimaryColor),
          decoration: InputDecoration(
            hintText: 'nama@email.com',
            hintStyle: const TextStyle(color: textSecondaryColor, fontSize: 13),
            prefixIcon: const Icon(
              Icons.mail_outline_rounded,
              color: textSecondaryColor,
              size: 20,
            ),
            filled: true,
            fillColor: inputBgColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: primaryColor, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: errorColor),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: errorColor, width: 1.5),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Email tidak boleh kosong';
            }
            if (!RegExp(
              r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$",
            ).hasMatch(value.trim())) {
              return 'Format email tidak valid';
            }
            return null;
          },
        ),
      ],
    );
  }

  // Input Field Nomor Telepon / Username
  Widget _buildPhoneOrUsernameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nomor Telepon / Username',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: textPrimaryColor,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _phoneOrUsernameController,
          style: const TextStyle(fontSize: 14, color: textPrimaryColor),
          decoration: InputDecoration(
            hintText: '08123456789',
            hintStyle: const TextStyle(color: textSecondaryColor, fontSize: 13),
            prefixIcon: const Icon(
              Icons.phone_outlined,
              color: textSecondaryColor,
              size: 20,
            ),
            filled: true,
            fillColor: inputBgColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: primaryColor, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: errorColor),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: errorColor, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  // Input Field Kata Sandi
  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Kata Sandi',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: textPrimaryColor,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _passwordController,
          obscureText: _isPasswordHidden,
          style: const TextStyle(fontSize: 14, color: textPrimaryColor),
          decoration: InputDecoration(
            hintText: 'Minimal 8 karakter',
            hintStyle: const TextStyle(color: textSecondaryColor, fontSize: 13),
            prefixIcon: const Icon(
              Icons.lock_outline_rounded,
              color: textSecondaryColor,
              size: 20,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordHidden
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: textSecondaryColor,
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordHidden = !_isPasswordHidden;
                });
              },
            ),
            filled: true,
            fillColor: inputBgColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: primaryColor, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: errorColor),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: errorColor, width: 1.5),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Kata sandi tidak boleh kosong';
            }
            if (value.length < 6) {
              return 'Kata sandi minimal 6 karakter';
            }
            return null;
          },
        ),
      ],
    );
  }

  // Input Field Konfirmasi Kata Sandi
  Widget _buildConfirmPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Konfirmasi Kata Sandi',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: textPrimaryColor,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: _isConfirmPasswordHidden,
          style: const TextStyle(fontSize: 14, color: textPrimaryColor),
          decoration: InputDecoration(
            hintText: 'Ulangi kata sandi',
            hintStyle: const TextStyle(color: textSecondaryColor, fontSize: 13),
            prefixIcon: const Icon(
              Icons.lock_reset_rounded,
              color: textSecondaryColor,
              size: 20,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _isConfirmPasswordHidden
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: textSecondaryColor,
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  _isConfirmPasswordHidden = !_isConfirmPasswordHidden;
                });
              },
            ),
            filled: true,
            fillColor: inputBgColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: primaryColor, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: errorColor),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: errorColor, width: 1.5),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Konfirmasi kata sandi tidak boleh kosong';
            }
            if (value != _passwordController.text) {
              return 'Konfirmasi kata sandi tidak cocok';
            }
            return null;
          },
        ),
      ],
    );
  }

  // Ketentuan & Kebijakan Privasi
  Widget _buildTermsNotice() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Padding(
          padding: EdgeInsets.only(top: 2),
          child: Icon(Icons.shield_outlined, size: 16, color: primaryColor),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            'Dengan mendaftar, Anda menyetujui Ketentuan Layanan dan Kebijakan Privasi Archev Digital Store Indonesia.',
            style: TextStyle(
              fontSize: 11,
              color: textSecondaryColor,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  // Tombol Submit "Daftar ->"
  Widget _buildSignUpButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
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
        onPressed: () {
          if (_formKey.currentState != null &&
              _formKey.currentState!.validate()) {
            Navigator.pushNamed(context, '/account_page');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Harap periksa kembali form pendaftaran Anda'),
                backgroundColor: errorColor,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Daftar',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward_rounded, size: 18, color: Colors.white),
          ],
        ),
      ),
    );
  }

  // Tautan Navigasi ke Halaman Login
  Widget _buildLoginLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Sudah punya akun? ',
          style: TextStyle(color: textSecondaryColor, fontSize: 13),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/login_page');
          },
          child: const Text(
            'Masuk',
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 24.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 1. Header (Logo, Judul, Subjudul)
                _buildHeader(),
                const SizedBox(height: 24),

                // 2. Kartu Putih Pembungkus Form (Card Surface Elevation L1)
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderColor),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0F172A).withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildNameField(),
                        const SizedBox(height: 16),
                        _buildEmailField(),
                        const SizedBox(height: 16),
                        _buildPhoneOrUsernameField(),
                        const SizedBox(height: 16),
                        _buildPasswordField(),
                        const SizedBox(height: 16),
                        _buildConfirmPasswordField(),
                        const SizedBox(height: 16),
                        _buildTermsNotice(),
                        const SizedBox(height: 22),
                        _buildSignUpButton(context),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 3. Link ke Halaman Login
                _buildLoginLink(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
