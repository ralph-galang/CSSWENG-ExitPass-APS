import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

// Shared "recent item" card for Incident/Manual Gate log lists -- title +
// synced/pending badge + body + timestamp.
class SyncStatusLogCard extends StatelessWidget {
  final String title;
  final String body;
  final String timestamp;
  final bool synced;

  const SyncStatusLogCard({
    super.key,
    required this.title,
    required this.body,
    required this.timestamp,
    required this.synced,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.gray200, width: 1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.gray900,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: synced
                      ? AppColors.navActiveBg
                      : AppColors.alertRed.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  synced ? 'Synced' : 'Pending',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: synced ? AppColors.navActiveText : AppColors.alertRed,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: const TextStyle(fontSize: 13, color: AppColors.gray600),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            timestamp,
            style: const TextStyle(fontSize: 12, color: AppColors.gray500),
          ),
        ],
      ),
    );
  }
}
