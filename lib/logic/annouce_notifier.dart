import 'dart:async';

import 'package:class_todo_list/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AnnounceNotifier extends StateNotifier<AnnounceState> {
  late FirebaseFirestore db;
  final Ref _ref;
  StreamSubscription<QuerySnapshot>? listener;
  AnnounceNotifier(this._ref) : super(AnnounceState([])) {
    db = FirebaseFirestore.instance;
    getData();
    _ref.listen(dateProvider, (previous, next) {
      if (previous != null && previous.now.day != next.now.day) {
        getData();
      }
    });
  }

  void getData() {
    state = AnnounceState([], loading: true);
    final dataRef = db.collection("announce").where("expired",
        isGreaterThanOrEqualTo: _ref
            .read(dateProvider)
            .now
            .copyWith(hour: 0, minute: 0, second: 0));
    listener?.cancel();
    listener = dataRef.snapshots().listen(
      (data) {
        List<Announce> announces = [];
        for (var docSnapshot in data.docs) {
          announces.add(Announce.fromFirestore(docSnapshot));
        }
        state = AnnounceState(announces);
      },
      onError: (e) => _showError(e.toString()),
    );
  }

  void pause() {
    state = state.copyWith(pause: true);
  }

  void resume() {
    state = state.copyWith(pause: false);
  }

  void next() {
    state = state.copyWith(
        idx: (state.idx + 1) % state.announces.length, timer: 0, pause: false);
  }

  void prev() {
    state = state.copyWith(
        idx: (state.idx + state.announces.length - 1) % state.announces.length,
        timer: 0,
        pause: false);
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

class AnnounceState {
  List<Announce> announces;
  bool loading;
  int idx;
  double timer;
  bool pause;
  AnnounceState(this.announces,
      {this.loading = false, this.idx = 0, this.timer = 1, this.pause = false});

  AnnounceState copyWith(
          {List<Announce>? announces,
          bool? loading,
          int? idx,
          double? timer,
          bool? pause}) =>
      AnnounceState(
        announces ?? this.announces,
        loading: loading ?? this.loading,
        idx: idx ?? this.idx,
        timer: timer ?? this.timer,
        pause: pause ?? this.pause,
      );
}

class Announce {
  String content;
  String userId;
  String announceId;
  Announce(
      {required this.content, required this.userId, required this.announceId});
  factory Announce.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot, [
    SnapshotOptions? options,
  ]) {
    final data = snapshot.data();
    return Announce(
      content: data?['content'],
      userId: data?['userId'],
      announceId: snapshot.id,
    );
  }
}
