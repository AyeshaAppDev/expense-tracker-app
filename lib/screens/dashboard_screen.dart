import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/transaction_provider.dart';
import '../providers/theme_provider.dart';
import '../models/transaction.dart';
import '../widgets/balance_card.dart';
import '../widgets/quick_stats_card.dart';
import '../widgets/recent_transactions_list.dart';
import '../widgets/category_chart.dart';
import 'add_transaction_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Expense Tracker',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return IconButton(
                icon: Icon(
                  themeProvider.isDarkMode
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                ),
                onPressed: () => themeProvider.toggleTheme(),
                tooltip: 'Toggle Theme',
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () {
              // Navigate to settings
            },
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: RefreshIndicator(
            onRefresh: () async {
              await context.read<TransactionProvider>().loadTransactions();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Balance Cards
                  Consumer<TransactionProvider>(
                    builder: (context, provider, child) {
                      return Row(
                        children: [
                          Expanded(
                            child: BalanceCard(
                              title: 'Total Balance',
                              amount: provider.totalBalance,
                              icon: Icons.account_balance_wallet_rounded,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: BalanceCard(
                              title: 'This Month',
                              amount: provider.totalBalance,
                              icon: Icons.calendar_month_rounded,
                              color: provider.totalBalance >= 0
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // Quick Stats
                  Consumer<TransactionProvider>(
                    builder: (context, provider, child) {
                      return Row(
                        children: [
                          Expanded(
                            child: QuickStatsCard(
                              title: 'Income',
                              amount: provider.totalIncome,
                              icon: Icons.trending_up_rounded,
                              color: Colors.green,
                              percentage: 0.0, // TODO: Implement income growth calculation
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: QuickStatsCard(
                              title: 'Expenses',
                              amount: provider.totalExpenses,
                              icon: Icons.trending_down_rounded,
                              color: Colors.red,
                              percentage: 0.0, // TODO: Implement expense growth calculation
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // Category Chart
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Spending by Category',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Navigate to detailed analytics
                                },
                                child: const Text('View All'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const SizedBox(
                            height: 200,
                            child: CategoryChart(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Recent Transactions
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Recent Transactions',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Navigate to all transactions
                                },
                                child: const Text('View All'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const RecentTransactionsList(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTransactionScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Transaction'),
      ),
    );
  }
}