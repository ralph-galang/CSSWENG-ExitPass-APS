import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/app_header.dart';
import '../widgets/app_icons.dart';
import '../widgets/bottom_nav_bar.dart';

class OperationalLogsScreen extends StatefulWidget {
  const OperationalLogsScreen({super.key});

  @override
  State<OperationalLogsScreen> createState() => _OperationalLogsScreenState();
}

class _OperationalLogsScreenState extends State<OperationalLogsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const AppHeader(triangleSize: 20),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 2,
        onTap: (i) => AppBottomNavBar.navigateToTab(context, '/operational-logs', i),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title
                const Text(
                  'Operational Logs',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: AppColors.gray900,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'What would you like to report/log?',
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.gray600,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 32),

                // Incident Button
                _LogTypeButton(
                  title: 'Incident',
                  icon: AppIcons.warning,
                  description: 'Report system issues or incidents',
                  onTap: () {
                    Navigator.pushNamed(context, '/incident-log');
                  },
                ),
                const SizedBox(height: 16),

                // Manual Gate Action Button
                _LogTypeButton(
                  title: 'Manual Gate Action',
                  icon: AppIcons.log,
                  description: 'Log manual gate operations',
                  onTap: () {
                    Navigator.pushNamed(context, '/manual-gate-log');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LogTypeButton extends StatelessWidget {
  final String title;
  final String icon;
  final String description;
  final VoidCallback onTap;

  const _LogTypeButton({
    required this.title,
    required this.icon,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.gray200, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              AppIcon(
                svg: icon,
                size: 32,
                color: AppColors.navActiveText,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.gray900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.gray600,
                      ),
                    ),
                  ],
                ),
              ),
              const AppIcon(
                svg: AppIcons.chevronRight,
                size: 20,
                color: AppColors.gray400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
