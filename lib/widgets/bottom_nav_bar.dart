import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: 72,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(36),
        boxShadow: [
          BoxShadow(
            color: AppTheme.softShadow.withOpacity(0.08),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Gliding Indicator
          AnimatedAlign(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutQuart,
            alignment: Alignment(
              -1.0 + (currentIndex * (2.0 / 4)), // Maps 0-4 to -1.0 to 1.0
              0,
            ),
            child: FractionallySizedBox(
              widthFactor: 1 / 5,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.primaryAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ),
          
          // Navigation Items
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _NavBarItem(
                icon: Icons.description_outlined, // Logs
                isActive: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              _NavBarItem(
                icon: Icons.analytics_outlined, // Insights
                isActive: currentIndex == 1,
                onTap: () => onTap(1),
              ),
              _NavBarItem(
                icon: Icons.auto_awesome_outlined, // AI Planner
                isActive: currentIndex == 2,
                onTap: () => onTap(2),
              ),
              _NavBarItem(
                icon: Icons.restaurant_outlined, // Meals
                isActive: currentIndex == 3,
                onTap: () => onTap(3),
              ),
              _NavBarItem(
                icon: Icons.person_outline_rounded, // Profile
                isActive: currentIndex == 4,
                onTap: () => onTap(4),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: double.infinity,
          alignment: Alignment.center,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Icon(
              icon,
              key: ValueKey(isActive),
              color: isActive ? AppTheme.primaryAccent : AppTheme.slateGrey.withOpacity(0.4),
              size: 26,
            ),
          ),
        ),
      ),
    );
  }
}
