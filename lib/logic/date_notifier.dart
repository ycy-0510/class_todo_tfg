import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class DateNotifier extends StateNotifier<DateState> {
  DateNotifier()
      : super(DateState(now: DateTime.now(), sunday: DateTime.now())) {
    int year = state.now.year;
    int month = state.now.month;
    int day = state.now.day - (state.now.weekday) % 7;
    state = state.copy(sunday: DateTime(year, month, day));
    Timer.periodic(const Duration(minutes: 2), (timer) {
      DateTime now = DateTime.now();
      if (!(now.year == state.now.year &&
          now.month == state.now.month &&
          now.day == state.now.day)) {
        state = state.copy(now: now);
      }
    });
  }

  void nextWeek() {
    state = state.copy(sunday: state.sunday.add(const Duration(days: 7)));
  }

  void lastWeek() {
    state = state.copy(sunday: state.sunday.subtract(const Duration(days: 7)));
  }

  void today() {
    int year = state.now.year;
    int month = state.now.month;
    int day = state.now.day - (state.now.weekday) % 7;
    state = state.copy(sunday: DateTime(year, month, day));
  }
}

class DateState {
  DateState({required this.now, required this.sunday});
  final DateTime now;
  final DateTime sunday;
  DateState copy({DateTime? now, DateTime? sunday}) => DateState(
        now: now ?? this.now,
        sunday: sunday ?? this.sunday,
      );
}
