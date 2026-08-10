import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/app_header.dart';
import '../widgets/app_icons.dart';
import '../widgets/bottom_nav_bar.dart';
import '../services/mock_api_service.dart';

class ManualTransactionScreen extends StatefulWidget {
  const ManualTransactionScreen({super.key});

  @override
  State<ManualTransactionScreen> createState() =>
      _ManualTransactionScreenState();
}

class _ManualTransactionScreenState extends State<ManualTransactionScreen> {
  final _apiService = MockApiService();
  String _reasonCode = 'System Down';
  final _ticketController = TextEditingController();
  final _plateController = TextEditingController();
  final _dateController = TextEditingController();
  final _amountController = TextEditingController(text: r'$0.00');

  @override
  void dispose() {
    _ticketController.dispose();
    _plateController.dispose();
    _dateController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  InputDecoration _hashDecoration({String? hint}) {
    return InputDecoration(
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 4),
        child: Center(
          widthFactor: 1,
          child: Text(
            '#',
            style: TextStyle(fontSize: 20, color: Colors.grey.shade600),
          ),
        ),
      ),
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 18),
      filled: true,
      fillColor: AppColors.inputBg,
      contentPadding: const EdgeInsets.symmetric(vertical: 14),
      border: AppDecorations.blackZeroRadiusBorder,
      enabledBorder: AppDecorations.blackZeroRadiusBorder,
      focusedBorder: AppDecorations.blackZeroRadiusBorder,
    );
  }

  Widget _fieldLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.6,
          color: AppColors.gray900,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const AppHeader(triangleSize: 15),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 1,
        onTap: (i) => AppBottomNavBar.navigateToTab(context, '/manual-transaction', i),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Manual Transaction',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Manually log transaction when session information cannot '
                'be accessed.',
                style: TextStyle(
                  color: AppColors.gray600,
                  fontSize: 15,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 24),

              // Reason code dropdown
              _fieldLabel('SELECT REASON CODE'),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.black),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _reasonCode,
                    isExpanded: true,
                    icon: const AppIcon(svg: AppIcons.chevronDown, size: 22, color: AppColors.gray500),
                    style: const TextStyle(fontSize: 18, color: AppColors.black),
                    items: const [
                      DropdownMenuItem(value: 'System Down', child: Text('System Down')),
                      DropdownMenuItem(value: 'Power Outage', child: Text('Power Outage')),
                      DropdownMenuItem(value: 'Maintenance', child: Text('Maintenance')),
                    ],
                    onChanged: (v) => setState(() => _reasonCode = v!),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              _fieldLabel('TICKET NO. (IF ANY)'),
              TextField(controller: _ticketController, decoration: _hashDecoration(hint: '--')),
              const SizedBox(height: 16),

              _fieldLabel('LICENSE PLATE'),
              TextField(controller: _plateController, decoration: _hashDecoration(hint: '--')),
              const SizedBox(height: 16),

              _fieldLabel('ISSUE DATE'),
              TextField(controller: _dateController, decoration: _hashDecoration(hint: '--')),
              const SizedBox(height: 16),

              _fieldLabel('AMOUNT DUE'),
              TextField(
                controller: _amountController,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.gray500,
                ),
                decoration: const InputDecoration(
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(left: 4, right: 4),
                    child: AppIcon(svg: AppIcons.cash, size: 24, color: AppColors.gray600),
                  ),
                  filled: true,
                  fillColor: AppColors.inputBg,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                  border: AppDecorations.blackZeroRadiusBorder,
                  enabledBorder: AppDecorations.blackZeroRadiusBorder,
                  focusedBorder: AppDecorations.blackZeroRadiusBorder,
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // Capture the new transaction data
                    final newTransaction = {
                      'dateTime': _dateController.text.isEmpty 
                          ? '05/26/2026 - 9:00 PM' // Fallback for demo
                          : _dateController.text,
                      'plate': _plateController.text.isEmpty 
                          ? 'NEW-PLATE' 
                          : _plateController.text,
                    };

                    // Save to the in-memory mock service
                    _apiService.addTransaction(newTransaction);

                    // Navigate back to the dashboard to see the update
                    Navigator.pushReplacementNamed(context, '/dashboard');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.black,
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Log Transaction',
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
