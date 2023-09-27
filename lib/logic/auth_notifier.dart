import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  late FirebaseAuth _auth;
  AuthNotifier() : super(AuthState()) {
    _auth = FirebaseAuth.instance;
    if (_auth.currentUser != null) {
      _auth.currentUser!.reload();
    }
    if (_auth.currentUser == null) {
      state = AuthState();
    } else {
      state = AuthState(user: _auth.currentUser!);
    }

    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        state = AuthState();
      } else {
        state = AuthState(user: user);
      }
    });
  }

  void googleLogin() async {
    if (!state.loggedIn) {
      state = state.load(true);
      try {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        await _auth.signInWithPopup(googleProvider);
        FirebaseFirestore db = FirebaseFirestore.instance;
        final data = {
          "name": state.user!.displayName,
        };
        await db.collection("user").doc(state.user!.uid).set(data);
      } catch (err) {
        state = state.load(false);
        _showError(err.toString());
      }
    }
  }

  void anonymousLogin() async {
    if (!state.loggedIn) {
      state = state.load(true);
      try {
        await _auth.signInAnonymously();
      } catch (err) {
        state = state.load(false);
        _showError(err.toString());
      }
    }
  }

  void logout() async {
    if (state.loggedIn) {
      state = state.load(true);
      try {
        if (_auth.currentUser!.isAnonymous) {
          await _auth.currentUser!.delete();
        }
        await _auth.signOut();
      } catch (err) {
        state = AuthState();
        _showError(err.toString());
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
}

class AuthState {
  AuthState({this.user, this.loading = false});
  final User? user;
  final bool loading;
  bool get loggedIn => user != null;
  AuthState load(bool isLoading) => AuthState(user: user, loading: isLoading);
}
