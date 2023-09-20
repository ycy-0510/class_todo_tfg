import 'package:class_todo_list/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FormNotifier extends StateNotifier<FormState> {
  final Ref _ref;
  FormNotifier(this._ref) : super(FormState(name: '', date: DateTime.now()));

  void nameChange(String name) => state = state.copy(name: name);
  void typeChange(int type) => state = state.copy(type: type);
  void dateChange(DateTime date) => state = state.copy(date: date);
  void timeChange(TimeOfDay time) => state = state.copy(
      date: state.date.copyWith(hour: time.hour, minute: time.minute));

  void upload() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    final data = {
      "name": state.name,
      "type": state.type,
      "date": state.date,
      "userId": _ref.read(authProvider).user?.uid
    };
    try {
      await db.collection("task").add(data);
    } catch (e) {
      _showError(e.toString());
    }
  }

  void _showError(String error) {
    Fluttertoast.showToast(
      msg: error,
      timeInSecForIosWeb: 1,
      webShowClose: true,
    );
  }
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
