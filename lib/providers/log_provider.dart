import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/log_entry.dart';

class SelectedDateNotifier extends Notifier<DateTime> {
  @override
  DateTime build() => DateTime(2026, 3, 20);

  void update(DateTime date) => state = date;      
}

final selectedDateProvider = NotifierProvider<SelectedDateNotifier, DateTime>(SelectedDateNotifier.new);

class LogsNotifier extends Notifier<List<LogEntry>> {
  @override
  List<LogEntry> build() {
    return [
      LogEntry(
        id: '1',
        name: 'Oatmeal with banana',
        time: '8:12 AM',
        calories: 310,
        status: LogStatus.active,
        nutrition: const NutritionInfo(
          protein: 12,
          carbs: 58,
          fats: 6,
          fiber: 8,
          sugar: 14,
          sodium: 5,
          servingSize: '1 bowl',
        ),
      ),
      LogEntry(
        id: '2',
        name: 'Black coffee',
        time: '9:05 AM',
        calories: 5,
        status: LogStatus.inactive,
        nutrition: const NutritionInfo(
          protein: 0.3,
          carbs: 0,
          fats: 0,
          fiber: 0,
          sugar: 0,
          sodium: 2,
          servingSize: '1 cup',
        ),
      ),
      LogEntry(
        id: '3',
        name: 'Chicken salad',
        time: '12:30 PM',
        calories: 420,
        status: LogStatus.active,
        nutrition: const NutritionInfo(
          protein: 32,
          carbs: 12,
          fats: 24,
          fiber: 6,
          sugar: 4,
          sodium: 480,
          servingSize: '1 plate',
        ),
      ),
    ];
  }

  void addEntry(String name) {
    final newEntry = LogEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      time: 'Now',
      calories: 450, // Placeholder
      status: LogStatus.active,
      nutrition: const NutritionInfo(
        protein: 25,
        carbs: 35,
        fats: 15,
        fiber: 5,
        sugar: 8,
        sodium: 320,
        servingSize: '1 serving',
      ),
    );
    // Insert at the TOP
    state = [newEntry, ...state];
  }

  void removeEntry(String id) {
    state = state.where((e) => e.id != id).toList();
  }
}

final logsProvider = NotifierProvider<LogsNotifier, List<LogEntry>>(LogsNotifier.new);

class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';
  
  set state(String value) => super.state = value;
}

final searchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(SearchQueryNotifier.new);

final searchResultsProvider = Provider<List<LogEntry>>((ref) {
  final query = ref.watch(searchQueryProvider).toLowerCase();
  if (query.isEmpty) return [];

  final allSuggestions = [
    LogEntry(
      id: 's1',
      name: 'Chicken salad',
      time: '',
      calories: 420,
      relativeTime: 'YESTERDAY',
      nutrition: const NutritionInfo(
        protein: 32,
        carbs: 12,
        fats: 24,
      ),
    ),
    LogEntry(
      id: 's2',
      name: 'Grilled chicken wrap',
      time: '',
      calories: 510,
      relativeTime: 'MON',
      nutrition: const NutritionInfo(
        protein: 28,
        carbs: 45,
        fats: 18,
      ),
    ),
    LogEntry(
      id: 's3',
      name: 'Chicken tikka masala',
      time: '',
      calories: 620,
      relativeTime: 'SAT',
      nutrition: const NutritionInfo(
        protein: 35,
        carbs: 22,
        fats: 38,
      ),
    ),
    LogEntry(
      id: 's4',
      name: 'Coffee with milk',
      time: '',
      calories: 85,
      relativeTime: 'TODAY',
      nutrition: const NutritionInfo(
        protein: 4,
        carbs: 9,
        fats: 4,
      ),
    ),
  ];

  return allSuggestions.where((e) => e.name.toLowerCase().contains(query)).toList();
});

final calorieGoalProvider = Provider<int>((ref) => 2000);

final totalCaloriesProvider = Provider<int>((ref) {
  final logs = ref.watch(logsProvider);
  return logs.fold(0, (sum, item) => sum + item.calories);
});
