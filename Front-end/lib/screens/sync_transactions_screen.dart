import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/app_header.dart';
import '../widgets/app_icons.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/transaction_list_item.dart';
import '../services/mock_api_service.dart';
import '../config/api_config.dart';
import '../database/app_database.dart';
import '../services/exit_transaction_sync_service.dart';

class SyncTransactionsScreen extends StatefulWidget {
  const SyncTransactionsScreen({super.key});

  @override
  State<SyncTransactionsScreen> createState() => _SyncTransactionsScreenState();
}

class _SyncTransactionsScreenState extends State<SyncTransactionsScreen> {
  final _apiService = MockApiService();
  late final ExitTransactionSyncService _exitSyncService;
  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
    _exitSyncService = ExitTransactionSyncService(
      db: AppDatabase(),
      baseUrl: Uri.parse(ApiConfig.baseUrl),
    );
  }

  void _onNavTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/dashboard');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/tickets');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/operational-logs');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/settings');
        break;
    }
  }

  void _handleSync() async {
    if (_apiService.syncQueue.isEmpty) return;

    setState(() {
      _isSyncing = true;
    });

    // Real sync (BCP exit-checkout transactions in the local Drift DB) and
    // the existing mock sync (other transaction types, still unwired to a
    // real backend) run side by side here rather than one replacing the
    // other -- they're pushing genuinely different data. Errors from the
    // real sync are swallowed deliberately: syncPendingExitTransactions()
    // already leaves failed/offline rows as `pending` for the next pass
    // rather than throwing, so there's nothing actionable to surface here
    // beyond what the next sync attempt will retry automatically.
    await Future.wait([
      _exitSyncService.syncPendingExitTransactions(),
      _apiService.syncAll(),
    ]);

    if (mounted) {
      setState(() {
        _isSyncing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final transactions = _apiService.syncQueue;
    final isEmpty = transactions.isEmpty;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const AppHeader(triangleSize: 20),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 0,
        onTap: (i) => _onNavTap(context, i),
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Scrollable Top Content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Sync Transactions',
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Upload local transactions to the database.',
                        style: TextStyle(color: AppColors.gray500, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 32),

                      if (isEmpty)
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.check,
                                size: 100,
                                color: AppColors.black,
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                'All transactions are in sync.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 22,
                                  color: AppColors.gray900,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
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
                              for (int i = 0; i < transactions.length; i++)
                                TransactionListItem(
                                  dateTime: transactions[i]['dateTime']!,
                                  plate: transactions[i]['plate']!,
                                  showBottomBorder: i != transactions.length - 1,
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),

              // Fixed Bottom Button
              SizedBox(
                height: 56, // Adjusted to match design
                child: ElevatedButton(
                  onPressed: (_isSyncing || isEmpty) ? null : _handleSync,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.black,
                    foregroundColor: AppColors.white,
                    disabledBackgroundColor: AppColors.black,
                    disabledForegroundColor: AppColors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSyncing
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(color: AppColors.white, strokeWidth: 2),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const AppIcon(svg: AppIcons.cloudUpload, size: 28, color: AppColors.white),
                            const SizedBox(width: 12),
                            const Text(
                              'Sync Transactions',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
