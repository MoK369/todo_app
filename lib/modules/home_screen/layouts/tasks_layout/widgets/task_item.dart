import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/core/app_themes/app_themes.dart';
import 'package:todo_app/core/database/models/task.dart';
import 'package:todo_app/core/extension_methods/int_extension_methods.dart';
import 'package:todo_app/core/providers/localization_provider.dart';
import 'package:todo_app/core/widgets/custom_dialogs/alert_dialogs.dart';
import 'package:todo_app/modules/edit/edit_screen.dart';

typedef OnClick = void Function(Task);

class TaskItem extends StatelessWidget {
  final OnClick onDeleteClick;
  final OnClick onIsDoneClick;
  final Task task;

  const TaskItem({
    super.key,
    required this.task,
    required this.onDeleteClick,
    required this.onIsDoneClick,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    L10nProvider l10nProvider = Provider.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: InkWell(
        onTap: () {
          Navigator.pushReplacementNamed(context, EditScreen.routName,
              arguments: EditInfo(task: task, isReadOnly: true));
        },
        child: Slidable(
          key: const ValueKey(0),
          startActionPane: ActionPane(
            dismissible: DismissiblePane(
              onDismissed: () {
                CustomAlertDialogs.showMessageDialog(
                  context,
                  title: L10nProvider.getTrans(context).alert,
                  message: L10nProvider.getTrans(context).carefulDeleteTask,
                  posButtonTitle: L10nProvider.getTrans(context).confirm,
                  posButtonFun: () {
                    onDeleteClick(task);
                  },
                  negButtonTitle: L10nProvider.getTrans(context).cancel,
                );
              },
            ),
            extentRatio: 0.5,
            motion: const BehindMotion(),
            children: [
              SlidableAction(
                onPressed: (context) {
                  CustomAlertDialogs.showMessageDialog(
                    context,
                    title: L10nProvider.getTrans(context).alert,
                    message: L10nProvider.getTrans(context).carefulDeleteTask,
                    posButtonTitle: L10nProvider.getTrans(context).confirm,
                    posButtonFun: () {
                      onDeleteClick(task);
                    },
                    negButtonTitle: L10nProvider.getTrans(context).cancel,
                  );
                },
                icon: Icons.delete,
                label: L10nProvider.getTrans(context).delete,
                backgroundColor: const Color(0xFFEC4B4B),
                foregroundColor: Colors.white,
                borderRadius: l10nProvider.isArabic()
                    ? const BorderRadius.only(
                        topRight: Radius.circular(30),
                        bottomRight: Radius.circular(30))
                    : const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        bottomLeft: Radius.circular(30)),
                spacing: 5,
              ),
              SlidableAction(
                onPressed: (context) {
                  Navigator.pushReplacementNamed(context, EditScreen.routName,
                      arguments: EditInfo(task: task, isReadOnly: false));
                },
                icon: Icons.edit,
                label: L10nProvider.getTrans(context).edit,
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
                    decoration: BoxDecoration(
                        color: task.isDone == true
                            ? const Color(0xFf61E757)
                            : AppThemes.lightOnSecondaryColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(25))),
                  ),
                  Expanded(
                    child: Directionality(
                      textDirection: task.isLTR != true
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.title ?? "",
                            overflow: TextOverflow.ellipsis,
                            style: task.isDone == true
                                ? theme.textTheme.bodyMedium
                                    ?.copyWith(color: const Color(0xFf61E757))
                                : theme.textTheme.titleMedium,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Text(
                              task.description ?? "",
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall,
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
                                Text(
                                  "${task.time?.getTimeFormat(context)}",
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  task.isDone == true
                      ? TextButton(
                          onPressed: () {
                            onIsDoneClick(task);
                          },
                          child: Text(
                            L10nProvider.getTrans(context).done,
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(color: const Color(0xFf61E757)),
                          ))
                      : ElevatedButton(
                          onPressed: () {
                            onIsDoneClick(task);
                          },
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

class EditInfo {
  Task task;
  bool isReadOnly;

  EditInfo({required this.task, required this.isReadOnly});
}
