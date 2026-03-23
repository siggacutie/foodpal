import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/log_entry.dart';

class SelectedDateNotifier extends Notifier<DateTime> {
  @override
  DateTime build() => DateTime(2026, 3, 20);

  void update(DateTime date) => state = date;
}

final selectedDateProvider = NotifierProvider<SelectedDateNotifier, DateTime>(SelectedDateNotifier.new);

final logsProvider = Provider<List<LogEntry>>((ref) {
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
});

final searchResultsProvider = Provider<List<LogEntry>>((ref) {
  return [
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
  ];
});
