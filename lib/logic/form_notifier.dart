import 'package:flutter_riverpod/flutter_riverpod.dart';

class FormNotifier extends StateNotifier<FormState> {
  FormNotifier() : super(FormState(name: '', date: DateTime.now()));

  void nameChange(String name) => state = state.copy(name: name);
  void typeChange(int type) => state = state.copy(type: type);
  void dateChange(DateTime date) => state = state.copy(date: date);
}

class FormState {
  FormState({required this.name, this.type = 0, required this.date});
  final String name;
  final int type;
  final DateTime date;
  FormState copy({String? name, int? type, DateTime? date}) => FormState(
        name: name ?? this.name,
        type: type ?? this.type,
        date: date ?? this.date,
      );
}
