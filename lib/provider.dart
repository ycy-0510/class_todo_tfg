import 'package:class_todo_list/logic/auth_notifier.dart';
import 'package:class_todo_list/logic/date_notifier.dart';
import 'package:class_todo_list/logic/form_notifier.dart';
import 'package:class_todo_list/logic/task_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final toastProvider = StateProvider<String>(
  (ref) => '',
);

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) {
    return AuthNotifier();
  },
);

final formProvider = StateNotifierProvider<FormNotifier, FormState>((ref) {
  return FormNotifier(ref);
});

final dateProvider = StateNotifierProvider<DateNotifier, DateState>((ref) {
  return DateNotifier();
});

final taskProvider = StateNotifierProvider<TaskNotifier, List<Task>>((ref) {
  return TaskNotifier(ref);
});
