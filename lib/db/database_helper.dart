import 'package:sqflite/sqflite.dart' hide Transaction;
import 'package:path/path.dart';
import '../models/transaction.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'expense_tracker.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDatabase,
      onUpgrade: _upgradeDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transactions (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        amount REAL NOT NULL,
        date INTEGER NOT NULL,
        category TEXT NOT NULL,
        type TEXT NOT NULL,
        paymentMethod TEXT NOT NULL,
        description TEXT,
        imageUrl TEXT,
        isRecurring INTEGER NOT NULL DEFAULT 0,
        recurrenceType TEXT NOT NULL DEFAULT 'none',
        nextRecurrence INTEGER,
        currency TEXT NOT NULL DEFAULT 'USD',
        exchangeRate REAL NOT NULL DEFAULT 1.0,
        createdAt INTEGER NOT NULL,
        updatedAt INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE categories (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        icon TEXT NOT NULL,
        color TEXT NOT NULL,
        type TEXT NOT NULL,
        isCustom INTEGER NOT NULL DEFAULT 0,
        createdAt INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE budgets (
        id TEXT PRIMARY KEY,
        category TEXT NOT NULL,
        amount REAL NOT NULL,
        period TEXT NOT NULL,
        startDate INTEGER NOT NULL,
        endDate INTEGER NOT NULL,
        createdAt INTEGER NOT NULL
      )
    ''');

    // Insert sample data for demo
    await _insertSampleData(db);
  }

  Future<void> _upgradeDatabase(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add new columns for version 2
      await db.execute('ALTER TABLE transactions ADD COLUMN currency TEXT DEFAULT "USD"');
      await db.execute('ALTER TABLE transactions ADD COLUMN exchangeRate REAL DEFAULT 1.0');
    }
  }

  // Insert sample data for demo purposes
  Future<void> _insertSampleData(Database db) async {
    final sampleTransactions = [
      Transaction(
        id: '1',
        title: 'Salary',
        amount: 5000.0,
        date: DateTime.now().subtract(const Duration(days: 1)),
        category: Category.salary,
        type: TransactionType.income,
        paymentMethod: PaymentMethod.bank_transfer,
        description: 'Monthly salary payment',
      ),
      Transaction(
        id: '2',
        title: 'Grocery Shopping',
        amount: 150.0,
        date: DateTime.now().subtract(const Duration(days: 2)),
        category: Category.groceries,
        type: TransactionType.expense,
        paymentMethod: PaymentMethod.credit_card,
        description: 'Weekly grocery shopping',
      ),
      Transaction(
        id: '3',
        title: 'Coffee',
        amount: 5.50,
        date: DateTime.now().subtract(const Duration(days: 3)),
        category: Category.food,
        type: TransactionType.expense,
        paymentMethod: PaymentMethod.cash,
        description: 'Morning coffee',
      ),
      Transaction(
        id: '4',
        title: 'Uber Ride',
        amount: 25.0,
        date: DateTime.now().subtract(const Duration(days: 4)),
        category: Category.transport,
        type: TransactionType.expense,
        paymentMethod: PaymentMethod.digital_wallet,
        description: 'Ride to office',
      ),
      Transaction(
        id: '5',
        title: 'Netflix Subscription',
        amount: 15.99,
        date: DateTime.now().subtract(const Duration(days: 5)),
        category: Category.subscription,
        type: TransactionType.expense,
        paymentMethod: PaymentMethod.credit_card,
        description: 'Monthly Netflix subscription',
        isRecurring: true,
        recurrenceType: RecurrenceType.monthly,
      ),
    ];

    for (var transaction in sampleTransactions) {
      await db.insert('transactions', transaction.toMap());
    }
  }

  // Transaction CRUD operations
  Future<int> insertTransaction(Transaction transaction) async {
    final db = await database;
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final transactionWithId = transaction.copyWith(id: id);
    return await db.insert('transactions', transactionWithId.toMap());
  }

  Future<List<Transaction>> getAllTransactions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) => Transaction.fromMap(maps[i]));
  }

  Future<Transaction?> getTransaction(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Transaction.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateTransaction(Transaction transaction) async {
    final db = await database;
    return await db.update(
      'transactions',
      transaction.copyWith(updatedAt: DateTime.now()).toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  Future<int> deleteTransaction(String id) async {
    final db = await database;
    return await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Advanced query methods
  Future<List<Transaction>> getTransactionsByDateRange(
      DateTime startDate, DateTime endDate) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where: 'date BETWEEN ? AND ?',
      whereArgs: [startDate.millisecondsSinceEpoch, endDate.millisecondsSinceEpoch],
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) => Transaction.fromMap(maps[i]));
  }

  Future<List<Transaction>> getTransactionsByCategory(Category category) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where: 'category = ?',
      whereArgs: [category.name],
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) => Transaction.fromMap(maps[i]));
  }

  Future<List<Transaction>> getTransactionsByType(TransactionType type) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where: 'type = ?',
      whereArgs: [type.name],
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) => Transaction.fromMap(maps[i]));
  }

  // Analytics methods
  Future<double> getTotalIncome() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT SUM(amount * exchangeRate) as total FROM transactions WHERE type = ?',
      ['income'],
    );
    return (result.first['total'] as double?) ?? 0.0;
  }

  Future<double> getTotalExpenses() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT SUM(amount * exchangeRate) as total FROM transactions WHERE type = ?',
      ['expense'],
    );
    return (result.first['total'] as double?) ?? 0.0;
  }

  Future<Map<String, double>> getCategoryWiseSpending() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT category, SUM(amount * exchangeRate) as total FROM transactions WHERE type = ? GROUP BY category',
      ['expense'],
    );
    
    Map<String, double> categorySpending = {};
    for (var row in result) {
      categorySpending[row['category'] as String] = (row['total'] as double?) ?? 0.0;
    }
    return categorySpending;
  }

  Future<Map<String, double>> getMonthlySpending() async {
    final db = await database;
    final result = await db.rawQuery(
      '''SELECT strftime('%Y-%m', datetime(date/1000, 'unixepoch')) as month, 
         SUM(amount * exchangeRate) as total 
         FROM transactions 
         WHERE type = ? 
         GROUP BY month 
         ORDER BY month DESC''',
      ['expense'],
    );
    
    Map<String, double> monthlySpending = {};
    for (var row in result) {
      monthlySpending[row['month'] as String] = (row['total'] as double?) ?? 0.0;
    }
    return monthlySpending;
  }

  // Backup and restore
  Future<List<Map<String, dynamic>>> exportAllData() async {
    final db = await database;
    return await db.query('transactions');
  }

  Future<void> importData(List<Map<String, dynamic>> data) async {
    final db = await database;
    final batch = db.batch();
    
    for (var item in data) {
      batch.insert('transactions', item, conflictAlgorithm: ConflictAlgorithm.replace);
    }
    
    await batch.commit();
  }

  // Clear all data
  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('transactions');
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}