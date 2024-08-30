import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/core/database/collections/tasks_collection.dart';
import 'package:todo_app/core/extension_methods/date_time_extension_methods.dart';
import 'package:todo_app/core/extension_methods/int_extension_methods.dart';
import 'package:todo_app/core/extension_methods/time_of_day_extension_methods.dart';
import 'package:todo_app/core/firebase_auth/firebase_auth_provider/auth_provider.dart';
import 'package:todo_app/core/providers/localization_provider.dart';
import 'package:todo_app/core/widgets/add_edit_task_sheet.dart';
import 'package:todo_app/core/widgets/custom_dialogs/alert_dialogs.dart';
import 'package:todo_app/modules/home_screen/home_screen.dart';
import 'package:todo_app/modules/home_screen/layouts/tasks_layout/widgets/task_item.dart';

class EditScreen extends StatefulWidget {
  static const String routName = "editScreen";

  const EditScreen({super.key});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  TextEditingController taskTitleCont = TextEditingController(),
      taskDesCont = TextEditingController(),
      taskDateCont = TextEditingController(),
      taskTimeCont = TextEditingController();
  late EditInfo args;
  bool isEdited = false;
  bool? isLTR;

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () {
        taskTitleCont.text = args.task.title!;
        taskDesCont.text = args.task.describtion!;

        if (!mounted) return;
        taskDateCont.text = args.task.date!.getDateFormat(context);
        taskTimeCont.text = args.task.time!.getTimeFormat(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    args = ModalRoute.of(context)?.settings.arguments as EditInfo;
    isLTR ??= args.task.isLTR!;

    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Scaffold(
            appBar: AppBar(
              title: Text(L10nProvider.getTrans(context).toDo),
              leading: IconButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, HomeScreen.routeName);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 35,
                  )),
              actions: [
                args.isReadOnly
                    ? const Icon(
                        Icons.edit_off,
                        size: 35,
                      )
                    : const Icon(
                        Icons.edit,
                        size: 35,
                      )
              ],
            ),
          ),
          Positioned(
            width: size.width * 0.9,
            height: size.height * 0.8,
            top: size.height * 0.15,
            child: Card(
              child: AddEditTaskSheet(
                showButton: !args.isReadOnly,
                descriptionMaxLines: args.isReadOnly ? 50 : null,
                areFieldsReadOnly: args.isReadOnly,
                initialIsLTR: isLTR!,
                buttonTitle: L10nProvider.getTrans(context).save,
                fillColorOfAllFields: theme.scaffoldBackgroundColor,
                taskTitleCont: taskTitleCont,
                taskDesCont: taskDesCont,
                taskTimeCont: taskTimeCont,
                taskDateCont: taskDateCont,
                buttonFun: (formKey, selectedDate, selectedTime, isLTRResult) {
                  isLTR = isLTRResult;
                  updateTask(formKey, selectedDate, selectedTime);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void updateTask(GlobalKey<FormState> formKey, DateTime? selectedDate,
      TimeOfDay? selectedTime) async {
    if (formKey.currentState?.validate() == true) {
      if (!didContentChange()) {
        CustomAlertDialogs.showMessageDialog(context,
            title: L10nProvider.getTrans(context).note,
            message: L10nProvider.getTrans(context).nothingChanged,
            posButtonTitle: L10nProvider.getTrans(context).ok);
        return;
      }
      try {
        FirebaseAuthProvider authProvider = Provider.of(context, listen: false);
        TasksCollection tasksCollection = TasksCollection();
        CustomAlertDialogs.showLoadingDialog(context,
            title: L10nProvider.getTrans(context).saving);

        await tasksCollection.updateTask(
            authProvider.firebaseAuthUser!.uid, args.task,
            newTitle: taskTitleCont.text,
            newDescribtion: taskDesCont.text,
            newDate: selectedDate == null
                ? args.task.date!
                : selectedDate.daySinceEpoch(),
            newTime: selectedTime == null
                ? args.task.time!
                : selectedTime.hourMinuteSinceEpoch(),
            newIsLTR: isLTR!);
        updateSentTask(selectedDate, selectedTime);
        if (!mounted) return;
        CustomAlertDialogs.hideDialog(context);
        CustomAlertDialogs.showMessageDialog(context,
            title: L10nProvider.getTrans(context).done,
            message: L10nProvider.getTrans(context).successfulSave,
            posButtonTitle: L10nProvider.getTrans(context).ok);
      } catch (e) {
        CustomAlertDialogs.showMessageDialog(context,
            title: L10nProvider.getTrans(context).unfortunately,
            message: L10nProvider.getTrans(context).somethingWentWrong +
                e.toString());
      }
    }
  }

  bool didContentChange() {
    if (args.task.title == taskTitleCont.text &&
        args.task.describtion == taskDesCont.text &&
        args.task.date?.getDateFormat(context) == taskDateCont.text &&
        args.task.time?.getTimeFormat(context) == taskTimeCont.text &&
        args.task.isLTR == isLTR) {
      return false;
    } else {
      return true;
    }
  }

  void updateSentTask(DateTime? selectedDate, TimeOfDay? selectedTime) {
    args.task.title = taskTitleCont.text;
    args.task.describtion = taskDesCont.text;
    args.task.date =
        selectedDate == null ? args.task.date! : selectedDate.daySinceEpoch();
    args.task.time = selectedTime == null
        ? args.task.time!
        : selectedTime.hourMinuteSinceEpoch();
    args.task.isLTR = isLTR!;
  }
}
