import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/transaction_provider.dart';
import '../widgets/spending_trend_chart.dart';
import '../widgets/monthly_comparison_chart.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Trends'),
            Tab(text: 'Categories'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildTrendsTab(),
          _buildCategoriesTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary Cards
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      'Total Income',
                      provider.totalIncome,
                      Icons.trending_up_rounded,
                      Colors.green,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSummaryCard(
                      'Total Expenses',
                      provider.totalExpenses,
                      Icons.trending_down_rounded,
                      Colors.red,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      'Net Worth',
                      provider.totalBalance,
                      Icons.account_balance_wallet_rounded,
                      provider.totalBalance >= 0 ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSummaryCard(
                      'Avg. Daily',
                      0.0, // TODO: Implement averageDailySpending calculation
                      Icons.calendar_today_rounded,
                      Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Monthly Spending Chart
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Monthly Spending',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                          height: 200,
                         child: SpendingTrendChart(
                           monthlyData: const {},
                           primaryColor: Theme.of(context).primaryColor,
                         ),
                       ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTrendsTab() {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Income vs Expenses',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    height: 300,
                    child: MonthlyComparisonChart(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesTab() {
    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {
        final categoryData = provider.categoryWiseSpending;
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Category Breakdown',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 200,
                        child: Container(
                          height: 200,
                          child: const Center(
                            child: Text('Category Chart Coming Soon'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Category List
              ...categoryData.entries.map((entry) {
                final category = entry.key;
                final amount = entry.value;
                final percentage = (amount / provider.totalExpenses) * 100;
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                          Icons.category,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    title: Text(category.name.replaceAll('_', ' ').toUpperCase()),
                    subtitle: Text('${percentage.toStringAsFixed(1)}% of expenses'),
                    trailing: Text(
                      NumberFormat.currency(symbol: '\$').format(amount),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryCard(String title, double amount, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              NumberFormat.currency(symbol: '\$').format(amount),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}