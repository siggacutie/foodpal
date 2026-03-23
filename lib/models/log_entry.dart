
enum LogStatus { active, inactive }

class NutritionInfo {
  final double protein;
  final double carbs;
  final double fats;
  final double fiber;
  final double sugar;
  final double sodium;
  final String servingSize;

  const NutritionInfo({
    required this.protein,
    required this.carbs,
    required this.fats,
    this.fiber = 0,
    this.sugar = 0,
    this.sodium = 0,
    this.servingSize = '1 bowl',
  });
}

class LogEntry {
  final String id;
  final String name;
  final String time;
  final int calories;
  final LogStatus status;
  final String? relativeTime;
  final NutritionInfo nutrition;

  LogEntry({
    required this.id,
    required this.name,
    required this.time,
    required this.calories,
    this.status = LogStatus.active,
    this.relativeTime,
    required this.nutrition,
  });
}
