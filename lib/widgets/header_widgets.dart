import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

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
