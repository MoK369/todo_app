import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/core/providers/localization_provider.dart';

extension IntExtensionMethods on int {
  String getTimeFormat(BuildContext context) {
    L10nProvider l10nProvider = Provider.of(context, listen: false);
    DateTime time = DateTime.fromMillisecondsSinceEpoch(this);
    String hour =
        (time.hour > 12 ? (time.hour - 12) : (time.hour == 0 ? 12 : time.hour))
            .toString();
    String period = time.hour > 12
        ? (l10nProvider.isArabic() ? "م" : "PM")
        : (l10nProvider.isArabic() ? "ص" : "AM");
    String minute = time.minute < 10 ? "0${time.minute}" : "${time.minute}";
    return "$hour:$minute $period";
  }

  String getDateFormat(BuildContext context) {
    L10nProvider l10nProvider = Provider.of(context, listen: false);
    final DateFormat formatter =
        DateFormat("EEE yyyy/MMM/dd", l10nProvider.isArabic() ? "ar" : "en");
    return formatter.format(DateTime.fromMillisecondsSinceEpoch(this).toUtc());
  }
}
