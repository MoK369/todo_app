import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/core/providers/localization_provider.dart';

extension TimeOfDayExtensionMethods on TimeOfDay {
  int hourMinuteSinceEpoch() {
    var newDateTime = DateTime(
        0, // year
        0, // month
        0, // day
        hour, // hour
        minute // minute
        );
    return newDateTime.millisecondsSinceEpoch;
  }

  String getTimeFormat(BuildContext context) {
    L10nProvider l10nProvider = Provider.of(context, listen: false);
    DateTime time = DateTime(0, 0, 0, this.hour, this.minute);

    String hour =
        (time.hour > 12 ? (time.hour - 12) : (time.hour == 0 ? 12 : time.hour))
            .toString();
    String period = time.hour > 12
        ? (l10nProvider.isArabic() ? "م" : "PM")
        : (l10nProvider.isArabic() ? "ص" : "AM");
    String minute = time.minute < 10 ? "0${time.minute}" : "${time.minute}";
    return "$hour:$minute $period";
  }
}
