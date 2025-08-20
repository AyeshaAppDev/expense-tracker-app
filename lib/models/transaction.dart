import 'package:intl/intl.dart';

enum TransactionType { income, expense }

enum Category {
  // Income Categories
  salary,
  freelance,
  investment,
  business,
  gift,
  bonus,
  rental,
  other_income,
  
  // Expense Categories
  food,
  transport,
  shopping,
  bills,
  healthcare,
  entertainment,
  travel,
  education,
  groceries,
  fuel,
  insurance,
  subscription,
  charity,
  other_expense,
}

enum PaymentMethod {
  cash,
  credit_card,
  debit_card,
  bank_transfer,
  digital_wallet,
  upi,
  cheque,
  other,
}

enum RecurrenceType {
  none,
  daily,
  weekly,
  monthly,
  yearly,
}

extension RecurrenceTypeExtension on RecurrenceType {
  String get displayName {
    switch (this) {
      case RecurrenceType.none:
        return 'None';
      case RecurrenceType.daily:
        return 'Daily';
      case RecurrenceType.weekly:
        return 'Weekly';
      case RecurrenceType.monthly:
        return 'Monthly';
      case RecurrenceType.yearly:
        return 'Yearly';
    }
  }
}

class Transaction {
  final String? id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;
  final TransactionType type;
  final PaymentMethod paymentMethod;
  final String? description;
  final String? imageUrl;
  final bool isRecurring;
  final RecurrenceType recurrenceType;
  final DateTime? nextRecurrence;
  final String currency;
  final double exchangeRate;
  final DateTime createdAt;
  final DateTime updatedAt;

  Transaction({
    this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.type,
    this.paymentMethod = PaymentMethod.cash,
    this.description,
    this.imageUrl,
    this.isRecurring = false,
    this.recurrenceType = RecurrenceType.none,
    this.nextRecurrence,
    this.currency = 'USD',
    this.exchangeRate = 1.0,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  // Convert to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.millisecondsSinceEpoch,
      'category': category.name,
      'type': type.name,
      'paymentMethod': paymentMethod.name,
      'description': description,
      'imageUrl': imageUrl,
      'isRecurring': isRecurring ? 1 : 0,
      'recurrenceType': recurrenceType.name,
      'nextRecurrence': nextRecurrence?.millisecondsSinceEpoch,
      'currency': currency,
      'exchangeRate': exchangeRate,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  // Create from Map (database)
  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id']?.toString(),
      title: map['title'] ?? '',
      amount: (map['amount'] ?? 0.0).toDouble(),
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] ?? 0),
      category: Category.values.firstWhere(
        (e) => e.name == map['category'],
        orElse: () => Category.other_expense,
      ),
      type: TransactionType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => TransactionType.expense,
      ),
      paymentMethod: PaymentMethod.values.firstWhere(
        (e) => e.name == map['paymentMethod'],
        orElse: () => PaymentMethod.cash,
      ),
      description: map['description'],
      imageUrl: map['imageUrl'],
      isRecurring: (map['isRecurring'] ?? 0) == 1,
      recurrenceType: RecurrenceType.values.firstWhere(
        (e) => e.name == map['recurrenceType'],
        orElse: () => RecurrenceType.none,
      ),
      nextRecurrence: map['nextRecurrence'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['nextRecurrence'])
          : null,
      currency: map['currency'] ?? 'USD',
      exchangeRate: (map['exchangeRate'] ?? 1.0).toDouble(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] ?? 0),
    );
  }

  // Copy with method for updates
  Transaction copyWith({
    String? id,
    String? title,
    double? amount,
    DateTime? date,
    Category? category,
    TransactionType? type,
    PaymentMethod? paymentMethod,
    String? description,
    String? imageUrl,
    bool? isRecurring,
    RecurrenceType? recurrenceType,
    DateTime? nextRecurrence,
    String? currency,
    double? exchangeRate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Transaction(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
      type: type ?? this.type,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      isRecurring: isRecurring ?? this.isRecurring,
      recurrenceType: recurrenceType ?? this.recurrenceType,
      nextRecurrence: nextRecurrence ?? this.nextRecurrence,
      currency: currency ?? this.currency,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  // Formatted amount with currency
  String get formattedAmount {
    final formatter = NumberFormat.currency(symbol: getCurrencySymbol(currency));
    return formatter.format(amount);
  }

  // Formatted date
  String get formattedDate {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  // Category display name
  String get categoryDisplayName {
    return category.name.replaceAll('_', ' ').toUpperCase();
  }

  // Payment method display name
  String get paymentMethodDisplayName {
    return paymentMethod.name.replaceAll('_', ' ').toUpperCase();
  }

  // Get currency symbol
  static String getCurrencySymbol(String currency) {
    switch (currency) {
      case 'USD': return '\$';
      case 'EUR': return '€';
      case 'GBP': return '£';
      case 'INR': return '₹';
      case 'JPY': return '¥';
      case 'CNY': return '¥';
      case 'CAD': return 'C\$';
      case 'AUD': return 'A\$';
      default: return currency;
    }
  }

  @override
  String toString() {
    return 'Transaction(id: \$id, title: \$title, amount: \$amount, type: \$type)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Transaction && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

// Extension for category icons
extension CategoryExtension on Category {
  String get icon {
    switch (this) {
      case Category.salary: return '💼';
      case Category.freelance: return '💻';
      case Category.investment: return '📈';
      case Category.business: return '🏢';
      case Category.gift: return '🎁';
      case Category.bonus: return '💰';
      case Category.rental: return '🏠';
      case Category.other_income: return '💵';
      case Category.food: return '🍽️';
      case Category.transport: return '🚗';
      case Category.shopping: return '🛍️';
      case Category.bills: return '📄';
      case Category.healthcare: return '🏥';
      case Category.entertainment: return '🎬';
      case Category.travel: return '✈️';
      case Category.education: return '📚';
      case Category.groceries: return '🛒';
      case Category.fuel: return '⛽';
      case Category.insurance: return '🛡️';
      case Category.subscription: return '📱';
      case Category.charity: return '❤️';
      case Category.other_expense: return '💸';
    }
  }
}

// Extension for payment method icons
extension PaymentMethodExtension on PaymentMethod {
  String get icon {
    switch (this) {
      case PaymentMethod.cash: return '💵';
      case PaymentMethod.credit_card: return '💳';
      case PaymentMethod.debit_card: return '💳';
      case PaymentMethod.bank_transfer: return '🏦';
      case PaymentMethod.digital_wallet: return '📱';
      case PaymentMethod.upi: return '📲';
      case PaymentMethod.cheque: return '📝';
      case PaymentMethod.other: return '💰';
    }
  }
}