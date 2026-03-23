import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../providers/log_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/header_widgets.dart';
import '../widgets/log_widgets.dart';
import '../widgets/date_selector.dart';

class LogsPage extends ConsumerStatefulWidget {
  const LogsPage({super.key});

  @override
  ConsumerState<LogsPage> createState() => _LogsPageState();
}

class _LogsPageState extends ConsumerState<LogsPage> with SingleTickerProviderStateMixin {
  String? _aiStatus;
  late AnimationController _controller;
  Timer? _statusTimer;
  bool _isAddPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _statusTimer?.cancel();
    super.dispose();
  }

  void _onAddTapped() {
    HapticFeedback.mediumImpact();
    setState(() {
      _aiStatus = 'Thinking...';
    });

    _statusTimer?.cancel();
    _statusTimer = Timer(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() => _aiStatus = 'Searching...');
        _statusTimer = Timer(const Duration(seconds: 1), () {
          if (mounted) {
            setState(() => _aiStatus = 'Checking...');
            _statusTimer = Timer(const Duration(seconds: 1), () {
              if (mounted) {
                setState(() => _aiStatus = null);
              }
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final logs = ref.watch(logsProvider);
    final searchResults = ref.watch(searchResultsProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Top Bar
              Row(
                children: [
                  HeaderAction(icon: Icons.info_outline, onTap: () {}),
                  const SizedBox(width: 12),
                  HeaderAction(icon: Icons.dark_mode_outlined, onTap: () {}),
                  const Spacer(),
                  const DateSelector(),
                  const Spacer(),
                  const PillButton(
                    label: '735 kcal',
                    leading: Icon(
                      Icons.local_fire_department_rounded,
                      size: 18,
                      color: Colors.orangeAccent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Section Header
              const Text(
                'TODAY',
                style: TextStyle(
                  color: AppTheme.slateGrey,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              // Logs List
              ...logs.map((entry) => LogItem(entry: entry)),
              const SizedBox(height: 32),
              // Search Input Area
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppTheme.slateGrey.withValues(alpha: 0.1),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Enter your meal',
                          hintStyle: TextStyle(
                            color: AppTheme.slateGrey,
                            fontSize: 16,
                          ),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textBlack,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _aiStatus != null
                          ? ThinkingAnimation(
                              controller: _controller,
                              text: _aiStatus!,
                            )
                          : Row(
                              key: const ValueKey('icons'),
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.camera_alt_outlined, size: 24),
                                  onPressed: () {},
                                  color: AppTheme.slateGrey,
                                ),
                                const SizedBox(width: 4),
                                GestureDetector(
                                  onTapDown: (_) => setState(() => _isAddPressed = true),
                                  onTapUp: (_) => setState(() => _isAddPressed = false),
                                  onTapCancel: () => setState(() => _isAddPressed = false),
                                  onTap: _onAddTapped,
                                  child: AnimatedScale(
                                    scale: _isAddPressed ? 0.9 : 1.0,
                                    duration: const Duration(milliseconds: 100),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryAccent,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppTheme.primaryAccent.withOpacity(0.3),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(Icons.add, size: 24, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Search Results
              Expanded(
                child: ListView.builder(
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    return SearchLogItem(entry: searchResults[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ThinkingAnimation extends StatelessWidget {
  final Animation<double> controller;
  final String text;

  const ThinkingAnimation({super.key, required this.controller, required this.text});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                AppTheme.slateGrey.withValues(alpha: 0.2),
                AppTheme.textBlack,
                AppTheme.slateGrey.withValues(alpha: 0.2),
              ],
              stops: const [0.1, 0.5, 0.9],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              transform: SlidingGradientTransform(slidePercent: controller.value),
            ).createShader(bounds);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14, // Smaller as requested
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ),
        );
      },
    );
  }
}

class SlidingGradientTransform extends GradientTransform {
  const SlidingGradientTransform({
    required this.slidePercent,
  });

  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * (slidePercent * 2 - 1), 0, 0);
  }
}
