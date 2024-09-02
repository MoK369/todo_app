import 'package:flutter/material.dart';
import 'package:todo_app/core/extension_methods/date_time_extension_methods.dart';
import 'package:todo_app/core/extension_methods/time_of_day_extension_methods.dart';
import 'package:todo_app/core/providers/localization_provider.dart';
import 'package:todo_app/modules/home_screen/widgets/date_time_field.dart';
import 'package:todo_app/modules/home_screen/widgets/material_form_field.dart';

class AddEditTaskSheet extends StatefulWidget {
  final String buttonTitle;
  final bool showButton;
  final int? descriptionMaxLines;
  final bool? areFieldsReadOnly;
  final bool initialIsLTR;
  final TextEditingController taskTitleCont,
      taskDesCont,
      taskDateCont,
      taskTimeCont;

  final void Function(GlobalKey<FormState> formKey, DateTime? selectedDate,
      TimeOfDay? selectedTime, bool isLTRResult) buttonFun;
  final Color? fillColorOfAllFields;

  const AddEditTaskSheet(
      {super.key,
      required this.buttonTitle,
      required this.buttonFun,
      this.fillColorOfAllFields,
      required this.taskTitleCont,
      required this.taskDesCont,
      required this.taskDateCont,
      required this.taskTimeCont,
      this.showButton = true,
      this.descriptionMaxLines = 10,
      this.areFieldsReadOnly,
      this.initialIsLTR = true});

  @override
  State<AddEditTaskSheet> createState() => _AddEditTaskSheetState();
}

class _AddEditTaskSheetState extends State<AddEditTaskSheet> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState> taskTitleKey = GlobalKey<FormFieldState>();

  bool? isLTR;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    isLTR ??= widget.initialIsLTR;
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MaterialFormField(
              key: taskTitleKey,
              controller: widget.taskTitleCont,
              textDirection: isLTR! ? TextDirection.ltr : TextDirection.rtl,
              isReadOnly: widget.areFieldsReadOnly,
              fillColor: widget.fillColorOfAllFields,
              validator: (inputText) {
                if (inputText == null || inputText.trim().isEmpty) {
                  return L10nProvider.getTrans(context).enterTaskTitle;
                } else if (inputText.length < 3) {
                  return L10nProvider.getTrans(context).taskTitleIsShort;
                }
                return null;
              },
              hintText: L10nProvider.getTrans(context).taskTitle,
              prefixIcon: Icons.title,
              maxLength: 20,
            ),
            MaterialFormField(
              controller: widget.taskDesCont,
              fillColor: widget.fillColorOfAllFields,
              textDirection: isLTR! ? TextDirection.ltr : TextDirection.rtl,
              isReadOnly: widget.areFieldsReadOnly,
              validator: (inputText) {
                if (inputText == null || inputText.trim().isEmpty) {
                  return L10nProvider.getTrans(context).enterTaskDescription;
                } else if (inputText.length < 5) {
                  return L10nProvider.getTrans(context).taskDescriptionIsShort;
                }
                return null;
              },
              hintText: L10nProvider.getTrans(context).taskDescription,
              prefixIcon: Icons.description,
              maxLines: 10,
              maxLength: 200,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Text(L10nProvider.getTrans(context).ltr),
                  const Spacer(),
                  Transform.scale(
                    scale: 1.3,
                    child: Switch(
                      value: isLTR!,
                      onChanged: (value) {
                        if (widget.areFieldsReadOnly != true) {
                          setState(() {
                            isLTR = value;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            DateTimeField(
              controller: widget.taskDateCont,
              fillColor: widget.fillColorOfAllFields,
              validator: (inputText) {
                if (inputText == null || inputText.trim().isEmpty) {
                  return L10nProvider.getTrans(context).enterTaskDate;
                }
                return null;
              },
              hintText: selectedDate == null
                  ? L10nProvider.getTrans(context).selectDate
                  : widget.taskDateCont.text,
              prefixIcon: Icons.date_range,
              title: L10nProvider.getTrans(context).taskDate,
              onTap: () {
                if (widget.showButton) {
                  showDatePickerDialog();
                }
              },
            ),
            DateTimeField(
              controller: widget.taskTimeCont,
              fillColor: widget.fillColorOfAllFields,
              validator: (inputText) {
                if (inputText == null || inputText.trim().isEmpty) {
                  return L10nProvider.getTrans(context).enterTaskTime;
                }
                return null;
              },
              hintText: selectedTime == null
                  ? L10nProvider.getTrans(context).selectTime
                  : widget.taskTimeCont.text,
              prefixIcon: Icons.timelapse_rounded,
              title: L10nProvider.getTrans(context).taskTime,
              onTap: () {
                if (widget.showButton) {
                  showTimePickerDialog();
                }
              },
            ),
            Visibility(
              visible: widget.showButton,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                    onPressed: () {
                      widget.buttonFun(
                          formKey, selectedDate, selectedTime, isLTR!);
                    },
                    child: Text(
                      widget.buttonTitle,
                      style: theme.textTheme.bodyMedium,
                    )),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  DateTime? selectedDate;

  void showDatePickerDialog() async {
    FocusManager.instance.primaryFocus?.unfocus();
    var date = await showDatePicker(
        context: context,
        initialDate: selectedDate ?? DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)));
    if (date == null) return;

    setState(() {
      selectedDate = date;
      widget.taskDateCont.text = selectedDate!.getDateFormat(context);
    });
  }

  TimeOfDay? selectedTime;

  void showTimePickerDialog() async {
    FocusManager.instance.primaryFocus?.unfocus();
    var time = await showTimePicker(
        builder: (context, child) {
          return MediaQuery(
              data: const MediaQueryData(padding: EdgeInsets.all(50)),
              child: child!);
        },
        context: context,
        initialTime: selectedTime ?? TimeOfDay.now());
    if (time == null) return;

    setState(() {
      selectedTime = time;
      widget.taskTimeCont.text = selectedTime!.getTimeFormat(context);
    });
  }

  @override
  void dispose() {
    super.dispose();
    widget.taskTitleCont.clear();
    widget.taskDesCont.clear();
    widget.taskDateCont.clear();
    widget.taskTimeCont.clear();
  }
}
