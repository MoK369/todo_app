import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/core/firebase_auth/firebase_auth_provider/auth_provider.dart';
import 'package:todo_app/core/providers/localization_provider.dart';
import 'package:todo_app/core/validate_functions/validate_functions.dart';
import 'package:todo_app/core/widgets/custom_dialogs/alert_dialogs.dart';
import 'package:todo_app/core/widgets/custom_form_field.dart';
import 'package:todo_app/modules/login/login_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const String routeName = "forgotPasswordScreen";

  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController enterEmailController = TextEditingController();

  bool isFormVisible = true;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: size.height * 0.2,
                ),
                RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: [
                      WidgetSpan(
                          alignment: PlaceholderAlignment.baseline,
                          baseline: TextBaseline.ideographic,
                          child: Card(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            shape: const CircleBorder(),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.key,
                                color: theme.appBarTheme.backgroundColor,
                                size: 40,
                              ),
                            ),
                          )),
                      TextSpan(
                          text: L10nProvider.getTrans(context).forgotPassword,
                          style: theme.textTheme.bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold))
                    ])),
                SizedBox(
                  height: size.height * 0.03,
                ),
                Text(
                  textAlign: TextAlign.center,
                  L10nProvider.getTrans(context).noWorries,
                  style: theme.textTheme.bodyMedium,
                ),
                Visibility(
                  visible: isFormVisible,
                  child: Form(
                    key: formKey,
                    child: CustomFormField(
                      controller: enterEmailController,
                      hintText: L10nProvider.getTrans(context).enterYourEmail,
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (inputText) {
                        return ValidateFunctions.validationOfEmail(
                            context, inputText);
                      },
                    ),
                  ),
                ),
                Visibility(
                  visible: isFormVisible,
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: size.height * 0.06,
                        right: 20,
                        left: 20,
                        bottom: size.height * 0.05),
                    child: ElevatedButton(
                      onPressed: () {
                        sendLink(context);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C63FF),
                          padding: const EdgeInsets.symmetric(vertical: 10)),
                      child: Text(L10nProvider.getTrans(context).sendLink,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w400)),
                    ),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, LoginScreen.routeName);
                    },
                    child: Text(
                      L10nProvider.getTrans(context).backToLogIn,
                      style: const TextStyle(
                          fontSize: 20, color: Color(0xFF6C63FF)),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void sendLink(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (formKey.currentState?.validate() == true) {
      FirebaseAuthProvider authProvider = Provider.of(context, listen: false);
      try {
        CustomAlertDialogs.showLoadingDialog(context,
            title: L10nProvider.getTrans(context).pleaseWait);
        List<String> result =
            await authProvider.checkEmailExist(enterEmailController.text);
        if (!mounted) return;
        if (result.isEmpty) {
          CustomAlertDialogs.hideDialog(context);
          CustomAlertDialogs.showMessageDialog(context,
              title: L10nProvider.getTrans(context).unfortunately,
              message: L10nProvider.getTrans(context).cantSend,
              posButtonTitle: L10nProvider.getTrans(context).ok);
          return;
        }
        await authProvider.resetPassword(enterEmailController.text);
        CustomAlertDialogs.hideDialog(context);
        CustomAlertDialogs.showMessageDialog(context,
            title: L10nProvider.getTrans(context).done,
            message: L10nProvider.getTrans(context).resetPasswordSent +
                enterEmailController.text,
            posButtonTitle: "OK");
        setState(() {
          isFormVisible = false;
        });
      } catch (e) {
        CustomAlertDialogs.hideDialog(context);
        CustomAlertDialogs.showMessageDialog(context,
            title: L10nProvider.getTrans(context).unfortunately,
            message: L10nProvider.getTrans(context).somethingWentWrong +
                e.toString(),
            posButtonTitle: "OK");
      }
    }
  }
}
