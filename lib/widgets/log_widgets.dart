import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/log_entry.dart';
import '../theme/app_theme.dart';
import 'nutrition_bottom_sheet.dart';

class LogItem extends StatefulWidget {
  final LogEntry entry;

  const LogItem({super.key, required this.entry});

  @override
  State<LogItem> createState() => _LogItemState();
}

class _LogItemState extends State<LogItem> {
  bool _isPressed = false;

  void _onTap() {
    HapticFeedback.lightImpact();
    NutritionBottomSheet.show(context, widget.entry);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: _onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.entry.status == LogStatus.active
                      ? AppTheme.primaryAccent
                      : AppTheme.slateGrey.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  widget.entry.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textBlack,
                  ),
                ),
              ),
              if (widget.entry.time.isNotEmpty)
                Text(
                  widget.entry.time,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.slateGrey.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              const SizedBox(width: 12),
              Text(
                '${widget.entry.calories} kcal',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.slateGrey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchLogItem extends StatefulWidget {
  final LogEntry entry;

  const SearchLogItem({super.key, required this.entry});

  @override
  State<SearchLogItem> createState() => _SearchLogItemState();
}

class _SearchLogItemState extends State<SearchLogItem> {
  bool _isPressed = false;

  void _onTap() {
    HapticFeedback.lightImpact();
    NutritionBottomSheet.show(context, widget.entry);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: _onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.entry.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textBlack,
                  ),
                ),
              ),
              if (widget.entry.relativeTime != null)
                Text(
                  widget.entry.relativeTime!,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.slateGrey.withValues(alpha: 0.4),
                  ),
                ),
              const SizedBox(width: 12),
              Text(
                '${widget.entry.calories} kcal',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.slateGrey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
