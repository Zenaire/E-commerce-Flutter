import 'package:flutter/material.dart';

class ProductImage extends StatefulWidget {
  final String imageUrl;
  final String fallbackImageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const ProductImage({
    super.key,
    required this.imageUrl,
    required this.fallbackImageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  State<ProductImage> createState() => _ProductImageState();
}

class _ProductImageState extends State<ProductImage> {
  // Tahap pemuatan gambar:
  // 0: Mencoba imageUrl utama
  // 1: Mencoba fallbackImageUrl
  // 2: Fallback lokal (placeholder ikon netral)
  int _loadStage = 0;

  @override
  void didUpdateWidget(covariant ProductImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl ||
        oldWidget.fallbackImageUrl != widget.fallbackImageUrl) {
      _loadStage = 0;
    }
  }

  void _handleError() {
    if (!mounted) return;

    setState(() {
      if (_loadStage == 0) {
        // Jika URL fallback ada dan berbeda dengan URL utama, coba fallback
        if (widget.fallbackImageUrl.isNotEmpty &&
            widget.fallbackImageUrl != widget.imageUrl) {
          _loadStage = 1;
        } else {
          _loadStage = 2; // Langsung ke placeholder lokal
        }
      } else if (_loadStage == 1) {
        _loadStage = 2; // Jika fallback juga gagal, ke placeholder lokal
      }
    });
  }

  Widget _buildPlaceholder() {
    return Container(
      width: widget.width,
      height: widget.height,
      color: const Color(0xFFF1F5F9), // Slate 100 netral
      child: const Center(
        child: Icon(
          Icons.devices_other_rounded,
          color: Color(0xFF94A3B8), // Slate 400
          size: 32,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (_loadStage == 2 ||
        (widget.imageUrl.isEmpty && widget.fallbackImageUrl.isEmpty)) {
      content = _buildPlaceholder();
    } else {
      final String activeUrl = _loadStage == 0
          ? widget.imageUrl
          : widget.fallbackImageUrl;

      if (activeUrl.isEmpty) {
        content = _buildPlaceholder();
      } else {
        content = Image.network(
          activeUrl,
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
          errorBuilder: (context, error, stackTrace) {
            // Mencegah looping berulang dengan memanggil penanganan secara asynchronous
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _handleError();
            });
            return _buildPlaceholder();
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: widget.width,
              height: widget.height,
              color: const Color(0xFFF8FAFC),
              child: const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF2563EB),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }
    }

    if (widget.borderRadius != null) {
      return ClipRRect(borderRadius: widget.borderRadius!, child: content);
    }

    return content;
  }
}
