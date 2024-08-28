import 'package:flutter/material.dart';
import 'package:todo_app/core/app_themes/app_themes.dart';
import 'package:todo_app/modules/home_screen/widgets/date_time_field.dart';
import 'package:todo_app/modules/home_screen/widgets/material_form_field.dart';

class AddTaskBottomSheet extends StatefulWidget {
  const AddTaskBottomSheet({super.key});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  TextEditingController taskTitleCont = TextEditingController(),
      taskDesCont = TextEditingController(),
      taskDateCont = TextEditingController(),
      taskTimeCont = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    ;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      onDoubleTap: () {
        Navigator.pop(context);
      },
      child: Container(
        color: AppThemes.darkPrimaryColor,
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MaterialFormField(
                controller: taskTitleCont,
                validator: (inputText) {
                  if (inputText == null || inputText.trim().isEmpty) {
                    return "Please, enter Task Title";
                  } else if (inputText.length < 3) {
                    return "Task Title is too short";
                  }
                  return null;
                },
                hintText: "Task Title",
                prefixIcon: Icons.title,
                maxLength: 20,
              ),
              MaterialFormField(
                controller: taskDesCont,
                validator: (inputText) {
                  if (inputText == null || inputText.trim().isEmpty) {
                    return "Please, enter Task Describtion";
                  } else if (inputText.length < 5) {
                    return "Task Describtion is too short";
                  }
                  return null;
                },
                hintText: "Task Describtion",
                prefixIcon: Icons.description,
                maxLines: 10,
                maxLength: 200,
              ),
              Row(
                children: [
                  Expanded(
                      child: DateTimeField(
                    controller: taskDateCont,
                    validator: (inputText) {
                      if (inputText == null || inputText.trim().isEmpty) {
                        return "Please, enter\nTask Date";
                      }
                      return null;
                    },
                    hintText: selectedDate == null
                        ? "Select Date"
                        : taskDateCont.text,
                    prefixIcon: Icons.date_range,
                    title: "Task Date",
                    onTap: () {
                      showDatePickerDialog();
                    },
                  )),
                  Expanded(
                      child: DateTimeField(
                    controller: taskTimeCont,
                    validator: (inputText) {
                      if (inputText == null || inputText.trim().isEmpty) {
                        return "Please, enter\nTask Time";
                      }
                      return null;
                    },
                    hintText: selectedTime == null
                        ? "Select Time"
                        : taskTimeCont.text,
                    prefixIcon: Icons.timelapse_rounded,
                    title: "Task Time",
                    onTap: () {
                      showTimePickerDialog();
                    },
                  )),
                ],
              ),
              const Spacer(),
              ElevatedButton(
                  onPressed: () {
                    addTask();
                  },
                  child: Text(
                    'Add Task',
                    style: theme.textTheme.bodyMedium,
                  )),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  DateTime? selectedDate;

  void showDatePickerDialog() async {
    var date = await showDatePicker(
        context: context,
        initialDate: selectedDate ?? DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)));
    if (date == null) return;

    setState(() {
      selectedDate = date;
      taskDateCont.text =
          "${selectedDate?.year}/${selectedDate?.month}/${selectedDate?.day}";
      // taskDateCont.addListener(
      //   () {
      //     taskDateCont.text;
      //   },
      // );
    });
  }

  TimeOfDay? selectedTime;

  void showTimePickerDialog() async {
    var time = await showTimePicker(
        builder: (context, child) {
          Size size = MediaQuery.sizeOf(context);
          return MediaQuery(
              data: MediaQueryData(padding: EdgeInsets.all(50)), child: child!);
        },
        context: context,
        initialTime: selectedTime ?? TimeOfDay.now());
    if (time == null) return;

    setState(() {
      selectedTime = time;
      taskTimeCont.text =
          "${selectedTime?.hour}:${selectedTime!.minute < 10 ? "0${selectedTime?.minute}" : selectedTime?.minute}";
    });
  }

  void addTask() {
    if (formKey.currentState?.validate() == true) {}
  }
}
