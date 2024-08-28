import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app/core/app_themes/app_themes.dart';

class TaskItem extends StatelessWidget {
  const TaskItem({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    String text = 'Task Title';
    String content = 'Content';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: InkWell(
        onTap: () {},
        child: Slidable(
          key: const ValueKey(0),
          startActionPane: ActionPane(
            dismissible: DismissiblePane(
              onDismissed: () {},
            ),
            extentRatio: 0.5,
            motion: const BehindMotion(),
            children: [
              SlidableAction(
                onPressed: (context) {},
                icon: Icons.delete,
                label: 'Delete',
                backgroundColor: const Color(0xFFEC4B4B),
                foregroundColor: Colors.white,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30)),
                spacing: 5,
              ),
              SlidableAction(
                onPressed: (context) {},
                icon: Icons.edit,
                label: 'Edit',
                backgroundColor: AppThemes.lightOnSecondaryColor,
                foregroundColor: Colors.white,
                spacing: 5,
              )
            ],
          ),
          child: SizedBox(
            height: 170,
            child: Card(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 5,
                    height: 100,
                    margin: const EdgeInsets.all(25),
                    decoration: const BoxDecoration(
                        color: AppThemes.lightOnSecondaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          text,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: Text(
                            content,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.watch_later_outlined,
                                color: theme.textTheme.bodySmall!.color,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text("10:00 AM"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {},
                      child: const ImageIcon(
                          AssetImage("assets/icons/check_icon.png"))),
                  const SizedBox(
                    width: 15,
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
