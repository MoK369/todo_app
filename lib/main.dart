import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/core/firebase_auth/firebase_auth_provider/auth_provider.dart';
import 'package:todo_app/core/providers/localization_provider.dart';
import 'package:todo_app/core/providers/theme_provider.dart';
import 'package:todo_app/firebase_options.dart';
import 'package:todo_app/modules/edit/edit_screen.dart';
import 'package:todo_app/modules/forgot_password/forgot_password_screen.dart';
import 'package:todo_app/modules/splash/splash_screen.dart';

import 'core/app_themes/app_themes.dart';
import 'modules/home_screen/home_screen.dart';
import 'modules/login/login_screen.dart';
import 'modules/register/register_screen.dart';

void main() async {
  FlutterNativeSplash.preserve(
      widgetsBinding: WidgetsFlutterBinding.ensureInitialized());
  await dotenv.load(fileName: "privateInfo.env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => FirebaseAuthProvider(),
      ),
      ChangeNotifierProvider(
          create: (context) =>
              L10nProvider(sharedPreferences: sharedPreferences)),
      ChangeNotifierProvider(
        create: (context) =>
            ThemeProvider(sharedPreferences: sharedPreferences),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
    debugPrint(dotenv.env["ANDROID_API_KEY"]);
  }

  @override
  Widget build(BuildContext context) {
    L10nProvider l10nProvider = Provider.of(context);
    ThemeProvider themeProvider = Provider.of(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: themeProvider.currentAppTheme,
      routes: {
        SplashScreen.routeName: (_) => const SplashScreen(),
        HomeScreen.routeName: (_) => const HomeScreen(),
        RegisterScreen.routeName: (_) => const RegisterScreen(),
        LoginScreen.routeName: (_) => const LoginScreen(),
        EditScreen.routName: (_) => const EditScreen(),
        ForgotPasswordScreen.routeName: (_) => const ForgotPasswordScreen()
      },
      initialRoute: SplashScreen.routeName,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(l10nProvider.currentLocale),
    );
  }
}
