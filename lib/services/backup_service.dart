import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/transaction.dart';
import '../db/database_helper.dart';

class BackupService {
  static Future<void> createBackup() async {
    final transactions = await DatabaseHelper().getAllTransactions();
    
    final backupData = {
      'version': '1.0',
      'created_at': DateTime.now().toIso8601String(),
      'transactions': transactions.map((t) => (t as Transaction).toMap()).toList(),
    };
    
    final jsonString = jsonEncode(backupData);
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/expense_tracker_backup.json');
    await file.writeAsString(jsonString);
    
    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'Expense Tracker Backup',
    );
  }
  
  static Future<bool> restoreBackup(String filePath) async {
    try {
      final file = File(filePath);
      final jsonString = await file.readAsString();
      final backupData = jsonDecode(jsonString);
      
      final transactions = (backupData['transactions'] as List)
          .map((t) => Transaction.fromMap(t))
          .toList();
      
      // Clear existing data and restore
      await DatabaseHelper().clearAllData();
      
      for (final transaction in transactions) {
        await DatabaseHelper().insertTransaction(transaction);
      }
      
      return true;
    } catch (e) {
      return false;
    }
  }
}