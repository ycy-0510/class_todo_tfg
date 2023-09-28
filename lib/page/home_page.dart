import 'package:class_todo_list/class_table.dart';
import 'package:class_todo_list/logic/connectivety_notifier.dart';
import 'package:class_todo_list/logic/form_notifier.dart';
import 'package:class_todo_list/logic/task_notifier.dart';
import 'package:class_todo_list/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String? userName = ref.watch(authProvider).user?.displayName;

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(),
        title: Column(children: [
          const Text('共享聯絡簿'),
          Text(
            userName ?? '訪客',
            style: const TextStyle(fontSize: 15),
          ),
        ]),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: OutlinedButton.icon(
              onPressed: () => ref.read(authProvider.notifier).logout(),
              icon: const Icon(Icons.logout),
              label: const Text(
                '登出',
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () => ref.read(dateProvider.notifier).lastWeek(),
                  icon: const Icon(Icons.arrow_back_ios_new),
                  tooltip: '上週',
                ),
                OutlinedButton(
                    onPressed: () => ref.read(dateProvider.notifier).today(),
                    child: const Text(
                      '今天',
                      style: TextStyle(fontSize: 18),
                    )),
                IconButton(
                  onPressed: () => ref.read(dateProvider.notifier).nextWeek(),
                  icon: const Icon(Icons.arrow_forward_ios),
                  tooltip: '下週',
                ),
              ],
            ),
          ),
        ),
      ),
      body: const HomeBody(),
      floatingActionButton: ref.watch(authProvider).user!.isAnonymous
          ? null
          : FloatingActionButton(
              tooltip: '新增事項',
              onPressed: () {
                ref.read(formProvider.notifier).dateChange(DateTime.now());
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) => const TaskForm());
              },
              child: const Icon(Icons.add_task),
            ),
    );
  }
}

class HomeBody extends ConsumerWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TaskState taskState = ref.watch(taskProvider);
    List<Task> tasks = taskState.tasks;
    List<Task> showTasks = [];
    bool showPast = ref.watch(pastSwitchProvider);
    for (int i = 0; i < tasks.length; i++) {
      if (tasks[i].date.isAfter(ref.watch(nowTimeProvider)) || showPast) {
        showTasks.add(tasks[i]);
      }
    }

    return Center(
      child: Builder(builder: (context) {
        if (ref.watch(connectivityStatusProvider) ==
            ConnectivityStatus.isConnected) {
          if (!taskState.loading) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Table(
                        border: TableBorder.all(color: Colors.blue, width: 2),
                        children: [
                          TableRow(children: [
                            for (int d = 0; d < 5; d++)
                              Builder(builder: (context) {
                                DateTime today = ref.watch(dateProvider).now;
                                DateTime date = ref
                                    .watch(dateProvider)
                                    .sunday
                                    .add(Duration(days: d + 1));
                                bool isToday = false;
                                if (date.isBefore(today) &&
                                    date
                                        .add(const Duration(days: 1))
                                        .isAfter(today)) {
                                  isToday = true;
                                }
                                int month = date.month;
                                int day = date.day;
                                return Container(
                                  height: 60,
                                  alignment: Alignment.center,
                                  child: Text(
                                    '$month/$day',
                                    style: TextStyle(
                                      fontSize: isToday ? 18 : 15,
                                      color: isToday ? Colors.blue : null,
                                      fontWeight:
                                          isToday ? FontWeight.bold : null,
                                    ),
                                  ),
                                );
                              }),
                          ]),
                          for (int l = 0; l < 7; l++)
                            TableRow(
                                decoration: l == 3
                                    ? const BoxDecoration(
                                        border: Border(
                                        bottom: BorderSide(
                                            width: 5,
                                            color: Colors.blue,
                                            strokeAlign:
                                                BorderSide.strokeAlignInside),
                                      ))
                                    : null,
                                children: [
                                  for (int d = 0; d < 5; d++)
                                    Container(
                                      margin: l == 3
                                          ? const EdgeInsets.only(bottom: 5)
                                          : null,
                                      color: classColor(
                                          d + 1, l, tasks, Theme.of(context)),
                                      height: 60,
                                      alignment: Alignment.center,
                                      child: TextButton(
                                        onPressed: () {
                                          showModalBottomSheet(
                                              showDragHandle: true,
                                              context: context,
                                              builder: (context) => BottomSheet(
                                                  className: lesson[d * 7 + l],
                                                  weekDay: d + 1,
                                                  lessonIdx: l));
                                        },
                                        child: Text(
                                          lesson[d * 7 + l],
                                          style: TextStyle(
                                            fontSize: 15,
                                            color:
                                                Theme.of(context).brightness ==
                                                        Brightness.light
                                                    ? Colors.black
                                                    : Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                ]),
                        ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '整週項目表',
                          style: TextStyle(fontSize: 20),
                        ),
                        Row(
                          children: [
                            const Text(
                              '顯示過去項目',
                              style: TextStyle(fontSize: 15),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Switch(
                              value: showPast,
                              onChanged: (value) => ref
                                  .read(pastSwitchProvider.notifier)
                                  .update((state) => value),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  TaskListView(
                    showTasks,
                    showDateTitle: true,
                    canScroll: false,
                  ),
                  const SizedBox(height: 40),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      '共享聯絡簿 by YCY',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  height: 20,
                ),
                Text('共享聯絡簿 by YCY'),
              ],
            );
          }
        } else {
          return const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cloud_off,
                size: 50,
              ),
              Text('您已離線，請連接網路以繼續使用'),
              SizedBox(
                height: 20,
              ),
              Text('共享聯絡簿 by YCY'),
            ],
          );
        }
      }),
    );
  }

  Color? classColor(
      int weekDay, int lessonIdx, List<Task> tasks, ThemeData themeData) {
    int counter = 0;
    for (Task task in tasks) {
      if (task.classTime == lessonIdx && task.date.weekday == weekDay) {
        counter++;
      }
    }
    switch (counter) {
      case 0:
        return null;
      case 1:
        return themeData.colorScheme.tertiaryContainer;
      case 2:
        return themeData.colorScheme.secondaryContainer;
    }
    return themeData.colorScheme.primaryContainer;
  }
}

class TaskListView extends ConsumerWidget {
  const TaskListView(this.tasks,
      {this.showDateTitle = false, this.canScroll = true, super.key});

  final bool showDateTitle;
  final bool canScroll;
  final List<Task> tasks;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map<String, String> usersData = ref.watch(usersProvider);

    return ListView.builder(
      physics: canScroll
          ? const BouncingScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      shrinkWrap: !canScroll,
      itemCount: tasks.length * 2,
      itemBuilder: (context, allIndex) {
        int idx = allIndex ~/ 2;
        if (allIndex % 2 == 1) {
          String lessonName = tasks[idx].classTime == -1
              ? '其他時段'
              : '第${tasks[idx].classTime + 1}節 ${lesson[(tasks[idx].date.weekday - 1) * 7 + tasks[idx].classTime]}';
          return ListTile(
            leading: const Icon(Icons.task_alt),
            title: Text(tasks[idx].name),
            subtitle: Text('$lessonName ${[
              '考試',
              '作業',
              '報告',
              '提醒',
            ][tasks[idx].type]}'),
            trailing: Text(
              '${tasks[idx].date.toString().split('.')[0]}\n${usersData[tasks[idx].userId] ?? '未知建立者'}',
            ),
            onTap: () async {
              await Clipboard.setData(ClipboardData(text: tasks[idx].name));
              Fluttertoast.showToast(
                msg: '已複製',
                timeInSecForIosWeb: 1,
                webShowClose: true,
              );
            },
            onLongPress: tasks[idx].userId == ref.watch(authProvider).user?.uid
                ? () {
                    ref.read(formProvider.notifier).startUpdate(tasks[idx]);
                    showDialog(
                      context: context,
                      builder: (context) => const TaskForm(),
                    );
                  }
                : null,
          );
        } else {
          if ((idx == 0
                  ? true
                  : tasks[idx].date.day != tasks[idx - 1].date.day) &&
              showDateTitle) {
            return Container(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Text('${tasks[idx].date.toString().split(' ')[0]}  週${[
                '日',
                'ㄧ',
                '二',
                '三',
                '四',
                '五',
                '六'
              ][tasks[idx].date.weekday % 7]}'),
            );
          } else {
            return const Divider();
          }
        }
      },
    );
  }
}

class TaskForm extends ConsumerStatefulWidget {
  const TaskForm({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TaskFormState();
}

class _TaskFormState extends ConsumerState<TaskForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _controller.text = ref.read(formProvider).name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(20),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(ref.watch(formProvider).formStatus == TaskFormStatus.create
              ? '新增項目'
              : '修改項目'),
          IconButton(
              onPressed: () {
                Navigator.of(context).pop();
                ref.read(formProvider.notifier).editFinish();
              },
              icon: const Icon(Icons.close))
        ],
      ),
      children: [
        Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _controller,
                decoration: const InputDecoration(hintText: '項目名稱'),
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 2) {
                    return '請輸入項目名稱';
                  }
                  return null;
                },
                onChanged: (value) =>
                    ref.read(formProvider.notifier).nameChange(value),
              ),
              DropdownButton<int>(
                  value: ref.watch(formProvider).type,
                  onChanged: (int? value) =>
                      ref.read(formProvider.notifier).typeChange(value!),
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
                    DropdownMenuItem<int>(
                      value: 3,
                      child: Text('提醒'),
                    ),
                  ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      showDatePicker(
                              context: context,
                              initialDate: ref.read(formProvider).date,
                              firstDate: DateTime.now(),
                              lastDate:
                                  DateTime.now().add(const Duration(days: 150)))
                          .then((DateTime? dateTime) => ref
                              .read(formProvider.notifier)
                              .dateChange(dateTime!));
                    },
                    style: TextButton.styleFrom(),
                    child: Text(
                      ref.watch(formProvider).date.toString().split(' ')[0],
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      showTimePicker(
                        context: context,
                        initialTime:
                            TimeOfDay.fromDateTime(ref.read(formProvider).date),
                      ).then((TimeOfDay? time) =>
                          ref.read(formProvider.notifier).timeChange(time!));
                    },
                    style: TextButton.styleFrom(),
                    child: Text(
                      ref
                          .watch(formProvider)
                          .date
                          .toString()
                          .split(' ')[1]
                          .split('.')[0],
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        if (ref.watch(formProvider).formStatus == TaskFormStatus.create)
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Fluttertoast.showToast(
                  msg: '建立資料中',
                  timeInSecForIosWeb: 1,
                  webShowClose: true,
                );
                Navigator.of(context).pop();
                ref.read(formProvider.notifier).create();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text('建立'),
          ),
        if (ref.watch(formProvider).formStatus == TaskFormStatus.update)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Fluttertoast.showToast(
                      msg: '更新資料中',
                      timeInSecForIosWeb: 1,
                      webShowClose: true,
                    );
                    Navigator.of(context).pop();
                    ref.read(formProvider.notifier).update();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('更新'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onLongPress: () async {
                  if (_formKey.currentState!.validate()) {
                    Fluttertoast.showToast(
                      msg: '刪除資料中',
                      timeInSecForIosWeb: 1,
                      webShowClose: true,
                    );
                    Navigator.of(context).pop();
                    ref.read(formProvider.notifier).remove();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: null,
                child: const Text('長按刪除'),
              ),
            ],
          ),
      ],
    );
  }
}

class BottomSheet extends ConsumerWidget {
  const BottomSheet(
      {required this.className,
      required this.weekDay,
      required this.lessonIdx,
      super.key});
  final String className;
  final int weekDay;
  final int lessonIdx;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TaskState taskState = ref.watch(taskProvider);
    List<Task> tasks = taskState.tasks;
    List<Task> tasksForThisClass = [];
    for (Task task in tasks) {
      if (task.classTime == lessonIdx && task.date.weekday == weekDay) {
        tasksForThisClass.add(task);
      }
    }

    DateTime date = ref.watch(dateProvider).sunday.add(Duration(days: weekDay));

    return SizedBox(
      height: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${date.month}/${date.day} 第${lessonIdx + 1}節 $className',
                  style: const TextStyle(fontSize: 22.5),
                ),
                if (!ref.watch(authProvider).user!.isAnonymous)
                  IconButton(
                    onPressed: () {
                      ref.read(formProvider.notifier).dateChange(DateTime(
                          date.year,
                          date.month,
                          date.day,
                          classTimes[lessonIdx].hour,
                          classTimes[lessonIdx].minute));
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) => const TaskForm());
                    },
                    icon: const Icon(Icons.add_task),
                    tooltip: '新增事項在這一節課',
                  ),
              ],
            ),
          ),
          Expanded(
            child: TaskListView(tasksForThisClass),
          ),
        ],
      ),
    );
  }
}
