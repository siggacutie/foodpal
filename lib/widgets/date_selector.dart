import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import '../providers/log_provider.dart';
import '../theme/app_theme.dart';

class DateSelector extends ConsumerStatefulWidget {
  const DateSelector({super.key});

  @override
  ConsumerState<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends ConsumerState<DateSelector> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}';
  }

  void _toggleCalendar() {
    if (_isOpen) {
      _closeCalendar();
    } else {
      _openCalendar();
    }
  }

  void _openCalendar() {
    HapticFeedback.mediumImpact();
    final overlay = Overlay.of(context);
    _overlayEntry = _createOverlayEntry();
    overlay.insert(_overlayEntry!);
    setState(() => _isOpen = true);
  }

  void _closeCalendar() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() => _isOpen = false);
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Dismiss barrier
          GestureDetector(
            onTap: _closeCalendar,
            behavior: HitTestBehavior.opaque,
            child: Container(color: Colors.transparent),
          ),
          CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(-100, size.height + 8),
            child: Material(
              color: Colors.transparent,
              child: _CalendarWidget(
                initialDate: ref.read(selectedDateProvider),
                onDateSelected: (date) {
                  ref.read(selectedDateProvider.notifier).update(date);
                  HapticFeedback.lightImpact();
                  _closeCalendar();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(selectedDateProvider);

    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleCalendar,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),    
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: _isOpen ? AppTheme.primaryAccent : Colors.grey.shade200, 
              width: 1.5,
            ),
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
              AnimatedRotation(
                turns: _isOpen ? 0.5 : 0,
                duration: AppTheme.animationDuration,
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 18,
                  color: _isOpen ? AppTheme.primaryAccent : AppTheme.slateGrey.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CalendarWidget extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime) onDateSelected;

  const _CalendarWidget({required this.initialDate, required this.onDateSelected});

  @override
  State<_CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<_CalendarWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late DateTime _currentMonth;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    _currentMonth = DateTime(widget.initialDate.year, widget.initialDate.month);
    _pageController = PageController(initialPage: 1200 + (_currentMonth.year - 2026) * 12 + (_currentMonth.month - 3));
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      alignment: Alignment.topCenter,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          width: 280,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Month Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left_rounded),
                    onPressed: () => _pageController.previousPage(
                      duration: AppTheme.animationDuration,
                      curve: AppTheme.animationCurve,
                    ),
                  ),
                  Text(
                    '${_getMonthName(_currentMonth.month)} ${_currentMonth.year}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppTheme.textBlack,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right_rounded),
                    onPressed: () => _pageController.nextPage(
                      duration: AppTheme.animationDuration,
                      curve: AppTheme.animationCurve,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Day Names
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((day) => Text(
                  day,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.slateGrey.withOpacity(0.5),
                  ),
                )).toList(),
              ),
              const SizedBox(height: 8),
              // Calendar Grid
              SizedBox(
                height: 200,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      final monthOffset = index - 1200;
                      _currentMonth = DateTime(2026, 3 + monthOffset);
                    });
                  },
                  itemBuilder: (context, index) {
                    final monthOffset = index - 1200;
                    final monthDate = DateTime(2026, 3 + monthOffset);
                    return _MonthGrid(
                      month: monthDate,
                      selectedDate: widget.initialDate,
                      onDateSelected: widget.onDateSelected,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    return ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'][month - 1];
  }
}

class _MonthGrid extends StatelessWidget {
  final DateTime month;
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const _MonthGrid({required this.month, required this.selectedDate, required this.onDateSelected});

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final firstDayOfWeek = DateTime(month.year, month.month, 1).weekday % 7;
    final today = DateTime.now();

    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemCount: 42,
      itemBuilder: (context, index) {
        final day = index - firstDayOfWeek + 1;
        if (day < 1 || day > daysInMonth) return const SizedBox.shrink();

        final date = DateTime(month.year, month.month, day);
        final isSelected = date.year == selectedDate.year && date.month == selectedDate.month && date.day == selectedDate.day;
        final isToday = date.year == today.year && date.month == today.month && date.day == today.day;

        return GestureDetector(
          onTap: () => onDateSelected(date),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.primaryAccent : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: isToday && !isSelected ? Border.all(color: AppTheme.primaryAccent, width: 1.5) : null,
            ),
            alignment: Alignment.center,
            child: Text(
              '$day',
              style: TextStyle(
                fontWeight: isSelected || isToday ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : (isToday ? AppTheme.primaryAccent : AppTheme.textBlack),
                fontSize: 14,
              ),
            ),
          ),
        );
      },
    );
  }
}
