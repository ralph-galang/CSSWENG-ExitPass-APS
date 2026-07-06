import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'app_icons.dart';

/// A single row in the "Recent Transactions" / "Sync Transactions" lists:
/// clock icon, timestamp + plate number, trailing chevron.
class TransactionListItem extends StatelessWidget {
  final String dateTime;
  final String plate;
  final bool showBottomBorder;
  final VoidCallback? onTap;

  const TransactionListItem({
    super.key,
    required this.dateTime,
    required this.plate,
    this.showBottomBorder = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: showBottomBorder
              ? const Border(
                  bottom: BorderSide(color: AppColors.gray200, width: 1))
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: AppColors.gray100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: AppIcon(svg: AppIcons.clock, size: 20, color: AppColors.gray900),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dateTime,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.gray900,
                    ),
                  ),
                  Text(
                    plate,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.gray500,
                    ),
                  ),
                ],
              ),
            ),
            AppIcon(svg: AppIcons.chevronRight, size: 20, color: AppColors.gray400),
          ],
        ),
      ),
    );
  }
}
