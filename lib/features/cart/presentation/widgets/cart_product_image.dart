import 'dart:async';

import 'package:flutter/material.dart';
import 'package:random_coffee/core/constants/app_constants.dart';
import 'package:random_coffee/features/cart/presentation/widgets/cart_product_placeholder.dart';
import 'package:random_coffee/uikit/theme/app_colors.dart';

class CartProductImage extends StatefulWidget {
  const CartProductImage({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  State<CartProductImage> createState() => _CartProductImageState();
}

class _CartProductImageState extends State<CartProductImage> {
  bool _showPlaceholder = false;
  bool _imageLoaded = false;
  Timer? _timeoutTimer;

  @override
  void initState() {
    super.initState();
    _timeoutTimer = Timer(AppConstants.imageTimeout, () {
      if (mounted && !_imageLoaded) {
        setState(() => _showPlaceholder = true);
      }
    });
  }

  @override
  void dispose() {
    _timeoutTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    if (_showPlaceholder || widget.imageUrl.isEmpty) {
      return const CartProductPlaceholder();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      child: Image.network(
        widget.imageUrl.replaceFirst('https://', 'http://'),
        width: AppConstants.cartProductImageSize,
        height: AppConstants.cartProductImageSize,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            _imageLoaded = true;
            _timeoutTimer?.cancel();
            return child;
          }
          return Container(
            width: AppConstants.cartProductImageSize,
            height: AppConstants.cartProductImageSize,
            decoration: BoxDecoration(
              color: isLight ? AppColors.dividerLight : AppColors.dividerDark,
              borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
            ),
            child: const Center(
              child: SizedBox(
                width: AppConstants.iconSizeSmall,
                height: AppConstants.iconSizeSmall,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return const CartProductPlaceholder();
        },
      ),
    );
  }
}
