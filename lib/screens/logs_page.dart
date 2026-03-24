import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../providers/log_provider.dart';
import '../models/log_entry.dart';
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
  late AnimationController _thinkingController;
  Timer? _statusTimer;
  bool _isAddPressed = false;
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late List<LogEntry> _displayedLogs;

  @override
  void initState() {
    super.initState();
    _thinkingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _displayedLogs = [];
    // Initialize displayed logs after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final initialLogs = ref.read(logsProvider);
      for (var i = 0; i < initialLogs.length; i++) {
        _displayedLogs.add(initialLogs[i]);
        _listKey.currentState?.insertItem(i, duration: Duration.zero);
      }
    });
  }

  @override
  void dispose() {
    _thinkingController.dispose();
    _statusTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onAddTapped() {
    final text = _searchController.text.trim();
    if (text.isEmpty) return;

    HapticFeedback.mediumImpact();
    setState(() {
      _aiStatus = 'Thinking...';
    });

    _statusTimer?.cancel();
    _statusTimer = Timer(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() => _aiStatus = 'Searching...');
        _statusTimer = Timer(const Duration(milliseconds: 600), () {
          if (mounted) {
            setState(() => _aiStatus = 'Analyzing...');
            _statusTimer = Timer(const Duration(milliseconds: 600), () {
              if (mounted) {
                setState(() => _aiStatus = null);
                _addNewEntry(text);
              }
            });
          }
        });
      }
    });
  }

  void _addNewEntry(String name) {
    ref.read(logsProvider.notifier).addEntry(name);
    final newEntry = ref.read(logsProvider).first;
    _displayedLogs.insert(0, newEntry);
    _listKey.currentState?.insertItem(
      0,
      duration: const Duration(milliseconds: 500),
    );
    _searchController.clear();
    ref.read(searchQueryProvider.notifier).state = '';
  }

  @override
  Widget build(BuildContext context) {
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
                  const CalorieAnalysisWidget(),
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
              // Logs List (Animated)
              Expanded(
                flex: 2,
                child: AnimatedList(
                  key: _listKey,
                  initialItemCount: _displayedLogs.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index, animation) {
                    final entry = _displayedLogs[index];
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: animation.drive(
                          Tween<Offset>(
                            begin: const Offset(0, -0.2),
                            end: Offset.zero,
                          ).chain(CurveTween(curve: Curves.easeOutQuart)),  
                        ),
                        child: LogItem(entry: entry),
                      ),
                    );
                  },
                ),
              ),
              
              // Search Input Area
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppTheme.slateGrey.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          TextField(
                            controller: _searchController,
                            onChanged: (val) => ref.read(searchQueryProvider.notifier).state = val,
                            cursorColor: Colors.transparent, // Using custom cursor
                            decoration: const InputDecoration(
                              hintText: 'Enter your meal',
                              hintStyle: TextStyle(
                                color: AppTheme.slateGrey,
                                fontSize: 16,
                              ),
                              border: InputBorder.none,
                            ),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.textBlack,
                            ),
                          ),
                          // Custom Phasing Cursor
                          _PhasingCursor(controller: _searchController),    
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _aiStatus != null
                          ? ThinkingAnimation(
                              controller: _thinkingController,
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
              
              // Smart Suggestions
              Expanded(
                flex: 1,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: animation.drive(
                          Tween<Offset>(
                            begin: const Offset(0, 0.1),
                            end: Offset.zero,
                          ).chain(CurveTween(curve: Curves.easeOutQuart)),  
                        ),
                        child: child,
                      ),
                    );
                  },
                  child: searchResults.isEmpty
                      ? const SizedBox.shrink()
                      : ListView.builder(
                          key: ValueKey(searchResults.length),
                          padding: const EdgeInsets.only(top: 16),
                          itemCount: searchResults.length,
                          itemBuilder: (context, index) {
                            return SearchLogItem(entry: searchResults[index]);
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PhasingCursor extends StatefulWidget {
  final TextEditingController controller;
  const _PhasingCursor({required this.controller});

  @override
  State<_PhasingCursor> createState() => _PhasingCursorState();
}

class _PhasingCursorState extends State<_PhasingCursor> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _cursorOffset = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    
    widget.controller.addListener(_updateOffset);
  }

  void _updateOffset() {
    if (!mounted) return;
    final text = widget.controller.text;
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    
    setState(() {
      _cursorOffset = textPainter.width;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    widget.controller.removeListener(_updateOffset);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _cursorOffset,
      child: FadeTransition(
        opacity: _controller,
        child: Container(
          width: 2,
          height: 20,
          color: AppTheme.primaryAccent,
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
                AppTheme.slateGrey.withOpacity(0.2),
                AppTheme.textBlack,
                AppTheme.slateGrey.withOpacity(0.2),
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
                fontSize: 14,
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
