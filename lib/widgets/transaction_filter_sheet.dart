import 'package:flutter/material.dart';

class TransactionFilterSheet extends StatefulWidget {
  const TransactionFilterSheet({super.key});

  @override
  State<TransactionFilterSheet> createState() => _TransactionFilterSheetState();
}

class _TransactionFilterSheetState extends State<TransactionFilterSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Filter Transactions',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          // Add filter options here
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Apply Filters'),
          ),
        ],
      ),
    );
  }
}