import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class NowTimeNotifier extends StateNotifier<DateTime> {
  NowTimeNotifier() : super(DateTime.now()) {
    Timer.periodic(const Duration(minutes: 1), (timer) {
      state = DateTime.now();
    });
  }
}
