import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/core/firebase_auth/firebase_auth_provider/auth_provider.dart';
import 'package:todo_app/modules/home_screen/layouts/settings_layout/settings_layout.dart';
import 'package:todo_app/modules/home_screen/layouts/tasks_layout/tasks_list_layout.dart';
import 'package:todo_app/modules/home_screen/widgets/add_task_bottom_sheet.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "HomeScreen";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentBarItemIndex = 0;
  List<Widget> bottomBarTabs = [
    const TasksListLayout(),
    SettingsLayout(),
  ];
  PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuthProvider authProvider = Provider.of(context);
    final ThemeData theme = Theme.of(context);
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 70,
          leading: const Padding(
            padding: EdgeInsets.only(left: 10),
            child: CircleAvatar(
              child: Icon(
                Icons.person,
                size: 30,
              ),
            ),
          ),
          title: Text(currentBarItemIndex == 0
              ? "Hi, ${authProvider.appUser?.fullName}"
              : "Settings"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showAddTaskBottomSheet();
          },
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
                BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
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
    );
  }

  void showAddTaskBottomSheet() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        showDragHandle: true,
        builder: (context) {
          return AddTaskBottomSheet();
        });
  }
}
