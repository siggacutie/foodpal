import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/log_entry.dart';

final logsProvider = Provider<List<LogEntry>>((ref) {
  return [
    LogEntry(
      id: '1',
      name: 'Oatmeal with banana',
      time: '8:12 AM',
      calories: 310,
      status: LogStatus.active,
    ),
    LogEntry(
      id: '2',
      name: 'Black coffee',
      time: '9:05 AM',
      calories: 5,
      status: LogStatus.inactive,
    ),
    LogEntry(
      id: '3',
      name: 'Chicken salad',
      time: '12:30 PM',
      calories: 420,
      status: LogStatus.active,
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
    ),
    LogEntry(
      id: 's2',
      name: 'Grilled chicken wrap',
      time: '',
      calories: 510,
      relativeTime: 'MON',
    ),
    LogEntry(
      id: 's3',
      name: 'Chicken tikka masala',
      time: '',
      calories: 620,
      relativeTime: 'SAT',
    ),
  ];
});
