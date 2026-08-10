import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'package:intl/intl.dart';
import '../theme/app_colors.dart';
import '../widgets/app_header.dart';
import '../widgets/app_icons.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/transaction_list_item.dart';
import '../config/api_config.dart';
import '../database/app_database.dart';
import '../services/exit_transaction_sync_service.dart';

class SyncTransactionsScreen extends StatefulWidget {
  const SyncTransactionsScreen({super.key});

  @override
  State<SyncTransactionsScreen> createState() => _SyncTransactionsScreenState();
}

class _SyncTransactionsScreenState extends State<SyncTransactionsScreen> {
  final AppDatabase _db = AppDatabase();
  late final ExitTransactionSyncService _exitSyncService;
  bool _isSyncing = false;
  bool _isLoading = true;
  List<ContinuityTransaction> _pending = [];

  @override
  void initState() {
    super.initState();
    _exitSyncService = ExitTransactionSyncService(
      db: _db,
      baseUrl: Uri.parse(ApiConfig.baseUrl),
    );
    _loadPending();
  }

  Future<void> _loadPending() async {
    setState(() => _isLoading = true);
    final rows = await (_db.select(_db.continuityTransactions)
          ..where((_) => _db.pendingExitCheckoutFilter)
          ..orderBy([(t) => drift.OrderingTerm.desc(t.occurredAt)]))
        .get();
    if (!mounted) return;
    setState(() {
      _pending = rows;
      _isLoading = false;
    });
  }

  void _handleSync() async {
    if (_pending.isEmpty) return;

    setState(() {
      _isSyncing = true;
    });

    // Errors swallowed deliberately -- syncPendingExitTransactions() already
    // leaves failed rows pending for retry.
    await _exitSyncService.syncPendingExitTransactions();

    // Re-query rather than assume success -- a partial batch failure can
    // leave some rows still pending.
    await _loadPending();

    if (mounted) {
      setState(() {
        _isSyncing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final transactions = _pending;
    final isEmpty = transactions.isEmpty;
    final dateFormat = DateFormat('MM/dd/yyyy - h:mm a');

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const AppHeader(triangleSize: 20),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 0,
        onTap: (i) => AppBottomNavBar.navigateToTab(context, '/sync-transactions', i),
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

                      if (_isLoading)
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: const Center(
                            child: CircularProgressIndicator(color: AppColors.black),
                          ),
                        )
                      else if (isEmpty)
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check,
                                size: 100,
                                color: AppColors.black,
                              ),
                              SizedBox(height: 24),
                              Text(
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
                                  dateTime: dateFormat.format(transactions[i].occurredAt),
                                  plate: 'Ticket ${transactions[i].ticketNumber}',
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
                  onPressed: (_isSyncing || _isLoading || isEmpty) ? null : _handleSync,
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
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppIcon(svg: AppIcons.cloudUpload, size: 28, color: AppColors.white),
                            SizedBox(width: 12),
                            Text(
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
