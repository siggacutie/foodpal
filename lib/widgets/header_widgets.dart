import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../providers/log_provider.dart';

class HeaderAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const HeaderAction({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      padding: const EdgeInsets.all(8),
      child: Icon(icon, size: 20, color: AppTheme.textBlack),
    );
  }
}

class CalorieAnalysisWidget extends ConsumerWidget {
  const CalorieAnalysisWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final total = ref.watch(totalCaloriesProvider);
    final goal = ref.watch(calorieGoalProvider);
    final percent = (total / goal).clamp(0.0, 1.0);
    final isOver = total > goal;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),      
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200, width: 1.5),         
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: percent),
              duration: AppTheme.animationDuration,
              builder: (context, value, child) {
                return CircularProgressIndicator(
                  value: value,
                  strokeWidth: 4,
                  strokeCap: StrokeCap.round,
                  backgroundColor: AppTheme.primaryAccent.withOpacity(0.1),
                  color: isOver ? Colors.orangeAccent : AppTheme.primaryAccent,
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$total',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: AppTheme.textBlack,
                      height: 1,
                    ),
                  ),
                  Text(
                    ' / $goal kcal',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                      color: AppTheme.slateGrey.withOpacity(0.6),
                      height: 1.2,
                    ),
                  ),
                ],
              ),
              Text(
                isOver ? 'Over goal' : 'Under goal',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 10,
                  color: isOver ? Colors.orangeAccent : AppTheme.primaryAccent,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PillButton extends StatelessWidget {
  final String label;
  final Widget? leading;
  final Color? textColor;

  const PillButton({
    super.key,
    required this.label,
    this.leading,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),      
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: TextStyle(
              color: textColor ?? AppTheme.textBlack,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
