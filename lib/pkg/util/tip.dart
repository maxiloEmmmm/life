import 'package:flutter/cupertino.dart';

class tipAlertAction {
  Widget text;

  void Function()? cb;

  tipAlertAction.view(this.text);

  tipAlertAction(this.text, this.cb);
}

class tip {
  static String DefaultBtnText = "好的";

  static void TextAlertDescWithCB(BuildContext context, String desc, void Function() cb) {
    Alert(context: context, desc: Text(desc), actions: [tipAlertAction(Text(DefaultBtnText), cb)]);
  }

  static void TextAlertDesc(BuildContext context, String desc) {
    Alert(context: context, desc: Text(desc));
  }

  static void TextAlertWithOutCB(BuildContext context, String title, desc) {
    TextAlert(context: context, title: title, desc: desc);
  }

  static void TextAlert(
      {required BuildContext context,
      String? title,
      String? desc,
      List<tipAlertAction> actions = const <tipAlertAction>[]}) {
    Alert(
        context: context,
        title: Text(title ?? ""),
        desc: Text(desc ?? ""),
        actions: actions);
  }

  static void Alert(
      {required BuildContext context,
      Widget? title,
      Widget? desc,
      List<tipAlertAction> actions = const <tipAlertAction>[]}) {
    if (actions.isEmpty) {
      actions = [tipAlertAction.view(Text(DefaultBtnText))];
    }
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
          title: title,
          content: desc,
          actions: actions
              .map((e) => CupertinoDialogAction(
                    isDestructiveAction: true,
                    onPressed: () {
                      if (e.cb != null) {
                        e.cb!();
                      }
                      Navigator.pop(context);
                    },
                    child: e.text,
                  ))
              .toList()),
    );
  }
}
