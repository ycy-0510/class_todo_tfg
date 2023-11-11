import 'dart:async';

import 'package:class_todo_list/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SubmittedNotifier extends StateNotifier<SubmittedState> {
  late FirebaseFirestore db;
  final Ref _ref;
  StreamSubscription<QuerySnapshot>? listener;
  SubmittedNotifier(this._ref) : super(SubmittedState([])) {
    db = FirebaseFirestore.instance;
    getData();
    _ref.listen(dateProvider, (previous, next) {
      getData();
    });
  }

  void getData() {
    state = SubmittedState([], loading: true);
    final dataRef = db
        .collection("task")
        .where("date",
            isGreaterThanOrEqualTo:
                _ref.read(dateProvider).now.subtract(const Duration(days: 7)))
        .where('type', isEqualTo: 4);
    listener?.cancel();
    listener = dataRef.snapshots().listen(
      (data) {
        List<Submitted> submittedItem = [];
        for (var docSnapshot in data.docs) {
          submittedItem.add(Submitted.fromFirestore(docSnapshot));
        }
        state = SubmittedState(submittedItem);
      },
      onError: (e) => _showError(e.toString()),
    );
  }

  void _showError(String error) {
    Fluttertoast.showToast(
      msg: error,
      timeInSecForIosWeb: 1,
      webShowClose: true,
    );
  }

  @override
  void dispose() {
    listener?.cancel();
    super.dispose();
  }
}

class SubmittedState {
  List<Submitted> submittedItems;
  bool loading;
  SubmittedState(this.submittedItems, {this.loading = false});
}

class Submitted {
  String name;
  DateTime date;
  String userId;
  String submittedId;
  List<String> done;
  Submitted({
    required this.name,
    required this.date,
    required this.userId,
    required this.submittedId,
    required this.done,
  });

  factory Submitted.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot, [
    SnapshotOptions? options,
  ]) {
    final data = snapshot.data();
    return Submitted(
      name: data?['name'],
      date: data?['date'].toDate(),
      userId: data?['userId'],
      submittedId: snapshot.id,
      done: (data?['submitted'] as List).map((e) => e.toString()).toList(),
    );
  }

  void update(String doneName) {
    if (done.contains(doneName)) {
      done.remove(doneName);
    } else {
      done.add(doneName);
    }
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection('task').doc(submittedId).update({
      'submitted': done,
    });
  }
}
