import 'package:class_todo_list/logic/auth_notifier.dart';
import 'package:class_todo_list/logic/connectivety_notifier.dart';
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

final formProvider =
    StateNotifierProvider<TaskFormNotifier, TaskFormState>((ref) {
  return TaskFormNotifier(ref);
});

final dateProvider = StateNotifierProvider<DateNotifier, DateState>((ref) {
  return DateNotifier();
});

final taskProvider =
    StateNotifierProvider.autoDispose<TaskNotifier, TaskState>((ref) {
  return TaskNotifier(ref);
});

final connectivityStatusProvider = StateNotifierProvider.autoDispose<
    ConnectivityStatusNotifier, ConnectivityStatus>((ref) {
  return ConnectivityStatusNotifier();
});
