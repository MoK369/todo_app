import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/core/firebase_auth/firebase_auth_provider/auth_provider.dart';
import 'package:todo_app/core/widgets/custom_dialogs/alert_dialogs.dart';
import 'package:todo_app/modules/login/login_screen.dart';

import '../../../../core/database/collections/users_collection.dart';

class SettingsLayout extends StatelessWidget {
  SettingsLayout({super.key});

  final UsersCollection usersCollection = UsersCollection();

  @override
  Widget build(BuildContext context) {
    FirebaseAuthProvider authProvider =
        Provider.of<FirebaseAuthProvider>(context);
    ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const Center(
            child: CircleAvatar(
          radius: 80,
          child: Icon(
            Icons.person,
            size: 60,
          ),
        )),
        ListTile(
          tileColor: Colors.white,
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
            "Log Out",
            style: theme.textTheme.bodyMedium!.copyWith(color: Colors.red),
          ),
        ),
        ListTile(
          tileColor: Colors.white,
          onTap: () {
            try {
              CustomAlertDialogs.showMessageDialog(context,
                  title: "Alert!!",
                  message:
                      "Careful You are going to delete your account with the potential your not going to recover it again.",
                  posButtonTitle: "OK Delete", posButtonFun: () {
                authProvider.deleteAccount(
                    context, authProvider.firebaseAuthUser!.uid);
                Navigator.pushReplacementNamed(context, LoginScreen.routeName);
              }, negButtonTitle: "Cancel");
            } on FirebaseAuthException catch (e) {
              CustomAlertDialogs.showMessageDialog(context,
                  title: "SomeThing went wrong", message: '');
            }
          },
          leading: const Icon(
            Icons.delete,
            size: 30,
            color: Colors.red,
          ),
          title: Text(
            "Delete Account",
            style: theme.textTheme.bodyMedium!.copyWith(color: Colors.red),
          ),
        ),
      ],
    );
  }
}
