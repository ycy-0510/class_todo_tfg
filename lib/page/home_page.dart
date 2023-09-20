import 'package:class_todo_list/class_table.dart';
import 'package:class_todo_list/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String? userName = ref.watch(authProvider).user?.displayName;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Class Todo List'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              userName ?? 'Haven\'t login',
              style: const TextStyle(fontSize: 15),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: OutlinedButton(
              onPressed: () => ref.read(authProvider.notifier).logout(),
              child: const Text(
                'Log out',
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Center(
          child: Table(
              border: TableBorder.all(
                  color: Colors.blue,
                  width:
                      2), // Allows to add a border decoration around your table
              children: [
                for (int l = 0; l < 7; l++)
                  TableRow(children: [
                    for (int d = 0; d < 5; d++)
                      Container(
                        height: 60,
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            lesson[d * 7 + l],
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                  ]),
              ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => SimpleDialog(
              title: const Text('New Task'),
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Consumer(
                    builder:
                        (BuildContext context, WidgetRef ref, Widget? child) {
                      return Form(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Name'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            onChanged: (value) => ref
                                .read(formProvider.notifier)
                                .nameChange(value),
                          ),
                          DropdownButton<int>(
                              value: ref.watch(formProvider).type,
                              onChanged: (int? value) => ref
                                  .read(formProvider.notifier)
                                  .typeChange(value!),
                              items: const [
                                DropdownMenuItem<int>(
                                  value: 0,
                                  child: Text('考試'),
                                ),
                                DropdownMenuItem<int>(
                                  value: 1,
                                  child: Text('作業'),
                                ),
                                DropdownMenuItem<int>(
                                  value: 2,
                                  child: Text('報告'),
                                ),
                              ]),
                          TextButton(
                            onPressed: () {
                              showDatePicker(
                                      context: context,
                                      initialDate: ref.read(formProvider).date,
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.now()
                                          .add(const Duration(days: 150)))
                                  .then((DateTime? dateTime) => ref
                                      .read(formProvider.notifier)
                                      .dateChange(dateTime!));
                            },
                            style: TextButton.styleFrom(),
                            child: Text(
                              ref
                                  .watch(formProvider)
                                  .date
                                  .toString()
                                  .split('.')[0],
                              style: const TextStyle(fontSize: 18),
                            ),
                          )
                        ],
                      ));
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(),
                      child: const Text('Save'),
                    )
                  ],
                )
              ],
            ),
          );
        },
        child: const Icon(Icons.add_task),
      ),
    );
  }
}
