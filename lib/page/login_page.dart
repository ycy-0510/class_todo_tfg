import 'package:class_todo_list/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool loading = ref.watch(authProvider).loading;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.all(10),
            width: 400,
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    child: Text(
                      'Login to Use Class Todo List',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  if (loading) const LinearProgressIndicator(),
                  const Icon(
                    Icons.login,
                    size: 100,
                  ),
                  Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      width: 300,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () => loading
                            ? null
                            : ref.read(authProvider.notifier).googleLogin(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text(
                          'Login with Google',
                          style: TextStyle(fontSize: 15),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
