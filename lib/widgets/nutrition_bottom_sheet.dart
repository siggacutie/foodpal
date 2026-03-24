import 'package:flutter/material.dart';
import 'dart:ui';
import '../models/log_entry.dart';
import '../theme/app_theme.dart';

class NutritionBottomSheet extends StatefulWidget {
  final LogEntry entry;

  const NutritionBottomSheet({super.key, required this.entry});

  @override
  State<NutritionBottomSheet> createState() => _NutritionBottomSheetState();

  static void show(BuildContext context, LogEntry entry) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (context) => NutritionBottomSheet(entry: entry),
    );
  }
}

class _NutritionBottomSheetState extends State<NutritionBottomSheet> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _progressAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutQuart,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),     
        ),
        child: Column(
          children: [
            // Handle (Fixed at top)
            const SizedBox(height: 12),
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),        
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    // Header
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.entry.name,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textBlack,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Logged at ${widget.entry.time}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppTheme.slateGrey.withOpacity(0.6),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.background,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            widget.entry.nutrition.servingSize,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.slateGrey,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Calories
                    Center(
                      child: Column(
                        children: [
                          Text(
                            '${widget.entry.calories}',
                            style: const TextStyle(
                              fontSize: 64,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.textBlack,
                              letterSpacing: -2,
                            ),
                          ),
                          const Text(
                            'TOTAL KILO CALORIES',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.slateGrey,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Macronutrients
                    const Text(
                      'MACRONUTRIENTS',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.slateGrey,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _MacroItem(
                          label: 'Protein',
                          value: widget.entry.nutrition.protein,
                          unit: 'g',
                          color: Colors.blueAccent,
                          animation: _progressAnimation,
                          targetPercent: widget.entry.nutrition.protein / 50, 
                        ),
                        _MacroItem(
                          label: 'Carbs',
                          value: widget.entry.nutrition.carbs,
                          unit: 'g',
                          color: Colors.orangeAccent,
                          animation: _progressAnimation,
                          targetPercent: widget.entry.nutrition.carbs / 100, 
                        ),
                        _MacroItem(
                          label: 'Fats',
                          value: widget.entry.nutrition.fats,
                          unit: 'g',
                          color: Colors.redAccent,
                          animation: _progressAnimation,
                          targetPercent: widget.entry.nutrition.fats / 40,  
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Micronutrients
                    const Text(
                      'MICRONUTRIENTS',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.slateGrey,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _MicroChip(label: 'Fiber', value: '${widget.entry.nutrition.fiber}g'),
                        _MicroChip(label: 'Sugar', value: '${widget.entry.nutrition.sugar}g'),
                        _MicroChip(label: 'Sodium', value: '${widget.entry.nutrition.sodium}mg'),
                      ],
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // Actions (Fixed at bottom)
            Padding(
              padding: EdgeInsets.fromLTRB(24, 16, 24, MediaQuery.of(context).padding.bottom + 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),   
                        backgroundColor: AppTheme.background,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text(
                        'Delete Entry',
                        style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),   
                        backgroundColor: AppTheme.primaryAccent,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text(
                        'Edit Details',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MacroItem extends StatelessWidget {
  final String label;
  final double value;
  final String unit;
  final Color color;
  final Animation<double> animation;
  final double targetPercent;

  const _MacroItem({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
    required this.animation,
    required this.targetPercent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(
                value: 1.0,
                strokeWidth: 8,
                color: color.withOpacity(0.1),
              ),
            ),
            AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                return SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(
                    value: animation.value * targetPercent.clamp(0.0, 1.0),  
                    strokeWidth: 8,
                    strokeCap: StrokeCap.round,
                    color: color,
                  ),
                );
              },
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value.toStringAsFixed(0),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,   
                    color: AppTheme.textBlack,
                  ),
                ),
                Text(
                  unit,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.slateGrey.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.textBlack,
          ),
        ),
      ],
    );
  }
}

class _MicroChip extends StatelessWidget {
  final String label;
  final String value;

  const _MicroChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),      
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${label}: ',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.slateGrey.withOpacity(0.6),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppTheme.textBlack,
            ),
          ),
        ],
      ),
    );
  }
}
