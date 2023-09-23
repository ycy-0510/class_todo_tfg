import 'package:class_todo_list/class_table.dart';
import 'package:class_todo_list/logic/connectivety_notifier.dart';
import 'package:class_todo_list/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

int toClassTime(DateTime dateTime) {
  TimeOfDay time = TimeOfDay.fromDateTime(dateTime);
  for (int i = 0; i < classTimes.length - 1; i++) {
    if (classTimes[i].hour * 60 + classTimes[i].minute <=
            time.hour * 60 + time.minute &&
        classTimes[i + 1].hour * 60 + classTimes[i + 1].minute >
            time.hour * 60 + time.minute) {
      return i;
    }
  }
  return -1;
}

class TaskNotifier extends StateNotifier<List<Task>> {
  late FirebaseFirestore db;
  final Ref _ref;
  TaskNotifier(this._ref) : super([]) {
    db = FirebaseFirestore.instance;
    getData();
    _ref.listen(dateProvider, (previous, next) {
      getData();
    });
    _ref.listen(connectivityStatusProvider, (previous, next) {
      if (next == ConnectivityStatus.isConnected) {
        getData();
      }
    });
  }

  void getData() async {
    final citiesRef = db.collection("task");
    try {
      final data = await citiesRef
          .where("date",
              isLessThanOrEqualTo:
                  _ref.read(dateProvider).sunday.add(const Duration(days: 7)))
          .where("date", isGreaterThanOrEqualTo: _ref.read(dateProvider).sunday)
          .get();
      List<Task> tasks = [];
      for (var docSnapshot in data.docs) {
        tasks.add(Task.fromFirestore(docSnapshot));
      }
      state = tasks;
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

class Task {
  String name;
  int type;
  DateTime date;
  int classTime;
  String userId;
  String taskId;
  Task({
    required this.name,
    required this.type,
    required this.date,
    required this.classTime,
    required this.userId,
    required this.taskId,
  });

  factory Task.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot, [
    SnapshotOptions? options,
  ]) {
    final data = snapshot.data();
    return Task(
      name: data?['name'],
      type: data?['type'],
      date: data?['date'].toDate(),
      classTime: toClassTime(data?['date'].toDate()),
      userId: data?['userId'],
      taskId: snapshot.id,
    );
  }
}
