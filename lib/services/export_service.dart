import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:csv/csv.dart';
import '../models/transaction.dart';

class ExportService {
  static Future<void> exportToPDF(List<Transaction> transactions) async {
    final pdf = pw.Document();
    
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Text('Expense Tracker Report'),
            ),
            pw.Table.fromTextArray(
              headers: ['Date', 'Title', 'Category', 'Amount', 'Type'],
              data: transactions.map((t) => [
                t.date.toString().split(' ')[0],
                t.title,
                t.categoryDisplayName,
                '\$${t.amount.toStringAsFixed(2)}',
                t.type.name.toUpperCase(),
              ]).toList(),
            ),
          ];
        },
      ),
    );
    
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
  
  static Future<void> exportToCSV(List<Transaction> transactions) async {
    final List<List<dynamic>> csvData = [
      ['Date', 'Title', 'Category', 'Amount', 'Type', 'Payment Method', 'Description'],
      ...transactions.map((t) => [
        t.date.toString().split(' ')[0],
        t.title,
        t.categoryDisplayName,
        t.amount,
        t.type.name,
        t.paymentMethodDisplayName,
        t.description ?? '',
      ]),
    ];
    
    final String csv = const ListToCsvConverter().convert(csvData);
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/transactions_export.csv');
    await file.writeAsString(csv);
    
    await Share.shareXFiles([XFile(file.path)], text: 'Transaction Export');
  }
}