import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../providers/transaction_provider.dart';
import '../widgets/category_selector.dart';
import '../widgets/payment_method_selector.dart';

class AddTransactionScreen extends StatefulWidget {
  final Transaction? transaction;
  
  const AddTransactionScreen({super.key, this.transaction});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  TransactionType _selectedType = TransactionType.expense;
  Category _selectedCategory = Category.food;
  PaymentMethod _selectedPaymentMethod = PaymentMethod.cash;
  DateTime _selectedDate = DateTime.now();
  bool _isRecurring = false;
  RecurrenceType _recurrenceType = RecurrenceType.monthly;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeForm();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _animationController.forward();
  }

  void _initializeForm() {
    if (widget.transaction != null) {
      final transaction = widget.transaction!;
      _titleController.text = transaction.title;
      _amountController.text = transaction.amount.toString();
      _descriptionController.text = transaction.description ?? '';
      _selectedType = transaction.type;
      _selectedCategory = transaction.category;
      _selectedPaymentMethod = transaction.paymentMethod;
      _selectedDate = transaction.date;
      _isRecurring = transaction.isRecurring;
      _recurrenceType = transaction.recurrenceType;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _titleController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.transaction != null;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Transaction' : 'Add Transaction'),
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete_rounded),
              onPressed: _showDeleteDialog,
            ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Transaction Type Toggle
                  _buildTransactionTypeToggle(),
                  const SizedBox(height: 24),
                  
                  // Amount Input
                  _buildAmountInput(),
                  const SizedBox(height: 20),
                  
                  // Title Input
                  _buildTitleInput(),
                  const SizedBox(height: 20),
                  
                  // Category Selector
                  _buildCategorySelector(),
                  const SizedBox(height: 20),
                  
                  // Payment Method Selector
                  _buildPaymentMethodSelector(),
                  const SizedBox(height: 20),
                  
                  // Date Picker
                  _buildDatePicker(),
                  const SizedBox(height: 20),
                  
                  // Description Input
                  _buildDescriptionInput(),
                  const SizedBox(height: 20),
                  
                  // Recurring Options
                  _buildRecurringOptions(),
                  const SizedBox(height: 32),
                  
                  // Save Button
                  _buildSaveButton(isEditing),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionTypeToggle() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedType = TransactionType.expense),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: _selectedType == TransactionType.expense
                        ? Colors.red.withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: _selectedType == TransactionType.expense
                        ? Border.all(color: Colors.red, width: 2)
                        : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.trending_down_rounded,
                        color: _selectedType == TransactionType.expense
                            ? Colors.red
                            : Theme.of(context).colorScheme.outline,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Expense',
                        style: TextStyle(
                          color: _selectedType == TransactionType.expense
                              ? Colors.red
                              : Theme.of(context).colorScheme.outline,
                          fontWeight: _selectedType == TransactionType.expense
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedType = TransactionType.income),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: _selectedType == TransactionType.income
                        ? Colors.green.withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: _selectedType == TransactionType.income
                        ? Border.all(color: Colors.green, width: 2)
                        : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.trending_up_rounded,
                        color: _selectedType == TransactionType.income
                            ? Colors.green
                            : Theme.of(context).colorScheme.outline,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Income',
                        style: TextStyle(
                          color: _selectedType == TransactionType.income
                              ? Colors.green
                              : Theme.of(context).colorScheme.outline,
                          fontWeight: _selectedType == TransactionType.income
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountInput() {
    return TextFormField(
      controller: _amountController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
      ],
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: _selectedType == TransactionType.income ? Colors.green : Colors.red,
      ),
      decoration: InputDecoration(
        labelText: 'Amount',
        prefixText: '\$ ',
        prefixStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: _selectedType == TransactionType.income ? Colors.green : Colors.red,
        ),
        border: const OutlineInputBorder(),
        filled: true,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter an amount';
        }
        final amount = double.tryParse(value);
        if (amount == null || amount <= 0) {
          return 'Please enter a valid amount';
        }
        return null;
      },
    );
  }

  Widget _buildTitleInput() {
    return TextFormField(
      controller: _titleController,
      textCapitalization: TextCapitalization.words,
      decoration: const InputDecoration(
        labelText: 'Title',
        border: OutlineInputBorder(),
        filled: true,
        prefixIcon: Icon(Icons.title_rounded),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter a title';
        }
        if (value.trim().length < 3) {
          return 'Title must be at least 3 characters';
        }
        return null;
      },
    );
  }

  Widget _buildCategorySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        CategorySelector(
          selectedCategory: _selectedCategory,
          transactionType: _selectedType,
          onCategorySelected: (category) {
            setState(() => _selectedCategory = category);
          },
        ),
      ],
    );
  }

  Widget _buildPaymentMethodSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Method',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        PaymentMethodSelector(
          selectedPaymentMethod: _selectedPaymentMethod,
          onPaymentMethodSelected: (method) {
            setState(() => _selectedPaymentMethod = method);
          },
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.calendar_today_rounded),
        title: const Text('Date'),
        subtitle: Text(DateFormat('EEEE, MMMM d, y').format(_selectedDate)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded),
        onTap: _selectDate,
      ),
    );
  }

  Widget _buildDescriptionInput() {
    return TextFormField(
      controller: _descriptionController,
      maxLines: 3,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        labelText: 'Description (Optional)',
        border: OutlineInputBorder(),
        filled: true,
        prefixIcon: Icon(Icons.notes_rounded),
        alignLabelWithHint: true,
      ),
    );
  }

  Widget _buildRecurringOptions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.repeat_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Recurring Transaction',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Switch(
                  value: _isRecurring,
                  onChanged: (value) => setState(() => _isRecurring = value),
                ),
              ],
            ),
            if (_isRecurring) ...[
              const SizedBox(height: 16),
              DropdownButtonFormField<RecurrenceType>(
                value: _recurrenceType,
                decoration: const InputDecoration(
                  labelText: 'Frequency',
                  border: OutlineInputBorder(),
                ),
                items: RecurrenceType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.displayName),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _recurrenceType = value);
                  }
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton(bool isEditing) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _saveTransaction,
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(
                isEditing ? 'Update Transaction' : 'Add Transaction',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  Future<void> _saveTransaction() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final transaction = Transaction(
        id: widget.transaction?.id,
        title: _titleController.text.trim(),
        amount: double.parse(_amountController.text),
        type: _selectedType,
        category: _selectedCategory,
        paymentMethod: _selectedPaymentMethod,
        date: _selectedDate,
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        isRecurring: _isRecurring,
        recurrenceType: _recurrenceType,
        nextRecurrence: _isRecurring
            ? _calculateNextRecurrence(_selectedDate, _recurrenceType)
            : null,
        currency: 'USD',
        exchangeRate: 1.0,
        createdAt: widget.transaction?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final provider = context.read<TransactionProvider>();
      
      if (widget.transaction != null) {
        await provider.updateTransaction(transaction);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Transaction updated successfully')),
          );
        }
      } else {
        await provider.addTransaction(transaction);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Transaction added successfully')),
          );
        }
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  DateTime _calculateNextRecurrence(DateTime date, RecurrenceType type) {
    switch (type) {
      case RecurrenceType.daily:
        return date.add(const Duration(days: 1));
      case RecurrenceType.weekly:
        return date.add(const Duration(days: 7));
      case RecurrenceType.monthly:
        return DateTime(date.year, date.month + 1, date.day);
      case RecurrenceType.yearly:
        return DateTime(date.year + 1, date.month, date.day);
      case RecurrenceType.none:
        return date; // No recurrence, return the same date
    }
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Transaction'),
        content: const Text('Are you sure you want to delete this transaction?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await context.read<TransactionProvider>()
                  .deleteTransaction(widget.transaction!.id!);
              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Transaction deleted')),
                );
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}