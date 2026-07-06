import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'header_triangle.dart';

/// The "Parking Operations" header used identically (aside from minor
/// triangle-size differences) on every screen.
class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double triangleSize;
  final double fontSize;

  const AppHeader({
    super.key,
    this.title = 'Parking Operations',
    this.triangleSize = 16,
    this.fontSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(bottom: BorderSide(color: AppColors.gray200, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w800,
              color: AppColors.gray900,
              letterSpacing: -0.3,
            ),
          ),
          HeaderTriangle(size: triangleSize),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(52);
}
