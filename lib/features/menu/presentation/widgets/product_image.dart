import 'dart:async';

import 'package:flutter/material.dart';
import 'package:random_coffee/features/menu/domain/entities/product.dart';
import 'package:random_coffee/uikit/theme/app_colors.dart';

class ProductImage extends StatefulWidget {
  const ProductImage({
    super.key,
    required this.product,
    required this.placeholder,
    required this.height,
    this.color,
  });

  final Product product;
  final Widget placeholder;
  final double? height;
  final Color? color;

  @override
  State<ProductImage> createState() => _ProductImageState();
}

class _ProductImageState extends State<ProductImage> {
  bool _showPlaceholder = false;
  bool _imageLoaded = false;
  Timer? _timeoutTimer;

  @override
  void initState() {
    super.initState();
    if (widget.product.imageUrl.isNotEmpty) {
      _timeoutTimer = Timer(const Duration(seconds: 10), () {
        if (mounted && !_imageLoaded) {
          setState(() => _showPlaceholder = true);
        }
      });
    }
  }

  @override
  void dispose() {
    _timeoutTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showPlaceholder || widget.product.imageUrl.isEmpty) {
      return SizedBox(
        height: widget.height,
        width: double.infinity,
        child: widget.placeholder,
      );
    }

    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: ClipRRect(
        child: Image.network(
          widget.product.imageUrl.replaceFirst('https://', 'http://'),
          fit: BoxFit.contain,
          width: double.infinity,
          height: widget.height,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              _imageLoaded = true;
              _timeoutTimer?.cancel();
              return child;
            }
            return Container(
              height: widget.height,
              color: widget.color,
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) => widget.placeholder,
        ),
      ),
    );
  }
}
