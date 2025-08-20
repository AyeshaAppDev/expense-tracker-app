import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/transaction_provider.dart';
import '../models/transaction.dart';
import '../widgets/transaction_filter_sheet.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/recent_transactions_list.dart';
import 'add_transaction_screen.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Transactions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: _showFilterSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchBarWidget(
              controller: _searchController,
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),
          ),
          
          // Active Filters - Simplified for now
          const SizedBox.shrink(),
          
          // Transactions List
          Expanded(
            child: Consumer<TransactionProvider>(
              builder: (context, provider, child) {
                final transactions = provider.transactions
                    .where((t) => _searchQuery.isEmpty || 
                          t.title.toLowerCase().contains(_searchQuery.toLowerCase()))
                    .toList();
                
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (transactions.isEmpty) {
                  return _buildEmptyState();
                }
                
                return RefreshIndicator(
                  onRefresh: () => provider.loadTransactions(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: GestureDetector(
                          onTap: () => _editTransaction(transaction),
                          child: TransactionListTile(
                            transaction: transaction,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isEmpty ? 'No transactions found' : 'No results for "$_searchQuery"',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isEmpty
                ? 'Add your first transaction to get started'
                : 'Try adjusting your search or filters',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const TransactionFilterSheet(),
    );
  }

  void _editTransaction(Transaction transaction) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTransactionScreen(transaction: transaction),
      ),
    );
  }
}