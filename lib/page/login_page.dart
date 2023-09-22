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
                      '登入以繼續使用「共享聯絡簿」',
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
                        onLongPress: loading ? null : () {},
                        onPressed: loading
                            ? null
                            : () =>
                                ref.read(authProvider.notifier).googleLogin(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text(
                          '使用Google登入',
                          style: TextStyle(fontSize: 15),
                        ),
                      )),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    child: Text('©2023 YCY'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
