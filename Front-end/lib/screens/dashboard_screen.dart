import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/app_header.dart';
import '../widgets/app_icons.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/transaction_list_item.dart';
import '../services/mock_api_service.dart';
import '../services/dashboard_metrics_service.dart';
import '../config/api_config.dart';
import '../database/app_database.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _apiService = MockApiService();
  late final DashboardMetricsService _metricsService;

  DashboardMetrics? _metrics;
  bool _isLoadingMetrics = true;
  String? _metricsError;

  @override
  void initState() {
    super.initState();
    _metricsService = DashboardMetricsService(
      db: AppDatabase(),
      baseUrl: Uri.parse(ApiConfig.baseUrl),
    );
    _loadMetrics();
  }

  Future<void> _loadMetrics() async {
    setState(() {
      _isLoadingMetrics = true;
      _metricsError = null;
    });
    try {
      final metrics = await _metricsService.load();
      if (!mounted) return;
      setState(() {
        _metrics = metrics;
        _isLoadingMetrics = false;
      });
    } on DashboardMetricsException catch (e) {
      if (!mounted) return;
      setState(() {
        _metricsError = e.message;
        _isLoadingMetrics = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _metricsError = 'Could not load dashboard metrics.';
        _isLoadingMetrics = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const AppHeader(triangleSize: 20),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 0,
        onTap: (i) => AppBottomNavBar.navigateToTab(context, '/dashboard', i),
      ),
      
      body: SafeArea(
        top: false,
        child: RefreshIndicator(
          onRefresh: _loadMetrics,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              
              // The red banner is now permanently active because we are forced offline
              if (!_apiService.isOnline)
                Container(
                  color: AppColors.alertRed,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: const Row(
                    children: [
                      AppIcon(svg: AppIcons.warning, size: 24, color: AppColors.white),
                      SizedBox(width: 12),
                      Expanded(
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

                    // ---------- Dashboard Counters ----------
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                            decoration: BoxDecoration(
                              color: AppColors.activeParkingBg,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.gray200),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Active Parking',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.activeParkingText,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const AppIcon(svg: AppIcons.clock, size: 18, color: AppColors.activeParkingText),
                                    const SizedBox(width: 8),
                                    Text(
                                      _isLoadingMetrics
                                          ? '—'
                                          : '${_metrics?.activeParkingSessions ?? '—'}',
                                      style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.activeParkingText,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                            decoration: BoxDecoration(
                              color: AppColors.exitedParkingBg,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.gray200),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Vehicles Exited',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.exitedParkingText,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const AppIcon(svg: AppIcons.history, size: 18, color: AppColors.exitedParkingText),
                                    const SizedBox(width: 8),
                                    Text(
                                      _isLoadingMetrics
                                          ? '—'
                                          : '${_metrics?.vehiclesExited ?? '—'}',
                                      style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.exitedParkingText,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                            decoration: BoxDecoration(
                              color: AppColors.totalTransactionsBg,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.gray200),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Total Transactions',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.totalTransactionsText,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const AppIcon(svg: AppIcons.ticket, size: 18, color: AppColors.totalTransactionsText),
                                    const SizedBox(width: 8),
                                    Text(
                                      _isLoadingMetrics
                                          ? '—'
                                          : '${_metrics?.totalTransactions ?? '—'}',
                                      style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.totalTransactionsText,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // ---------- Pending Sync Card ----------
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: AppColors.navyCard,
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/sync-transactions')
                                .then((_) => _loadMetrics());
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
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
                                  _isLoadingMetrics
                                      ? '—'
                                      : '${_metrics?.pendingSync ?? '—'}',
                                  style: const TextStyle(
                                    color: AppColors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _metricsError ??
                                      'Transactions queued for server upload',
                                  style: TextStyle(
                                    color: _metricsError != null
                                        ? AppColors.alertRed
                                        : Colors.grey.shade500,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                          for (int i = 0; i < _apiService.history.length; i++)
                            TransactionListItem(
                              dateTime: _apiService.history[i]['dateTime']!,
                              plate: _apiService.history[i]['plate']!,
                              showBottomBorder: i != _apiService.history.length - 1,
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
      ),
    );
  }
}
