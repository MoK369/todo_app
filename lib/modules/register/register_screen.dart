import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/core/database/models/app_user.dart';
import 'package:todo_app/core/firebase_auth/firebase_auth_provider/auth_provider.dart';
import 'package:todo_app/core/firebase_auth/firebase_exception_codes/firebase_auth_exception_codes.dart';
import 'package:todo_app/core/validate_functions/validate_functions.dart';
import 'package:todo_app/core/widgets/custom_dialogs/alert_dialogs.dart';
import 'package:todo_app/core/widgets/custom_form_field.dart';
import 'package:todo_app/core/widgets/login_register_icon.dart';
import 'package:todo_app/modules/login/login_screen.dart';

class RegisterScreen extends StatelessWidget {
  static const String routeName = "registerScreen";

  RegisterScreen({super.key});

  final TextEditingController fullNameCont = TextEditingController(),
      emailCont = TextEditingController(),
      phoneCont = TextEditingController(),
      passwordCont = TextEditingController(),
      confirmPasswordCont = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
                title1: 'Get Started', title2: 'by creating free account'),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomFormField(
                        controller: fullNameCont,
                        hintText: 'Full Name',
                        prefixIcon: Icons.person,
                        keyboardType: TextInputType.name,
                        validator: (inputText) {
                          return ValidateFunctions.validationOfFullName(
                              inputText);
                        },
                      ),
                      CustomFormField(
                        controller: emailCont,
                        hintText: 'Valid Email',
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (inputText) {
                          return ValidateFunctions.validationOfEmail(inputText);
                        },
                      ),
                      CustomFormField(
                        controller: phoneCont,
                        hintText: 'Phone Number',
                        prefixIcon: Icons.phone_android,
                        keyboardType: TextInputType.phone,
                        validator: (inputText) {
                          return ValidateFunctions.validationOfPhoneNumber(
                              inputText);
                        },
                      ),
                      CustomFormField(
                        controller: passwordCont,
                        hintText: 'Strong Password',
                        isPasswordField: true,
                        prefixIcon: Icons.password,
                        validator: (inputText) {
                          return ValidateFunctions.validationOfPassword(
                              inputText);
                        },
                      ),
                      CustomFormField(
                        controller: confirmPasswordCont,
                        hintText: 'Confirm Password',
                        isPasswordField: true,
                        prefixIcon: Icons.password,
                        validator: (inputText) {
                          return ValidateFunctions.validationOfConfirmPassword(
                              inputText, passwordCont);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: ElevatedButton(
                          onPressed: () {
                            whenSigningUp(context);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6C63FF),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10)),
                          child: const Text("Sign Up",
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
                            text: 'Already a member? ',
                            style: theme.textTheme.bodySmall,
                            children: [
                              WidgetSpan(
                                  alignment: PlaceholderAlignment.baseline,
                                  baseline: TextBaseline.alphabetic,
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.pushReplacementNamed(
                                          context, LoginScreen.routeName);
                                    },
                                    child: Text("Log in",
                                        style: theme.textTheme.bodySmall!
                                            .copyWith(
                                                color: const Color(0xFF6C63FF),
                                                fontWeight: FontWeight.bold)),
                                  ))
                            ]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }

  void whenSigningUp(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    if (formKey.currentState?.validate() == true) {
      createAccount(context);
    } else {
      return;
    }
  }

  void createAccount(BuildContext context) async {
    FirebaseAuthProvider authProvider =
        Provider.of<FirebaseAuthProvider>(context, listen: false);
    try {
      CustomAlertDialogs.showLoadingDialog(context,
          title: 'Please wait....', isDismissible: false);
      AppUser? user = await authProvider.createUserWithEmailAndPassword(
        email: emailCont.text,
        password: passwordCont.text,
        fullName: fullNameCont.text,
        phoneNumber: phoneCont.text,
      );
      //print(credential);
      CustomAlertDialogs.hideDialog(context);
      if (user != null) {
        CustomAlertDialogs.showMessageDialog(
          context,
          title: "Account Created Successfully",
          message:
              "A message has been sent to your email, please verify your account first and then Log-In. Note! If you did find the verification message check your spammed messages.",
          posButtonTitle: 'OK',
          posButtonFun: () {
            Navigator.pushReplacementNamed(context, LoginScreen.routeName);
          },
        );
      } else {
        CustomAlertDialogs.showMessageDialog(context,
            title: "Unfortunately!!",
            message:
                "Something Went Wrong, please check your connection and then try again.",
            posButtonTitle: 'Try Again', posButtonFun: () {
          whenSigningUp(context);
        }, negButtonTitle: 'Cancel');
      }
    } on FirebaseAuthException catch (e) {
      String message =
          "Something Went Wrong, please check your connection and then try again.";
      if (e.code == FirebaseAuthExceptionCodes.weakPassword) {
        message = 'The password provided is too weak.';
      } else if (e.code == FirebaseAuthExceptionCodes.emailInUse) {
        message = 'The account already exists for that email.';
      }
      CustomAlertDialogs.hideDialog(context);
      CustomAlertDialogs.showMessageDialog(context,
          title: 'Unfortunately', message: message, posButtonTitle: "Ok");
    } catch (e) {
      print("---------------$e--------------");
      print("happening");
      String message =
          "Something Went Wrong, please check your connection and then try again.";
      CustomAlertDialogs.hideDialog(context);
      CustomAlertDialogs.showMessageDialog(
        context,
        title: 'Unfortunately',
        message: message,
        posButtonTitle: "Try Again",
        posButtonFun: () {
          whenSigningUp(context);
        },
      );
    }
  }
}
