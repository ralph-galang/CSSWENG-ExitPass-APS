import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/app_header.dart';
import '../widgets/app_icons.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/transaction_list_item.dart';

class SyncTransactionsScreen extends StatelessWidget {
  const SyncTransactionsScreen({super.key});

  static const _transactions = [
    {'dateTime': '05/26/2026 - 8:30 PM', 'plate': 'AAO 2311'},
    {'dateTime': '05/26/2026 - 8:33 PM', 'plate': 'BAO 2501'},
    {'dateTime': '05/26/2026 - 8:47', 'plate': 'LOL 2322'},
  ];

  void _onNavTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/dashboard');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/tickets');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      appBar: const AppHeader(triangleSize: 20),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 0,
        onTap: (i) => _onNavTap(context, i),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Sync Transactions',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              const Text(
                'Sync local transactions to the database.',
                style: TextStyle(color: AppColors.gray500, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 32),

              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(color: AppColors.gray300),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
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
              const SizedBox(height: 192), // mt-48

              SizedBox(
                height: 64,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.black,
                    foregroundColor: AppColors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const AppIcon(svg: AppIcons.cloudUpload, size: 28, color: AppColors.white),
                      const SizedBox(width: 12),
                      const Text(
                        'Sync Transactions',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
