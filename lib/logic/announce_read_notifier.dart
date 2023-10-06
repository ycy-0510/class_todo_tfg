import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnnounceReadNotifier extends StateNotifier<String> {
  static String key = 'lastMsg';
  AnnounceReadNotifier() : super('') {
    getReadMsgId();
  }

  Future<void> getReadMsgId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    state = prefs.getString(key) ?? '';
  }

  Future<void> readMsg(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, id);
    state = id;
  }
}
