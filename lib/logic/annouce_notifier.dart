import 'dart:async';
import 'package:class_todo_list/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class AnnounceNotifier extends StateNotifier<AnnounceState> {
  late FirebaseFirestore db;
  final Ref _ref;
  StreamSubscription<QuerySnapshot>? listener;
  AnnounceNotifier(this._ref) : super(AnnounceState([])) {
    db = FirebaseFirestore.instance;
    getData();
  }

  void getData() {
    state = AnnounceState([], loading: true);
    final dataRef = db.collection("announce").limit(20).orderBy('date');
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

  void sendData(String text) async {
    if (text.isNotEmpty) {
      try {
        DocumentReference dataRef = await db.collection('announce').add({
          'content': text,
          'userId': _ref.read(authProvider).user!.uid,
          'date': FieldValue.serverTimestamp()
        });
        const String gasUrl =
            'https://script.google.com/macros/s/AKfycbxVtO1mvVZMtu8QZBg2OjcZWfE4kNcAQlaC_UtY0QNwwwsMlJMcODrESWIeXkP1-QEuOQ/exec';
        var res = await http
            .get(Uri.parse('$gasUrl?announceId=${dataRef.id}&code=yccjyt'));
        if (res.statusCode != 200 || res.body != '200') {
          _showError('傳送Line錯誤');
        }
      } catch (e) {
        _showError(e.toString());
      }
    }
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
  AnnounceState(this.announces, {this.loading = false});

  AnnounceState copyWith({List<Announce>? announces, bool? loading}) =>
      AnnounceState(
        announces ?? this.announces,
        loading: loading ?? this.loading,
      );
}

class Announce {
  String content;
  String userId;
  String announceId;
  DateTime dateTime;
  Announce(
      {required this.content,
      required this.userId,
      required this.announceId,
      required this.dateTime});
  factory Announce.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot, [
    SnapshotOptions? options,
  ]) {
    final data = snapshot.data();
    return Announce(
        content: data?['content'],
        userId: data?['userId'],
        announceId: snapshot.id,
        dateTime: data?['date'].toDate());
  }
}
