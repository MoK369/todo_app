import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/core/app_themes/app_themes.dart';

import '../../core/firebase_auth/firebase_auth_provider/auth_provider.dart';
import '../home_screen/home_screen.dart';
import '../login/login_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = '/';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late bool isDark;

  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 4),
      () {
        FirebaseAuthProvider authProvider =
            Provider.of<FirebaseAuthProvider>(context, listen: false);
        (authProvider.isLoggedIn() && (authProvider.isEmailVerified == true))
            ? Navigator.pushNamedAndRemoveUntil(
                context,
                HomeScreen.routeName,
                (route) => false,
              )
            : Navigator.pushNamedAndRemoveUntil(
                context,
                LoginScreen.routeName,
                (route) => false,
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    isDark = (MediaQuery.of(context).platformBrightness == Brightness.dark);
    return Container(
      decoration: BoxDecoration(
          color: isDark
              ? AppThemes.darkPrimaryColor
              : AppThemes.lightPrimaryColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(
            flex: 2,
          ),
          Center(
            child: BounceInDown(
                duration: const Duration(seconds: 3),
                delay: const Duration(seconds: 1),
                child: Image.asset(
                  'assets/images/todo_logo_android_12.png',
                  scale: 1.7,
                )),
          ),
          const Spacer(),
          ZoomIn(
              duration: const Duration(seconds: 4),
              child: Image.asset(
                'assets/images/branding_android_12.png',
                scale: 6,
              )),
        ],
      ),
    );
  }
}
