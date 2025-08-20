import 'package:flutter/material.dart';
import '../models/transaction.dart';

class CategorySelector extends StatelessWidget {
  final Category selectedCategory;
  final TransactionType transactionType;
  final Function(Category) onCategorySelected;

  const CategorySelector({
    super.key,
    required this.selectedCategory,
    required this.transactionType,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final categories = transactionType == TransactionType.income
        ? [
            Category.salary,
            Category.freelance,
            Category.investment,
            Category.business,
            Category.gift,
            Category.bonus,
            Category.rental,
            Category.other_income,
          ]
        : [
            Category.food,
            Category.transport,
            Category.shopping,
            Category.bills,
            Category.healthcare,
            Category.entertainment,
            Category.travel,
            Category.education,
            Category.groceries,
            Category.fuel,
            Category.insurance,
            Category.subscription,
            Category.charity,
            Category.other_expense,
          ];

    return SizedBox(
      height: 120,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selectedCategory;
          
          return GestureDetector(
            onTap: () => onCategorySelected(category),
            child: Container(
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).primaryColor.withValues(alpha: 0.2)
                    : Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).dividerColor,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.category,
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).colorScheme.outline,
                    size: 24,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category.name.replaceAll('_', ' ').toUpperCase(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).colorScheme.outline,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}