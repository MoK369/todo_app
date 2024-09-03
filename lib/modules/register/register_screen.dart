import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/core/database/models/app_user.dart';
import 'package:todo_app/core/firebase_auth/firebase_auth_provider/auth_provider.dart';
import 'package:todo_app/core/firebase_auth/firebase_exception_codes/firebase_auth_exception_codes.dart';
import 'package:todo_app/core/providers/localization_provider.dart';
import 'package:todo_app/core/validate_functions/validate_functions.dart';
import 'package:todo_app/core/widgets/custom_dialogs/alert_dialogs.dart';
import 'package:todo_app/core/widgets/custom_form_field.dart';
import 'package:todo_app/core/widgets/login_register_icon.dart';
import 'package:todo_app/modules/login/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = "registerScreen";

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
            LoginRegisterIcon(
                title1: L10nProvider.getTrans(context).getStarted,
                title2: L10nProvider.getTrans(context).byCreatingAccount),
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
                        hintText: L10nProvider.getTrans(context).fullName,
                        prefixIcon: Icons.person,
                        keyboardType: TextInputType.name,
                        validator: (inputText) {
                          return ValidateFunctions.validationOfFullName(
                              context, inputText);
                        },
                      ),
                      CustomFormField(
                        controller: emailCont,
                        hintText: L10nProvider.getTrans(context).validEmail,
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (inputText) {
                          return ValidateFunctions.validationOfEmail(
                              context, inputText);
                        },
                      ),
                      CustomFormField(
                        controller: phoneCont,
                        hintText: L10nProvider.getTrans(context).phoneNumber,
                        prefixIcon: Icons.phone_android,
                        keyboardType: TextInputType.phone,
                        validator: (inputText) {
                          return ValidateFunctions.validationOfPhoneNumber(
                              context, inputText);
                        },
                      ),
                      CustomFormField(
                        controller: passwordCont,
                        hintText: L10nProvider.getTrans(context).strongPassword,
                        isPasswordField: true,
                        prefixIcon: Icons.password,
                        validator: (inputText) {
                          return ValidateFunctions.validationOfPassword(
                              context, inputText);
                        },
                      ),
                      CustomFormField(
                        controller: confirmPasswordCont,
                        hintText:
                            L10nProvider.getTrans(context).confirmPassword,
                        isPasswordField: true,
                        prefixIcon: Icons.password,
                        validator: (inputText) {
                          return ValidateFunctions.validationOfConfirmPassword(
                              context, inputText, passwordCont);
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
                          child: Text(L10nProvider.getTrans(context).signUp,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w400)),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            text: L10nProvider.getTrans(context).alreadyMember,
                            style: theme.textTheme.bodySmall!
                                .copyWith(fontSize: 15),
                            children: [
                              WidgetSpan(
                                  alignment: PlaceholderAlignment.baseline,
                                  baseline: TextBaseline.alphabetic,
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.pushReplacementNamed(
                                          context, LoginScreen.routeName);
                                    },
                                    child: Text(
                                        L10nProvider.getTrans(context).logIn,
                                        style: theme.textTheme.bodySmall!
                                            .copyWith(
                                                color: const Color(0xFF6C63FF),
                                                fontSize: 18,
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
          title: L10nProvider.getTrans(context).pleaseWait,
          isDismissible: false);
      AppUser? user = await authProvider.createUserWithEmailAndPassword(
        email: emailCont.text,
        password: passwordCont.text,
        fullName: fullNameCont.text,
        phoneNumber: phoneCont.text,
      );
      if (!mounted) return;
      CustomAlertDialogs.hideDialog(context);
      if (user != null) {
        CustomAlertDialogs.showMessageDialog(
          context,
          title: L10nProvider.getTrans(context).accountCreated,
          message:
              L10nProvider.getTrans(context).verificationMessageHasBeenSent,
          posButtonTitle: L10nProvider.getTrans(context).ok,
          posButtonFun: () {
            Navigator.pushReplacementNamed(context, LoginScreen.routeName);
          },
        );
      } else {
        CustomAlertDialogs.showMessageDialog(context,
            title: L10nProvider.getTrans(context).unfortunately,
            message: L10nProvider.getTrans(context).checkConnection,
            posButtonTitle: L10nProvider.getTrans(context).tryAgain,
            posButtonFun: () {
          whenSigningUp(context);
        }, negButtonTitle: L10nProvider.getTrans(context).cancel);
      }
    } on FirebaseAuthException catch (e) {
      String message = L10nProvider.getTrans(context).checkConnection;
      if (e.code == FirebaseAuthExceptionCodes.weakPassword) {
        message = L10nProvider.getTrans(context).passwordTooWeak;
      } else if (e.code == FirebaseAuthExceptionCodes.emailInUse) {
        message = L10nProvider.getTrans(context).accountAlreadyExists;
      }
      CustomAlertDialogs.hideDialog(context);
      CustomAlertDialogs.showMessageDialog(context,
          title: L10nProvider.getTrans(context).unfortunately,
          message: message,
          posButtonTitle: L10nProvider.getTrans(context).ok);
    } catch (e) {
      String message = L10nProvider.getTrans(context).somethingWentWrong;
      CustomAlertDialogs.hideDialog(context);
      CustomAlertDialogs.showMessageDialog(
        context,
        title: L10nProvider.getTrans(context).unfortunately,
        message: message + e.toString(),
        posButtonTitle: L10nProvider.getTrans(context).tryAgain,
        posButtonFun: () {
          whenSigningUp(context);
        },
      );
    }
  }
}
