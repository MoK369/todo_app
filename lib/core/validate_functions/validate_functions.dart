import 'package:flutter/material.dart';
import 'package:todo_app/core/providers/localization_provider.dart';

class ValidateFunctions {
  static String? validationOfFullName(BuildContext context, String? inputText) {
    if (inputText?.trim().isEmpty == true || inputText == null) {
      return L10nProvider.getTrans(context).enterName;
    }
    return null;
  }

  static String? validationOfEmail(BuildContext context, String? inputText) {
    RegExp gmailRegExp =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (inputText?.trim().isEmpty == true || inputText == null) {
      return L10nProvider.getTrans(context).enterEmail;
    }
    if (!gmailRegExp.hasMatch(inputText)) {
      return L10nProvider.getTrans(context).enterValidEmail;
    }
    return null;
  }

  static String? validationOfPhoneNumber(
      BuildContext context, String? inputText) {
    RegExp phoneNumber = RegExp(r'^(010|011|012|015)[0-9]{8}$');
    if (inputText?.trim().isEmpty == true || inputText == null) {
      return L10nProvider.getTrans(context).enterPhoneNum;
    } else if (!phoneNumber.hasMatch(inputText)) {
      return L10nProvider.getTrans(context).enterCorrectPhoneNum;
    }
    return null;
  }

  static String? validationOfPassword(BuildContext context, String? inputText) {
    RegExp passValid = RegExp(
        r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>])[A-Za-z\d!@#$%^&*(),.?":{}|<>]{6,}$');
    if (inputText?.trim().isEmpty == true || inputText == null) {
      return L10nProvider.getTrans(context).enterPassword;
    } else if (!passValid.hasMatch(inputText)) {
      return L10nProvider.getTrans(context).enterValidPassword;
    }
    return null;
  }

  static String? validationOfConfirmPassword(BuildContext context,
      String? inputText, TextEditingController passwordCont) {
    if (inputText?.trim().isEmpty == true || inputText == null) {
      return L10nProvider.getTrans(context).enterConfirmPassword;
    } else if (inputText != passwordCont.text) {
      return L10nProvider.getTrans(context).noMatch;
    }
    return null;
  }
}
