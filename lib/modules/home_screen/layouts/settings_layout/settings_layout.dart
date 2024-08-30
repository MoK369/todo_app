import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/core/firebase_auth/firebase_auth_provider/auth_provider.dart';
import 'package:todo_app/core/providers/localization_provider.dart';
import 'package:todo_app/core/providers/theme_provider.dart';
import 'package:todo_app/core/widgets/custom_dialogs/alert_dialogs.dart';
import 'package:todo_app/modules/home_screen/layouts/settings_layout/widgets/custom_drop_down_button.dart';
import 'package:todo_app/modules/login/login_screen.dart';

import '../../../../core/database/collections/users_collection.dart';

class SettingsLayout extends StatefulWidget {
  const SettingsLayout({super.key});

  @override
  State<SettingsLayout> createState() => _SettingsLayoutState();
}

class _SettingsLayoutState extends State<SettingsLayout> {
  final UsersCollection usersCollection = UsersCollection();

  final List<String> locales = ["English", "العربية"];
  List<String> modes = [];

  String currentLocaleDropDownValue = "";
  String currentModesDropDownValue = "";

  @override
  Widget build(BuildContext context) {
    FirebaseAuthProvider authProvider =
        Provider.of<FirebaseAuthProvider>(context);
    L10nProvider l10nProvider = Provider.of(context);
    ThemeProvider themeProvider = Provider.of(context);
    ThemeData theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;
    modes = [
      L10nProvider.getTrans(context).light,
      L10nProvider.getTrans(context).dark,
      L10nProvider.getTrans(context).system,
    ];
    currentModesDropDownValue =
        (themeProvider.currentAppTheme == ThemeMode.light)
            ? modes[0]
            : (themeProvider.currentAppTheme == ThemeMode.dark)
                ? modes[1]
                : modes[2];
    currentLocaleDropDownValue =
        l10nProvider.isArabic() ? locales[1] : locales[0];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: size.height * 0.02,
          ),
          const Center(
              child: CircleAvatar(
            radius: 80,
            child: Icon(
              Icons.person,
              size: 60,
            ),
          )),
          Padding(
            padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
            child: Text(
              textAlign: TextAlign.center,
              "${authProvider.firebaseAuthUser?.email}",
              style: theme.textTheme.bodyMedium,
            ),
          ),
          CustomDropDownButton(
            title: L10nProvider.getTrans(context).language,
            icon: Icons.language,
            currentDropDownValue: currentLocaleDropDownValue,
            dropDownList: locales,
            onChanged: (value) {
              setState(() {
                currentLocaleDropDownValue = value!;
              });
            },
            onTap: (listElement) {
              if (listElement == "English") {
                l10nProvider.changeLocale('en');
              } else {
                l10nProvider.changeLocale('ar');
              }
            },
          ),
          SizedBox(
            height: size.height * 0.03,
          ),
          CustomDropDownButton(
            title: L10nProvider.getTrans(context).mode,
            icon: Icons.brightness_2,
            currentDropDownValue: currentModesDropDownValue,
            dropDownList: modes,
            onChanged: (value) {
              setState(() {
                currentModesDropDownValue = value!;
              });
            },
            onTap: (listElement) {
              if (listElement == modes[0]) {
                themeProvider.changeTheme('light');
              } else if (listElement == modes[1]) {
                themeProvider.changeTheme('dark');
              } else {
                themeProvider.changeTheme('system');
              }
            },
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
            child: ListTile(
              tileColor: theme.scaffoldBackgroundColor,
              onTap: () {
                authProvider.logOut();
                Navigator.pushReplacementNamed(context, LoginScreen.routeName);
              },
              leading: const Icon(
                Icons.logout,
                size: 30,
                color: Colors.red,
              ),
              title: Text(
                L10nProvider.getTrans(context).logOut,
                style: theme.textTheme.bodyMedium!.copyWith(color: Colors.red),
              ),
            ),
          ),
          ListTile(
            tileColor: theme.scaffoldBackgroundColor,
            onTap: () {
              try {
                CustomAlertDialogs.showMessageDialog(context,
                    title: L10nProvider.getTrans(context).alert,
                    message:
                        L10nProvider.getTrans(context).carefulDeleteAccount,
                    posButtonTitle: L10nProvider.getTrans(context).okDelete,
                    posButtonFun: () async {
                  CustomAlertDialogs.showLoadingDialog(context,
                      title: L10nProvider.getTrans(context).pleaseWait);
                  await authProvider.deleteAccount(
                      context, authProvider.firebaseAuthUser!.uid);
                  if (!mounted) return;
                  CustomAlertDialogs.hideDialog(context);
                  Navigator.pushReplacementNamed(
                      context, LoginScreen.routeName);
                  CustomAlertDialogs.showMessageDialog(context,
                      title: L10nProvider.getTrans(context).done,
                      message:
                          L10nProvider.getTrans(context).deletedSuccessfully,
                      posButtonTitle: L10nProvider.getTrans(context).ok);
                }, negButtonTitle: L10nProvider.getTrans(context).cancel);
              } catch (e) {
                CustomAlertDialogs.showMessageDialog(context,
                    title: L10nProvider.getTrans(context).note,
                    message: L10nProvider.getTrans(context).somethingWentWrong +
                        e.toString());
              }
            },
            leading: const Icon(
              Icons.delete,
              size: 30,
              color: Colors.red,
            ),
            title: Text(
              L10nProvider.getTrans(context).deleteAccount,
              style: theme.textTheme.bodyMedium!.copyWith(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
