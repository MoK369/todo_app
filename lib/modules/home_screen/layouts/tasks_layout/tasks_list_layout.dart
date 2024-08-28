import 'package:flutter/material.dart';
import 'package:todo_app/modules/home_screen/layouts/tasks_layout/widgets/task_item.dart';

class TasksListLayout extends StatelessWidget {
  const TasksListLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 100, bottom: 8, left: 10, right: 10),
      child: ListView.separated(
          itemBuilder: (context, index) {
            return const TaskItem();
          },
          separatorBuilder: (context, index) {
            return const SizedBox(
              height: 30,
            );
          },
          itemCount: 5),
    );
  }
}
