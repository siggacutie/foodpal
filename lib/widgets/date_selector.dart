import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import '../providers/log_provider.dart';
import '../theme/app_theme.dart';

class DateSelector extends ConsumerWidget {
  const DateSelector({super.key});

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}';
  }

  Future<void> _selectDate(BuildContext context, WidgetRef ref, DateTime currentDate) async {
    HapticFeedback.mediumImpact();
    
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryAccent,
              onPrimary: Colors.white,
              onSurface: AppTheme.textBlack,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primaryAccent,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != currentDate) {
      ref.read(selectedDateProvider.notifier).update(picked);
      HapticFeedback.lightImpact();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    
    return GestureDetector(
      onTap: () => _selectDate(context, ref, selectedDate),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.shade200, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _formatDate(selectedDate),
              style: const TextStyle(
                color: AppTheme.textBlack,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18,
              color: AppTheme.slateGrey.withOpacity(0.8),
            ),
          ],
        ),
      ),
    );
  }
}
