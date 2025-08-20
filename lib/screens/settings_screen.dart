import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../services/export_service.dart';
import '../services/backup_service.dart';
import '../services/auth_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Theme Settings
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Appearance',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Consumer<ThemeProvider>(
                    builder: (context, themeProvider, child) {
                      return SwitchListTile(
                        title: const Text('Dark Mode'),
                        subtitle: const Text('Toggle between light and dark theme'),
                        value: themeProvider.isDarkMode,
                        onChanged: (value) => themeProvider.toggleTheme(),
                        secondary: Icon(
                          themeProvider.isDarkMode
                              ? Icons.dark_mode_rounded
                              : Icons.light_mode_rounded,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Data Management
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Data Management',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.file_download_rounded),
                    title: const Text('Export Data'),
                    subtitle: const Text('Export transactions as PDF or CSV'),
                    onTap: () => _showExportDialog(context),
                  ),
                  ListTile(
                    leading: const Icon(Icons.backup_rounded),
                    title: const Text('Backup Data'),
                    subtitle: const Text('Create backup of your data'),
                    onTap: () => _createBackup(context),
                  ),
                  ListTile(
                    leading: const Icon(Icons.restore_rounded),
                    title: const Text('Restore Data'),
                    subtitle: const Text('Restore from backup'),
                    onTap: () => _restoreBackup(context),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Security
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Security',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.fingerprint_rounded),
                    title: const Text('Biometric Authentication'),
                    subtitle: const Text('Enable fingerprint/face unlock'),
                    trailing: FutureBuilder<bool>(
                      future: AuthService().isAuthEnabled(),
                      builder: (context, snapshot) {
                        return Switch(
                          value: snapshot.data ?? false,
                          onChanged: (value) => _toggleBiometric(context, value),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // About
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  const ListTile(
                    leading: Icon(Icons.info_rounded),
                    title: Text('Version'),
                    subtitle: Text('1.0.0'),
                  ),
                  const ListTile(
                    leading: Icon(Icons.code_rounded),
                    title: Text('Developer'),
                    subtitle: Text('Flutter Portfolio Project'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: const Text('Choose export format:'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Get transactions from provider and pass to exportToPDF
              // final transactions = Provider.of<TransactionProvider>(context, listen: false).allTransactions;
              // ExportService.exportToPDF(transactions);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('PDF export coming soon!')),
              );
            },
            child: const Text('PDF'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Get transactions from provider
              // final transactions = Provider.of<TransactionProvider>(context, listen: false).allTransactions;
              // await ExportService.exportToCSV(transactions);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Export feature coming soon')),
              );
            },
            child: const Text('CSV'),
          ),
        ],
      ),
    );
  }

  void _createBackup(BuildContext context) async {
    try {
      await BackupService.createBackup();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Backup created successfully')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Backup failed: $e')),
        );
      }
    }
  }

  void _restoreBackup(BuildContext context) async {
    try {
      // TODO: Implement file picker to select backup file
      // await BackupService.restoreBackup(selectedFilePath);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Restore backup feature coming soon')),
      );
      return;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data restored successfully')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Restore failed: $e')),
        );
      }
    }
  }

  void _toggleBiometric(BuildContext context, bool enabled) async {
    try {
      await AuthService().setAuthEnabled(enabled);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              enabled ? 'Biometric authentication enabled' : 'Biometric authentication disabled',
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update setting: $e')),
        );
      }
    }
  }
}