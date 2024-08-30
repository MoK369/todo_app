import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class L10nProvider extends ChangeNotifier {
  static const String appLocaleKey = "appLocale";
  String currentLocale = "en";
  SharedPreferences sharedPreferences;

  L10nProvider({required this.sharedPreferences}) {
    currentLocale = sharedPreferences.getString(appLocaleKey) ?? "en";
  }

  static AppLocalizations getTrans(BuildContext context) {
    return AppLocalizations.of(context)!;
  }

  void changeLocale(String localeCode) {
    currentLocale = localeCode;
    notifyListeners();
    sharedPreferences.setString(appLocaleKey, currentLocale);
  }

  bool isArabic() {
    bool result = currentLocale == "ar";
    return result;
  }
}
