import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../db/database_helper.dart';
import '../models/filter_model.dart';

class TransactionProvider with ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  
  List<Transaction> _transactions = [];
  List<Transaction> _filteredTransactions = [];
  FilterModel _currentFilter = FilterModel();
  bool _isLoading = false;
  String _searchQuery = '';
  String _selectedCurrency = 'USD';
  Map<String, double> _exchangeRates = {'USD': 1.0};

  // Getters
  List<Transaction> get transactions => _filteredTransactions;
  List<Transaction> get allTransactions => _transactions;
  FilterModel get currentFilter => _currentFilter;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String get selectedCurrency => _selectedCurrency;
  Map<String, double> get exchangeRates => _exchangeRates;

  // Financial calculations
  double get totalBalance => totalIncome - totalExpenses;
  double get totalIncome => _getFilteredTransactions()
      .where((t) => t.type == TransactionType.income)
      .fold(0.0, (sum, t) => sum + (t.amount * t.exchangeRate));
  double get totalExpenses => _getFilteredTransactions()
      .where((t) => t.type == TransactionType.expense)
      .fold(0.0, (sum, t) => sum + (t.amount * t.exchangeRate));

  // Recent transactions (last 10)
  List<Transaction> get recentTransactions => _transactions
      .where((t) => _matchesCurrentFilter(t))
      .take(10)
      .toList();

  // Category-wise spending
  Map<Category, double> get categoryWiseSpending {
    Map<Category, double> categoryMap = {};
    for (var transaction in _getFilteredTransactions()) {
      if (transaction.type == TransactionType.expense) {
        categoryMap[transaction.category] = 
            (categoryMap[transaction.category] ?? 0) + 
            (transaction.amount * transaction.exchangeRate);
      }
    }
    return categoryMap;
  }

  // Monthly spending data for charts
  Map<String, double> get monthlySpending {
    Map<String, double> monthlyMap = {};
    for (var transaction in _getFilteredTransactions()) {
      if (transaction.type == TransactionType.expense) {
        String monthKey = '${transaction.date.year}-${transaction.date.month.toString().padLeft(2, '0')}';
        monthlyMap[monthKey] = (monthlyMap[monthKey] ?? 0) + 
            (transaction.amount * transaction.exchangeRate);
      }
    }
    return monthlyMap;
  }

  TransactionProvider() {
    loadTransactions();
  }

  // Load all transactions
  Future<void> loadTransactions() async {
    _isLoading = true;
    notifyListeners();

    try {
      _transactions = await _databaseHelper.getAllTransactions();
      _applyFilters();
    } catch (e) {
      debugPrint('Error loading transactions: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add new transaction
  Future<bool> addTransaction(Transaction transaction) async {
    try {
      final id = await _databaseHelper.insertTransaction(transaction);
      if (id > 0) {
        await loadTransactions(); // Reload to get updated data
        return true;
      }
    } catch (e) {
      debugPrint('Error adding transaction: $e');
    }
    return false;
  }

  // Update transaction
  Future<bool> updateTransaction(Transaction transaction) async {
    try {
      final result = await _databaseHelper.updateTransaction(transaction);
      if (result > 0) {
        await loadTransactions();
        return true;
      }
    } catch (e) {
      debugPrint('Error updating transaction: $e');
    }
    return false;
  }

  // Delete transaction
  Future<bool> deleteTransaction(String id) async {
    try {
      final result = await _databaseHelper.deleteTransaction(id);
      if (result > 0) {
        await loadTransactions();
        return true;
      }
    } catch (e) {
      debugPrint('Error deleting transaction: $e');
    }
    return false;
  }

  // Search transactions
  void searchTransactions(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
    notifyListeners();
  }

  // Apply filters
  void applyFilter(FilterModel filter) {
    _currentFilter = filter;
    _applyFilters();
    notifyListeners();
  }

  // Clear filters
  void clearFilters() {
    _currentFilter = FilterModel();
    _searchQuery = '';
    _applyFilters();
    notifyListeners();
  }

  // Set currency
  void setCurrency(String currency) {
    _selectedCurrency = currency;
    notifyListeners();
  }

  // Update exchange rates
  void updateExchangeRates(Map<String, double> rates) {
    _exchangeRates = rates;
    notifyListeners();
  }

  // Private methods
  void _applyFilters() {
    _filteredTransactions = _transactions.where((transaction) {
      return _matchesCurrentFilter(transaction) && _matchesSearchQuery(transaction);
    }).toList();

    // Sort by date (newest first)
    _filteredTransactions.sort((a, b) => b.date.compareTo(a.date));
  }

  bool _matchesCurrentFilter(Transaction transaction) {
    // Date range filter
    if (_currentFilter.startDate != null && 
        transaction.date.isBefore(_currentFilter.startDate!)) {
      return false;
    }
    if (_currentFilter.endDate != null && 
        transaction.date.isAfter(_currentFilter.endDate!)) {
      return false;
    }

    // Category filter
    if (_currentFilter.categories.isNotEmpty && 
        !_currentFilter.categories.contains(transaction.category)) {
      return false;
    }

    // Transaction type filter
    if (_currentFilter.transactionTypes.isNotEmpty && 
        !_currentFilter.transactionTypes.contains(transaction.type)) {
      return false;
    }

    // Amount range filter
    if (_currentFilter.minAmount != null && 
        transaction.amount < _currentFilter.minAmount!) {
      return false;
    }
    if (_currentFilter.maxAmount != null && 
        transaction.amount > _currentFilter.maxAmount!) {
      return false;
    }

    // Payment method filter
    if (_currentFilter.paymentMethods.isNotEmpty && 
        !_currentFilter.paymentMethods.contains(transaction.paymentMethod)) {
      return false;
    }

    return true;
  }

  bool _matchesSearchQuery(Transaction transaction) {
    if (_searchQuery.isEmpty) return true;
    
    return transaction.title.toLowerCase().contains(_searchQuery) ||
           transaction.description?.toLowerCase().contains(_searchQuery) == true ||
           transaction.category.name.toLowerCase().contains(_searchQuery) ||
           transaction.paymentMethod.name.toLowerCase().contains(_searchQuery);
  }

  List<Transaction> _getFilteredTransactions() {
    return _filteredTransactions;
  }

  // Get transactions by date range
  List<Transaction> getTransactionsByDateRange(DateTime start, DateTime end) {
    return _transactions.where((t) => 
        t.date.isAfter(start.subtract(const Duration(days: 1))) &&
        t.date.isBefore(end.add(const Duration(days: 1)))
    ).toList();
  }

  // Get transactions by category
  List<Transaction> getTransactionsByCategory(Category category) {
    return _transactions.where((t) => t.category == category).toList();
  }

  // Export data methods
  Future<List<Map<String, dynamic>>> getExportData() async {
    return _filteredTransactions.map((t) => t.toMap()).toList();
  }
}