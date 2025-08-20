import 'transaction.dart';

class FilterModel {
  DateTime? startDate;
  DateTime? endDate;
  List<Category> categories;
  List<TransactionType> transactionTypes;
  List<PaymentMethod> paymentMethods;
  double? minAmount;
  double? maxAmount;
  String? searchQuery;

  FilterModel({
    this.startDate,
    this.endDate,
    this.categories = const [],
    this.transactionTypes = const [],
    this.paymentMethods = const [],
    this.minAmount,
    this.maxAmount,
    this.searchQuery,
  });

  // Check if any filters are applied
  bool get hasActiveFilters {
    return startDate != null ||
           endDate != null ||
           categories.isNotEmpty ||
           transactionTypes.isNotEmpty ||
           paymentMethods.isNotEmpty ||
           minAmount != null ||
           maxAmount != null ||
           (searchQuery?.isNotEmpty ?? false);
  }

  // Clear all filters
  FilterModel clear() {
    return FilterModel();
  }

  // Copy with method
  FilterModel copyWith({
    DateTime? startDate,
    DateTime? endDate,
    List<Category>? categories,
    List<TransactionType>? transactionTypes,
    List<PaymentMethod>? paymentMethods,
    double? minAmount,
    double? maxAmount,
    String? searchQuery,
  }) {
    return FilterModel(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      categories: categories ?? this.categories,
      transactionTypes: transactionTypes ?? this.transactionTypes,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      minAmount: minAmount ?? this.minAmount,
      maxAmount: maxAmount ?? this.maxAmount,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}