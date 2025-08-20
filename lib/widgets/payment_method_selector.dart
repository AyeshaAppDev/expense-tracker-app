import 'package:flutter/material.dart';
import '../models/transaction.dart';

class PaymentMethodSelector extends StatelessWidget {
  final PaymentMethod selectedPaymentMethod;
  final Function(PaymentMethod) onPaymentMethodSelected;

  const PaymentMethodSelector({
    super.key,
    required this.selectedPaymentMethod,
    required this.onPaymentMethodSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: PaymentMethod.values.map((method) {
        final isSelected = method == selectedPaymentMethod;
        
        return GestureDetector(
          onTap: () => onPaymentMethodSelected(method),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                  : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).dividerColor,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.payment,
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).colorScheme.outline,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  method.name.replaceAll('_', ' ').toUpperCase(),
                  style: TextStyle(
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).colorScheme.outline,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}