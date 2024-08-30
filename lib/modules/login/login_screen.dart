import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/core/firebase_auth/firebase_auth_provider/auth_provider.dart';
import 'package:todo_app/core/firebase_auth/firebase_exception_codes/firebase_auth_exception_codes.dart';
import 'package:todo_app/core/validate_functions/validate_functions.dart';
import 'package:todo_app/core/widgets/custom_dialogs/alert_dialogs.dart';
import 'package:todo_app/core/widgets/custom_form_field.dart';
import 'package:todo_app/core/widgets/login_register_icon.dart';
import 'package:todo_app/modules/forgot_password/forgot_password_screen.dart';
import 'package:todo_app/modules/home_screen/home_screen.dart';
import 'package:todo_app/modules/register/register_screen.dart';

import '../../core/database/models/app_user.dart';
import '../../core/providers/localization_provider.dart';

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
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          FocusManager.instance.primaryFocus!.unfocus();
        },
        child: Scaffold(
          body: Column(
            children: [
              LoginRegisterIcon(
                  title1: L10nProvider.getTrans(context).welcomeBack,
                  title2:
                      L10nProvider.getTrans(context).signInToAccessYourAccount),
              SizedBox(
                height: size.height * 0.1,
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
                            hintText:
                                L10nProvider.getTrans(context).enterYourEmail,
                            prefixIcon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: (inputText) {
                              return ValidateFunctions.validationOfEmail(
                                  context, inputText);
                            },
                          ),
                          CustomFormField(
                            controller: passwordController,
                            hintText: L10nProvider.getTrans(context).password,
                            isPasswordField: true,
                            prefixIcon: Icons.password,
                            validator: (inputText) {
                              if (inputText?.isEmpty == true ||
                                  inputText == null) {
                                return L10nProvider.getTrans(context)
                                    .enterPassword;
                              }
                              return null;
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    text: L10nProvider.getTrans(context)
                                        .rememberMe,
                                    style: theme.textTheme.bodySmall)
                              ])),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, ForgotPasswordScreen.routeName);
                                },
                                child: Text(
                                    L10nProvider.getTrans(context)
                                        .forgotPassword,
                                    style: theme.textTheme.bodySmall!.copyWith(
                                        color: const Color(0xFF6C63FF),
                                        fontWeight: FontWeight.bold)),
                              )
                            ],
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          TextButton(
                            onPressed: () {
                              resendVerification();
                            },
                            child: Text(
                                L10nProvider.getTrans(context)
                                    .resendEmailVerification,
                                style: theme.textTheme.bodySmall!.copyWith(
                                    color: const Color(0xFF6C63FF),
                                    fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: size.height * 0.06,
                                right: 20,
                                left: 20,
                                bottom: size.height * 0.02),
                            child: ElevatedButton(
                              onPressed: () {
                                whenLoggingIn();
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF6C63FF),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10)),
                              child: Text(L10nProvider.getTrans(context).logIn,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w400)),
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                                text: L10nProvider.getTrans(context).newMember,
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
                                        child: Text(
                                            L10nProvider.getTrans(context)
                                                .registerNow,
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
          title: L10nProvider.getTrans(context).pleaseWait,
          isDismissible: false);

      AppUser? user = await authProvider.signInWithEmailAndPassword(
          enterEmailController.text, passwordController.text);
      if (!mounted) return;
      if (authProvider.isEmailVerified != true) {
        CustomAlertDialogs.hideDialog(context);
        CustomAlertDialogs.showMessageDialog(context,
            title: L10nProvider.getTrans(context).note,
            message: L10nProvider.getTrans(context).pleaseVerifyAccount,
            posButtonTitle: L10nProvider.getTrans(context).ok);
      } else if (user == null) {
        CustomAlertDialogs.hideDialog(context);
        CustomAlertDialogs.showMessageDialog(
          context,
          title: L10nProvider.getTrans(context).note,
          message: L10nProvider.getTrans(context).checkConnection,
          posButtonTitle: L10nProvider.getTrans(context).tryAgain,
          posButtonFun: () {
            whenLoggingIn();
          },
        );
      } else {
        if (user.isVerified != true) {
          print("changing status");
          await authProvider.updateVerificationStatus(
              user.authId!, authProvider.isEmailVerified!);
        }
        if (!mounted) return;
        CustomAlertDialogs.hideDialog(context);
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
        CustomAlertDialogs.showMessageDialog(context,
            title: L10nProvider.getTrans(context).done,
            message: L10nProvider.getTrans(context).successfulLogIn,
            posButtonTitle: L10nProvider.getTrans(context).ok);
      }
    } on FirebaseAuthException catch (e) {
      String message =
          L10nProvider.getTrans(context).somethingWentWrong + e.toString();
      if (e.code == FirebaseAuthExceptionCodes.userNotFound ||
          e.code == FirebaseAuthExceptionCodes.wrongPassword ||
          e.code == FirebaseAuthExceptionCodes.invalidCredential) {
        message = L10nProvider.getTrans(context).wrongEmailOrPassword;
      }
      CustomAlertDialogs.hideDialog(context);
      CustomAlertDialogs.showMessageDialog(context,
          title: L10nProvider.getTrans(context).unfortunately,
          message: message,
          posButtonTitle: L10nProvider.getTrans(context).ok);
    } catch (e) {
      String message =
          L10nProvider.getTrans(context).somethingWentWrong + e.toString();
      CustomAlertDialogs.hideDialog(context);
      CustomAlertDialogs.showMessageDialog(
        context,
        title: L10nProvider.getTrans(context).unfortunately,
        message: message,
        posButtonTitle: L10nProvider.getTrans(context).tryAgain,
        posButtonFun: () {
          whenLoggingIn();
        },
      );
    }
  }

  Future<void> resendVerification() async {
    FirebaseAuthProvider authProvider = Provider.of(context, listen: false);
    if (FirebaseAuth.instance.currentUser != null) {
      if (FirebaseAuth.instance.currentUser!.emailVerified != true) {
        try {
          CustomAlertDialogs.showLoadingDialog(context,
              title: L10nProvider.getTrans(context).pleaseWait);
          await authProvider
              .sendEmailVerification(FirebaseAuth.instance.currentUser!);
          if (!mounted) return;
          CustomAlertDialogs.hideDialog(context);
          CustomAlertDialogs.showMessageDialog(context,
              title: L10nProvider.getTrans(context).successfully,
              message: L10nProvider.getTrans(context).newEmailVerification +
                  (authProvider.firebaseAuthUser?.email ?? ""),
              posButtonTitle: L10nProvider.getTrans(context).ok);
        } catch (e) {
          CustomAlertDialogs.hideDialog(context);
          CustomAlertDialogs.showMessageDialog(context,
              title: L10nProvider.getTrans(context).unfortunately,
              message: L10nProvider.getTrans(context).somethingWentWrong +
                  e.toString());
        }
      } else {
        CustomAlertDialogs.showMessageDialog(context,
            title: L10nProvider.getTrans(context).note,
            message: L10nProvider.getTrans(context).emailAlreadyVerified);
      }
    } else {
      CustomAlertDialogs.showMessageDialog(context,
          title: L10nProvider.getTrans(context).note,
          message: L10nProvider.getTrans(context).noCurrentUser,
          posButtonTitle: L10nProvider.getTrans(context).ok);
    }
  }
}
