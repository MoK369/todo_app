import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/core/providers/localization_provider.dart';

extension DateTimeExtensionMethods on DateTime {
  int daySinceEpoch() {
    var newDateTime = DateTime(
      year,
      month,
      day,
    );
    return newDateTime.toUtc().millisecondsSinceEpoch;
  }

  String getDateFormat(BuildContext context) {
    L10nProvider l10nProvider = Provider.of(context, listen: false);

    final DateFormat formatter =
        DateFormat("EEE yyyy/MMM/dd", l10nProvider.isArabic() ? "ar" : "en");
    return formatter.format(this);
  }
}
