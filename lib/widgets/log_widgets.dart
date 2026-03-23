import 'package:flutter/material.dart';
import '../models/log_entry.dart';
import '../theme/app_theme.dart';

class LogItem extends StatelessWidget {
  final LogEntry entry;

  const LogItem({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: entry.status == LogStatus.active
                  ? AppTheme.primaryAccent
                  : AppTheme.slateGrey.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              entry.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppTheme.textBlack,
              ),
            ),
          ),
          if (entry.time.isNotEmpty)
            Text(
              entry.time,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.slateGrey.withValues(alpha: 0.6),
              ),
            ),
          const SizedBox(width: 12),
          Text(
            '${entry.calories} kcal',
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.slateGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class SearchLogItem extends StatelessWidget {
  final LogEntry entry;

  const SearchLogItem({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              entry.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppTheme.textBlack,
              ),
            ),
          ),
          if (entry.relativeTime != null)
            Text(
              entry.relativeTime!,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: AppTheme.slateGrey.withValues(alpha: 0.4),
              ),
            ),
          const SizedBox(width: 12),
          Text(
            '${entry.calories} kcal',
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.slateGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
