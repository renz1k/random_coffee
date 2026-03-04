import 'package:flutter/material.dart';
import 'package:random_coffee/uikit/theme/app_colors.dart';

class ProductBottomPanel extends StatelessWidget {
  const ProductBottomPanel({
    super.key,
    required this.quantity,
    required this.price,
    this.onPressedPlus,
    this.decrement,
    this.increment,
  });

  final int quantity;
  final int price;
  final VoidCallback? onPressedPlus;
  final VoidCallback? decrement;
  final VoidCallback? increment;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
        child: quantity == 0
            ? InitialPanel(price: price, onPressedPlus: onPressedPlus)
            : QuantityButtons(
                decrement: decrement,
                quantity: quantity,
                increment: increment,
              ),
      ),
    );
  }
}

class QuantityButtons extends StatelessWidget {
  const QuantityButtons({
    super.key,
    required this.decrement,
    required this.quantity,
    required this.increment,
  });

  final VoidCallback? decrement;
  final int quantity;
  final VoidCallback? increment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: AppColors.buttonColor,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: decrement,
            icon: const Icon(Icons.remove, color: Colors.black, size: 24),
          ),
        ),
        Expanded(
          child: Text(
            quantity.toString(),
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: AppColors.buttonColor,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: increment,
            icon: const Icon(Icons.add, color: Colors.black, size: 24),
          ),
        ),
      ],
    );
  }
}

class InitialPanel extends StatelessWidget {
  const InitialPanel({
    super.key,
    required this.price,
    required this.onPressedPlus,
  });

  final int price;

  final VoidCallback? onPressedPlus;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: SizedBox(
            child: Text(
              '$price ₽',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: onPressedPlus,
            icon: const Icon(Icons.add, color: Colors.white, size: 24),
          ),
        ),
      ],
    );
  }
}
