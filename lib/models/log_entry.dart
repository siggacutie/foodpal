
enum LogStatus { active, inactive }

class LogEntry {
  final String id;
  final String name;
  final String time;
  final int calories;
  final LogStatus status;
  final String? relativeTime;

  LogEntry({
    required this.id,
    required this.name,
    required this.time,
    required this.calories,
    this.status = LogStatus.active,
    this.relativeTime,
  });
}
