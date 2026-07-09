import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/app_header.dart';
import '../widgets/app_icons.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/transaction_list_item.dart';
import '../services/mock_api_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _apiService = MockApiService();

  static const _transactions = [
    {'dateTime': '05/26/2026 - 8:30 PM', 'plate': 'AAO 2311'},
    {'dateTime': '05/26/2026 - 8:33 PM', 'plate': 'BAO 2501'},
    {'dateTime': '05/26/2026 - 8:47', 'plate': 'LOL 2322'},
  ];

  void _onNavTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        break; 
      case 1:
        Navigator.pushReplacementNamed(context, '/tickets');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/settings');
        break;
    }
  }

  // Function to simulate capturing a transaction offline
  void _simulateCapture() async {
    await _apiService.submitMockTransaction();
    setState(() {}); // Refresh UI to show increased queue number
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const AppHeader(triangleSize: 20),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 0,
        onTap: (i) => _onNavTap(context, i),
      ),
      
      // Updated for a floating action button for your demo to trigger mock transactions
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _simulateCapture,
        backgroundColor: AppColors.black,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Capture MoPS Record", style: TextStyle(color: Colors.white)),
      ),
      
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              
              // The red banner now dynamically shows/hides based on mock network status
              if (!_apiService.isOnline)
                Container(
                  color: AppColors.alertRed,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Row(
                    children: [
                      const AppIcon(svg: AppIcons.warning, size: 24, color: AppColors.white),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'SYSTEM DEGRADED: CONTINUITY MODE ACTIVE',
                          style: TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ---------- Title ----------
                    const Text(
                      'Continuity Dashboard',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: AppColors.gray900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Central Hub for offline transaction logging and lane recovery management.',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.gray600,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ---------- Pending Sync Card ----------
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/sync-transactions');
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.navyCard,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const AppIcon(svg: AppIcons.stackedBars, size: 20, color: AppColors.gray400),
                                const SizedBox(width: 8),
                                Text(
                                  'Pending Sync',
                                  style: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Text(
                              // [NEW] Replaced hardcoded "42" with dynamic counter
                              '${_apiService.unsyncedRecords}',
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Transactions queued for server upload',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // ---------- Recent Transactions ----------
                    const Text(
                      'RECENT TRANSACTIONS',
                      style: TextStyle(
                        color: AppColors.gray600,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.gray200),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          for (int i = 0; i < _transactions.length; i++)
                            TransactionListItem(
                              dateTime: _transactions[i]['dateTime']!,
                              plate: _transactions[i]['plate']!,
                              showBottomBorder: i != _transactions.length - 1,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
