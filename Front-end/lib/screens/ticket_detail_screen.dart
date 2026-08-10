import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/app_header.dart';
import '../widgets/app_icons.dart';
import '../widgets/bottom_nav_bar.dart';
import '../config/api_config.dart';
import '../database/app_database.dart';
import '../services/exit_checkout_service.dart';
import '../services/session_store.dart';

/// Arguments passed via Navigator when pushing '/ticket-detail' from
/// ScanTicketScreen -- read back out via ModalRoute.of(context)!.settings
/// .arguments, same as any other named-route argument.
class TicketDetailArgs {
  final ParkingSessionLookupResult lookupResult;
  final String ticketNumber;

  TicketDetailArgs({required this.lookupResult, required this.ticketNumber});
}

class TicketDetailScreen extends StatefulWidget {
  const TicketDetailScreen({super.key});

  @override
  State<TicketDetailScreen> createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  late final ExitCheckoutService _checkoutService;
  final SessionStore _sessionStore = SessionStore();
  bool _isProcessing = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _checkoutService = ExitCheckoutService(
      db: AppDatabase(),
      baseUrl: Uri.parse(ApiConfig.baseUrl),
    );
  }

  Future<void> _handleProceedToPayment(TicketDetailArgs args) async {
    final session = _sessionStore.currentSession;
    if (session == null) {
      setState(() => _errorMessage = 'Session expired. Please log in again.');
      return;
    }

    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    try {
      // Dummy payment -- see ExitCheckoutService.recordExitCheckout; no
      // rate/time calc happens on-device for this flow.
      await _checkoutService.recordExitCheckout(
        operatorId: session.userId,
        deviceId: session.deviceCode,
        siteId: session.siteCode,
        lane: DeviceConfig.lane,
        ticketNumber: args.ticketNumber,
        qrPayload: args.lookupResult.qrPayload,
        amountMinorUnits: 0,
        currencyCode: 'PHP',
        paymentMethod: 'BCP_DUMMY',
      );

      if (!mounted) return;
      setState(() => _isProcessing = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Exit recorded locally. Go to Sync Transactions to upload it.'),
        ),
      );
      Navigator.pushReplacementNamed(context, '/dashboard');
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isProcessing = false;
        // recordExitCheckout only touches the local DB -- a failure here
        // means the DB itself is broken, not connectivity.
        _errorMessage = 'Could not save the transaction locally. Please try again.';
      });
    }
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontSize: 20, color: AppColors.gray800)),
          const SizedBox(width: 4),
          Expanded(
            child: Text(value,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as TicketDetailArgs?;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const AppHeader(triangleSize: 16),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 1,
        onTap: (i) => AppBottomNavBar.navigateToTab(context, '/ticket-detail', i),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Ticket No. ${args?.ticketNumber ?? ''}',
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 40),

              _detailRow('License Plate:', args?.lookupResult.plateNumber ?? '—'),
              // ParkingSessionLookupResult doesn't carry these fields --
              // placeholders, not invented values.
              _detailRow('Time-In:', '—'),
              _detailRow('Time-Out:', '—'),
              _detailRow('Location:', '—'),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.gray300),
                      ),
                    ),
                    const Text('Payment Status:',
                        style: TextStyle(fontSize: 20, color: AppColors.gray800)),
                    const SizedBox(width: 4),
                    Text(args?.lookupResult.paymentStatus ?? '—',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // ---------- QR code ----------
              const Center(
                child: SizedBox(
                  width: 192,
                  height: 192,
                  child: AppIcon(svg: AppIcons.qrCode, size: 192, color: AppColors.black),
                ),
              ),
              const SizedBox(height: 32),

              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),

              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: (_isProcessing || args == null)
                      ? null
                      : () => _handleProceedToPayment(args),
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
                  child: _isProcessing
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                              color: AppColors.white, strokeWidth: 2),
                        )
                      : const Text(
                          'Proceed to Payment',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
