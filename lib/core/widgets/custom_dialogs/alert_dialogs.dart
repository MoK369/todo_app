import 'package:flutter/material.dart';

class CustomAlertDialogs {
  static void showMessageDialog(BuildContext context,
      {required String title,
      required String message,
      String? posButtonTitle,
      VoidCallback? posButtonFun,
      String? negButtonTitle,
      VoidCallback? negButtonFun,
      bool isDismissible = true}) {
    ThemeData theme = Theme.of(context);
    showDialog(
      barrierDismissible: isDismissible,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
          ),
          content: Text(
            message,
          ),
          actions: [
            if (negButtonTitle != null) ...[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    negButtonFun != null ? negButtonFun() : null;
                  },
                  child: Text(
                    negButtonTitle,
                    style: theme.textTheme.bodyMedium,
                  ))
            ],
            const SizedBox(
              width: 26,
            ),
            if (posButtonTitle != null) ...[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    posButtonFun != null ? posButtonFun() : null;
                  },
                  child: Text(
                    posButtonTitle,
                    style: theme.textTheme.bodyMedium!
                        .copyWith(color: const Color(0xFF6C63FF)),
                  ))
            ],
          ],
        );
      },
    );
  }

  static void showLoadingDialog(BuildContext context,
      {required String title, bool isDismissible = true}) {
    showDialog(
      barrierDismissible: isDismissible,
      context: context,
      builder: (context) {
        ThemeData theme = Theme.of(context);
        return AlertDialog(
          title: Row(
            children: [
              const Center(child: CircularProgressIndicator()),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Text(
                  textAlign: TextAlign.center,
                  title,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static void hideDialog(BuildContext context) {
    Navigator.pop(context);
  }
}
