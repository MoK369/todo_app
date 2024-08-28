import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/core/firebase_auth/firebase_auth_provider/auth_provider.dart';
import 'package:todo_app/core/firebase_auth/firebase_exception_codes/firebase_auth_exception_codes.dart';
import 'package:todo_app/core/validate_functions/validate_functions.dart';
import 'package:todo_app/core/widgets/custom_dialogs/alert_dialogs.dart';
import 'package:todo_app/core/widgets/custom_form_field.dart';
import 'package:todo_app/core/widgets/login_register_icon.dart';
import 'package:todo_app/modules/home_screen/home_screen.dart';
import 'package:todo_app/modules/register/register_screen.dart';

import '../../core/database/models/app_user.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "loginScreen";

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController enterEmailController = TextEditingController(),
      passwordController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late ThemeData theme;

  bool isRememberMeChecked = false;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          FocusManager.instance.primaryFocus!.unfocus();
        },
        child: Scaffold(
          body: Column(
            children: [
              const LoginRegisterIcon(
                  title1: 'Welcome back',
                  title2: 'sign in to access your account'),
              const SizedBox(
                height: 100,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CustomFormField(
                            controller: enterEmailController,
                            hintText: 'Enter your Email',
                            prefixIcon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: (inputText) {
                              return ValidateFunctions.validationOfEmail(
                                  inputText);
                            },
                          ),
                          CustomFormField(
                            controller: passwordController,
                            hintText: 'Password',
                            isPasswordField: true,
                            prefixIcon: Icons.password,
                            validator: (inputText) {
                              if (inputText?.trim().isEmpty == true ||
                                  inputText == null) {
                                return "Please enter your password";
                              }
                              return null;
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              RichText(
                                  text: TextSpan(children: [
                                WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    baseline: TextBaseline.ideographic,
                                    child: Transform.scale(
                                      scale: 1.4,
                                      child: Checkbox(
                                        value: isRememberMeChecked,
                                        onChanged: (value) {
                                          setState(() {
                                            isRememberMeChecked = value!;
                                          });
                                        },
                                      ),
                                    )),
                                TextSpan(
                                    text: 'Remember Me',
                                    style: theme.textTheme.bodySmall)
                              ])),
                              TextButton(
                                onPressed: () {},
                                child: Text("Forgot Password?",
                                    style: theme.textTheme.bodySmall!.copyWith(
                                        color: const Color(0xFF6C63FF),
                                        fontWeight: FontWeight.bold)),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextButton(
                            onPressed: () {
                              resendVerification();
                            },
                            child: Text("Resend Email Verification",
                                style: theme.textTheme.bodySmall!.copyWith(
                                    color: const Color(0xFF6C63FF),
                                    fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 60, right: 20, left: 20, bottom: 10),
                            child: ElevatedButton(
                              onPressed: () {
                                whenLoggingIn();
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF6C63FF),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10)),
                              child: const Text("Log In",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w400)),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                                text: 'New Member? ',
                                style: theme.textTheme.bodySmall,
                                children: [
                                  WidgetSpan(
                                      alignment: PlaceholderAlignment.baseline,
                                      baseline: TextBaseline.alphabetic,
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.pushReplacementNamed(
                                              context,
                                              RegisterScreen.routeName);
                                        },
                                        child: Text("Register Now",
                                            style: theme.textTheme.bodySmall!
                                                .copyWith(
                                                    color:
                                                        const Color(0xFF6C63FF),
                                                    fontWeight:
                                                        FontWeight.bold)),
                                      ))
                                ]),
                          ),
                        ],
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void whenLoggingIn() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (formKey.currentState?.validate() == true) {
      loginWithAccount();
    } else {
      return;
    }
  }

  void loginWithAccount() async {
    FirebaseAuthProvider authProvider =
        Provider.of<FirebaseAuthProvider>(context, listen: false);
    try {
      CustomAlertDialogs.showLoadingDialog(context,
          title: 'Please wait....', isDismissible: false);

      AppUser? user = await authProvider.signInWithEmailAndPassword(
          enterEmailController.text, passwordController.text);
      CustomAlertDialogs.hideDialog(context);
      if (authProvider.isEmailVerified != true) {
        CustomAlertDialogs.showMessageDialog(context,
            title: "Note!",
            message: 'Please, verify your account first and then login',
            posButtonTitle: 'OK');
      } else if (user == null) {
        CustomAlertDialogs.showMessageDialog(
          context,
          title: "Note!",
          message: 'Something Went Wrong, check your connection and try again.',
          posButtonTitle: 'Try Again',
          posButtonFun: () {
            whenLoggingIn();
          },
        );
      } else {
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
        CustomAlertDialogs.showMessageDialog(context,
            title: "Done!", message: 'Successful Login', posButtonTitle: 'OK');
      }
    } on FirebaseAuthException catch (e) {
      String message = "Something Went Wrong";
      if (e.code == FirebaseAuthExceptionCodes.userNotFound ||
          e.code == FirebaseAuthExceptionCodes.wrongPassword ||
          e.code == FirebaseAuthExceptionCodes.invalidCredential) {
        message = 'Wrong Email or Password';
      }
      CustomAlertDialogs.hideDialog(context);
      CustomAlertDialogs.showMessageDialog(context,
          title: 'Unfortunately', message: message, posButtonTitle: "Ok");
    } catch (e) {
      String message = "Something Went Wrong";
      CustomAlertDialogs.hideDialog(context);
      CustomAlertDialogs.showMessageDialog(
        context,
        title: 'Unfortunately',
        message: message,
        posButtonTitle: "Try Again",
        posButtonFun: () {
          whenLoggingIn();
        },
      );
    }
  }

  void resendVerification() {
    FirebaseAuthProvider authProvider = Provider.of(context, listen: false);
    if (FirebaseAuth.instance.currentUser != null) {
      authProvider.sendEmailVerification(FirebaseAuth.instance.currentUser!);
      CustomAlertDialogs.showMessageDialog(context,
          title: "Successfully",
          message: "A new Email verification has been sent",
          posButtonTitle: 'OK');
    }
  }
}
