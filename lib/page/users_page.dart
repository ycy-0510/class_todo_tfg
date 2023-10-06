import 'package:class_todo_list/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UsersPage extends ConsumerWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map<String, String> usersData = ref.watch(usersProvider);
    List<String> userNames = usersData.values.toList()..sort();
    return Scaffold(
      appBar: AppBar(
        title: const Text('成員'),
      ),
      body: ListView.builder(
        itemCount: usersData.keys.length,
        itemBuilder: (context, idx) => ListTile(
          leading: const Icon(Icons.person),
          title: Text(userNames[idx]),
        ),
      ),
    );
  }
}
