import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/app_header.dart';
import '../widgets/app_icons.dart';
import '../widgets/bottom_nav_bar.dart';
import '../config/api_config.dart';
import '../database/app_database.dart';
import '../services/exit_checkout_service.dart';
import '../screens/ticket_detail_screen.dart';

class ScanTicketScreen extends StatefulWidget {
  const ScanTicketScreen({super.key});

  @override
  State<ScanTicketScreen> createState() => _ScanTicketScreenState();
}

class _ScanTicketScreenState extends State<ScanTicketScreen> {
  final _ticketController = TextEditingController();
  late final ExitCheckoutService _checkoutService;
  bool _isLookingUp = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // AppDatabase() returns the shared singleton -- see app_database.dart --
    // so this doesn't open a second connection to the same sqlite file.
    _checkoutService = ExitCheckoutService(
      db: AppDatabase(),
      baseUrl: Uri.parse(ApiConfig.baseUrl),
    );
  }

  @override
  void dispose() {
    _ticketController.dispose();
    super.dispose();
  }

  Future<void> _handleEnterTicket() async {
    final ticketNumber = _ticketController.text.trim();
    if (ticketNumber.isEmpty) {
      setState(() => _errorMessage = 'Enter a ticket number.');
      return;
    }

    setState(() {
      _isLookingUp = true;
      _errorMessage = null;
    });

    try {
      final result =
          await _checkoutService.lookupSession(ticketNumber: ticketNumber);

      if (!mounted) return;
      setState(() => _isLookingUp = false);

      Navigator.pushNamed(
        context,
        '/ticket-detail',
        arguments: TicketDetailArgs(
          lookupResult: result,
          ticketNumber: ticketNumber,
        ),
      );
    } on ParkingSessionNotFoundException catch (e) {
      if (!mounted) return;
      setState(() {
        _isLookingUp = false;
        _errorMessage = e.message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLookingUp = false;
        _errorMessage =
            'Could not reach the server. Check your connection and try again.';
      });
    }
  }

  void _onNavTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/dashboard');
        break;
      case 1:
        break; // already here
      case 2:
        Navigator.pushReplacementNamed(context, '/operational-logs');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const AppHeader(triangleSize: 16),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 1,
        onTap: (i) => _onNavTap(context, i),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ---------- QR scanner placeholder frame ----------
              // NOTE: this is still a visual placeholder -- no camera
              // package is wired in, so only the manual ticket-number path
              // below actually calls the backend. Scanning would need a
              // package like mobile_scanner added and its result passed to
              // ExitCheckoutService.lookupSession(qrPayload: ...) the same
              // way ticketNumber is below.
              AspectRatio(
                aspectRatio: 1,
                child: DottedBorderContainer(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const AppIcon(svg: AppIcons.qrFrame, size: 64, color: AppColors.gray900),
                        const SizedBox(height: 16),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Position QR code within frame',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.gray900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // ---------- Ticket number field ----------
              const Text(
                'Ticket No.',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.6,
                  color: AppColors.gray900,
                ),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: _ticketController,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  hintText: '# --',
                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 20),
                  filled: true,
                  fillColor: AppColors.gray50,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(color: AppColors.gray900, width: 2),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(color: AppColors.gray900, width: 2),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(color: AppColors.black, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),

              // ---------- Action buttons ----------
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLookingUp ? null : _handleEnterTicket,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.black,
                    foregroundColor: AppColors.white,
                    disabledBackgroundColor: AppColors.black,
                    disabledForegroundColor: AppColors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: _isLookingUp
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                              color: AppColors.white, strokeWidth: 2),
                        )
                      : const Text(
                          'Enter Ticket',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/manual-transaction');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.manualTransactionRed,
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'Manual Transaction',
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

/// Approximates Tailwind's `border-dashed` (CSS dashed borders aren't a
/// built-in Flutter BoxDecoration option) via CustomPaint.
class DottedBorderContainer extends StatelessWidget {
  final Widget child;
  const DottedBorderContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedBorderPainter(),
      child: Padding(padding: const EdgeInsets.all(2), child: child),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    const dashWidth = 6.0;
    const dashSpace = 4.0;
    final path = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        canvas.drawPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          paint,
        );
        distance = next + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
