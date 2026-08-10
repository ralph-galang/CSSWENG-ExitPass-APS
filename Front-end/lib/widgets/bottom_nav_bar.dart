import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'app_icons.dart';

/// Bottom nav used across Dashboard / Tickets / Log / Settings / Sync / Manual
/// Transaction / Ticket Detail screens. The active tab gets a light-blue
/// pill background, matching the mockups' `bg-[#D1E5F7] rounded-full` style.
class AppBottomNavBar extends StatelessWidget {
  final int currentIndex; // 0 = Dashboard, 1 = Tickets, 2 = Log, 3 = Settings
  final ValueChanged<int> onTap;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const List<String> tabRoutes = [
    '/dashboard',
    '/tickets',
    '/operational-logs',
    '/settings',
  ];

  // Shared bottom-nav tap handler: navigates to the tapped tab's route
  // unless the caller is already on it.
  static void navigateToTab(BuildContext context, String currentRoute, int tappedIndex) {
    final target = tabRoutes[tappedIndex];
    if (target == currentRoute) return;
    Navigator.pushReplacementNamed(context, target);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.gray50,
        border: Border(top: BorderSide(color: AppColors.gray200, width: 1)),
      ),
      padding: const EdgeInsets.only(top: 8, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            label: 'Dashboard',
            svg: AppIcons.grid,
            isActive: currentIndex == 0,
            onTap: () => onTap(0),
          ),
          _NavItem(
            label: 'Tickets',
            svg: AppIcons.ticket,
            isActive: currentIndex == 1,
            onTap: () => onTap(1),
          ),
          _NavItem(
            label: 'Log',
            svg: AppIcons.log,
            isActive: currentIndex == 2,
            onTap: () => onTap(2),
          ),
          _NavItem(
            label: 'Settings',
            svg: AppIcons.settingsGear,
            isActive: currentIndex == 3,
            onTap: () => onTap(3),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final String svg;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.svg,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.navActiveText : AppColors.gray500;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 4),
            decoration: BoxDecoration(
              color: isActive ? AppColors.navActiveBg : Colors.transparent,
              borderRadius: BorderRadius.circular(999),
            ),
            child: AppIcon(svg: svg, size: 24, color: color),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
