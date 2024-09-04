import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/core/database/collections/tasks_collection.dart';
import 'package:todo_app/core/database/models/task.dart';
import 'package:todo_app/core/firebase_auth/firebase_auth_provider/auth_provider.dart';
import 'package:todo_app/core/providers/localization_provider.dart';
import 'package:todo_app/core/widgets/add_edit_task_sheet.dart';
import 'package:todo_app/core/widgets/custom_dialogs/alert_dialogs.dart';
import 'package:todo_app/modules/home_screen/layouts/settings_layout/settings_layout.dart';
import 'package:todo_app/modules/home_screen/layouts/tasks_layout/tasks_list_layout.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "HomeScreen";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController taskTitleCont = TextEditingController(),
      taskDesCont = TextEditingController(),
      taskDateCont = TextEditingController(),
      taskTimeCont = TextEditingController();
  bool? isLTR;
  int currentBarItemIndex = 0;
  List<Widget> bottomBarTabs = [
    const TasksListLayout(),
    const SettingsLayout(),
  ];
  PageController pageController = PageController(initialPage: 0);
  late ThemeData theme;
  DateTime? lastPressed;
  late FirebaseAuthProvider authProvider;
  late Size size;
  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of(context);
    size = MediaQuery.of(context).size;
    theme = Theme.of(context);
    L10nProvider l10nProvider = Provider.of(context);
    if (isLTR == null) {
      l10nProvider.isArabic() ? isLTR = false : isLTR = true;
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        DateTime now = DateTime.now();
        bool isWarning = (lastPressed == null) ||
            (now.difference(lastPressed!) > const Duration(seconds: 2));

        if (isWarning) {
          lastPressed = DateTime.now();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Press back again to exit"),
            duration: Duration(seconds: 2),
          ));
          return;
        }
        SystemNavigator.pop();
        isWarning = false;
        lastPressed = null;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: size.height * 0.1,
            leadingWidth: size.width * 0.17,
            leading: const Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: CircleAvatar(
                child: Icon(
                  Icons.person,
                  size: 35,
                ),
              ),
            ),
            title: Text(currentBarItemIndex == 0
                ? L10nProvider.getTrans(context).hi +
                    (authProvider.appUser?.fullName ?? "")
                : L10nProvider.getTrans(context).settings),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showAddTaskBottomSheet();
            },
            child: const Icon(Icons.add),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomAppBar(
            height: size.height * 0.1,
            notchMargin: 12,
            child: BottomNavigationBar(
                currentIndex: currentBarItemIndex,
                onTap: (pressedItemIndex) {
                  setState(() {
                    currentBarItemIndex = pressedItemIndex;
                    pageController.animateToPage(currentBarItemIndex,
                        duration: const Duration(milliseconds: 30),
                        curve: Curves.bounceIn);
                  });
                },
                iconSize: size.height * 0.035,
                items: const [
                  BottomNavigationBarItem(icon: Icon(Icons.list), label: ''),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.settings), label: ''),
                ]),
          ),
          body: PageView(
              controller: pageController,
              onPageChanged: (changedPageIndex) {
                setState(() {
                  currentBarItemIndex = changedPageIndex;
                });
              },
              children: bottomBarTabs),
        ),
      ),
    );
  }

  void showAddTaskBottomSheet() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        showDragHandle: true,
        builder: (context) {
          return GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            onDoubleTap: () {
              Navigator.pop(context);
            },
            child: Container(
              color: theme.scaffoldBackgroundColor,
              child: AddEditTaskSheet(
                initialIsLTR: isLTR!,
                taskTitleCont: taskTitleCont,
                taskDesCont: taskDesCont,
                taskDateCont: taskDateCont,
                taskTimeCont: taskTimeCont,
                buttonTitle: L10nProvider.getTrans(context).addTask,
                buttonFun: (formKey, selectedDate, selectedTime, isLTRResult) {
                  isLTR = isLTRResult;
                  addTask(formKey, selectedDate, selectedTime);
                },
              ),
            ),
          );
        });
  }

  void addTask(GlobalKey<FormState> formKey, DateTime? selectedDate,
      TimeOfDay? selectedTime) async {
    if (formKey.currentState?.validate() == true) {
      FirebaseAuthProvider authProvider =
          Provider.of<FirebaseAuthProvider>(context, listen: false);
      TasksCollection tasksCollection = TasksCollection();
      Task newTask = Task(
          title: taskTitleCont.text,
          description: taskDesCont.text,
          date: DateTime(selectedDate!.year, selectedDate.month,
                  selectedDate.day, selectedTime!.hour, selectedTime.minute)
              .millisecondsSinceEpoch,
          isLTR: isLTR);

      try {
        CustomAlertDialogs.showLoadingDialog(context,
            title: L10nProvider.getTrans(context).pleaseWait,
            isDismissible: false);
        var connectivityResult = await (Connectivity().checkConnectivity());
        if (connectivityResult.contains(ConnectivityResult.none)) {
          if (!mounted) return;
          CustomAlertDialogs.hideDialog(context);
          CustomAlertDialogs.showMessageDialog(context,
              title: L10nProvider.getTrans(context).unfortunately,
              message: L10nProvider.getTrans(context).checkConnection,
              posButtonTitle: L10nProvider.getTrans(context).ok);
          return;
        }

        await tasksCollection.createTask(
            authProvider.firebaseAuthUser!.uid, newTask);
        if (!mounted) return;
        CustomAlertDialogs.hideDialog(context);
        CustomAlertDialogs.showMessageDialog(
          context,
          title: L10nProvider.getTrans(context).done,
          message: L10nProvider.getTrans(context).taskAddedSuccessfully,
          posButtonTitle: L10nProvider.getTrans(context).ok,
          posButtonFun: () {
            Navigator.pop(context);
          },
        );
      } catch (e) {
        CustomAlertDialogs.hideDialog(context);
        CustomAlertDialogs.showMessageDialog(context,
            title: L10nProvider.getTrans(context).unfortunately,
            message: L10nProvider.getTrans(context).somethingWentWrong +
                e.toString(),
            posButtonTitle: L10nProvider.getTrans(context).ok);
      }
    }
  }
}
