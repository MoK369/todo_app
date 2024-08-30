import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/core/database/collections/tasks_collection.dart';
import 'package:todo_app/core/database/models/task.dart';
import 'package:todo_app/core/firebase_auth/firebase_auth_provider/auth_provider.dart';
import 'package:todo_app/core/providers/localization_provider.dart';
import 'package:todo_app/core/widgets/custom_dialogs/alert_dialogs.dart';
import 'package:todo_app/modules/home_screen/layouts/tasks_layout/widgets/task_item.dart';

class TasksListLayout extends StatefulWidget {
  const TasksListLayout({super.key});

  @override
  State<TasksListLayout> createState() => _TasksListLayoutState();
}

class _TasksListLayoutState extends State<TasksListLayout> {
  late FirebaseAuthProvider authProvider;
  late TasksCollection tasksCollection;

  DateTime selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    authProvider = Provider.of<FirebaseAuthProvider>(context);
    L10nProvider l10nProvider = Provider.of(context);
    tasksCollection = TasksCollection();
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [
                0.7,
                0.3
              ],
                  colors: [
                theme.appBarTheme.backgroundColor!,
                Colors.transparent
              ])),
          child: EasyInfiniteDateTimeLine(
            selectionMode: const SelectionMode.autoCenter(),
            locale: l10nProvider.isArabic() ? "ar" : "en_US",
            dayProps: EasyDayProps(
                dayStructure: DayStructure.dayNumDayStr,
                todayStyle: DayStyle(
                    dayNumStyle: theme.textTheme.bodySmall,
                    dayStrStyle: theme.textTheme.bodySmall,
                    decoration: BoxDecoration(
                        color: theme.appBarTheme.backgroundColor
                            ?.withOpacity(0.4))),
                activeDayStyle: DayStyle(
                    dayNumStyle: theme.textTheme.bodySmall,
                    dayStrStyle: theme.textTheme.bodySmall,
                    decoration: BoxDecoration(
                        color: theme.appBarTheme.backgroundColor)),
                inactiveDayStyle: DayStyle(
                    dayNumStyle: theme.textTheme.bodySmall,
                    dayStrStyle: theme.textTheme.bodySmall,
                    decoration: BoxDecoration(color: theme.cardTheme.color))),
            focusDate: selectedDate,
            onDateChange: (selectedDate) {
              setState(() {
                this.selectedDate = selectedDate;
              });
            },
            firstDate: DateTime.now().subtract(const Duration(days: 365)),
            lastDate: DateTime.now().add(const Duration(days: 365)),
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot<Task>>(
            stream: tasksCollection.getAllTasks(
                authProvider.firebaseAuthUser!.uid, selectedDate),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                        child: Text(
                      textAlign: TextAlign.center,
                      L10nProvider.getTrans(context).checkConnection,
                      style: theme.textTheme.bodyMedium,
                    )),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {});
                        },
                        child: Text(
                          L10nProvider.getTrans(context).tryAgain,
                          style: theme.textTheme.bodyMedium,
                        ))
                  ],
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                List<Task> tasks = [];
                tasks = snapshot.data?.docs.map(
                      (e) {
                        return e.data();
                      },
                    ).toList() ??
                    [];
                if (tasks.isEmpty) {
                  return Center(
                    child: Text(
                      L10nProvider.getTrans(context).noTasksFound,
                      style: theme.textTheme.bodyMedium,
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(
                        top: 50, bottom: 8, left: 10, right: 10),
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                          return TaskItem(
                            task: tasks[index],
                            onDeleteClick: (taskToDelete) {
                              deleteTask(taskToDelete);
                            },
                            onIsDoneClick: (task) {
                              onIsDoneClick(task);
                            },
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 30,
                          );
                        },
                        itemCount: tasks.length),
                  );
                }
              }
            },
          ),
        ),
      ],
    );
  }

  void deleteTask(Task task) async {
    CustomAlertDialogs.showLoadingDialog(context,
        title: L10nProvider.getTrans(context).pleaseWait);
    try {
      await tasksCollection.removeTask(
          authProvider.firebaseAuthUser!.uid, task);
      if (!mounted) return;
      CustomAlertDialogs.hideDialog(context);
    } catch (e) {
      CustomAlertDialogs.hideDialog(context);
      CustomAlertDialogs.showMessageDialog(
        context,
        title: L10nProvider.getTrans(context).unfortunately,
        message:
            L10nProvider.getTrans(context).somethingWentWrong + e.toString(),
        posButtonTitle: L10nProvider.getTrans(context).tryAgain,
        posButtonFun: () {
          deleteTask(task);
        },
      );
    }
  }

  void onIsDoneClick(Task task) async {
    TasksCollection tasksCollection = TasksCollection();
    FirebaseAuthProvider authProvider =
        Provider.of<FirebaseAuthProvider>(context, listen: false);
    try {
      CustomAlertDialogs.showLoadingDialog(context,
          title: L10nProvider.getTrans(context).pleaseWait);
      await tasksCollection.changeIsDone(
          authProvider.firebaseAuthUser!.uid, task);
      if (!mounted) return;
      CustomAlertDialogs.hideDialog(context);
    } catch (e) {
      CustomAlertDialogs.showMessageDialog(context,
          title: L10nProvider.getTrans(context).unfortunately,
          message:
              L10nProvider.getTrans(context).somethingWentWrong + e.toString(),
          posButtonTitle: L10nProvider.getTrans(context).ok);
    }
  }
}
