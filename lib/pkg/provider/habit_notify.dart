import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:focus/pkg/db_types/db.dart';
import 'package:focus/pkg/provider/notify.dart';
import 'package:focus/pkg/util/date.dart';
import 'package:maxilozoz_box/application.dart';
import 'package:maxilozoz_box/modules/config/config.dart';
import 'package:maxilozoz_box/modules/route/route.dart';

class habitNotifyRecord {
  late HabitType t;
  int count = 0;
  DateTime last = DateTime.now().add(Duration(days: -1));
}

class habitNotify {
  final name = "habitNotify";
  Map<int, habitNotifyRecord> old = {};

  void register(Application app) {
    app.bind("habitNotifyRecord", (Application app, dynamic params) {
      return old;
    });
  }

  void boot(Application app) async {
    DBClientSet db = await app.make("app_db");
    FlutterLocalNotificationsPlugin flnp = await app.make("appNotify");
    Set<int> moreId = Set();
    Timer.periodic(const Duration(seconds: 30), (timer) async {
      List<HabitType> hs = await db.Habit().all();
      hs.forEach((element) {
        moreId.add(element.id!);
        if (old[element.id] == null) {
          old[element.id!] = habitNotifyRecord();
        }
        old[element.id]!.t = element;
      });

      old.forEach((key, value) {
        if (!moreId.contains(key)) {
          old.remove(key);
        }
      });

      var now = DateTime.now();
      List<Widget> tipW = [];
      old.forEach((key, value) {
        if (diffMinute(value.t.notBefore!, now) <= 0) {
          return;
        }

        if (diffMinute(now, value.t.notAfter!) <= 0) {
          return;
        }

        if (value.count < value.t.count!) {
          var per = value.t.notAfter!.difference(value.t.notBefore!).inMinutes / value.t.count!;
          if (value.last.add(Duration(seconds: per.ceil())).compareTo(now) <= 0) {
            value.last = now;
            value.count++;
            if (app.lifecycleState == AppLifecycleState.resumed) {
              tipW.add(Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(value.t.name!, style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.normal , decoration: TextDecoration.none)),
                  Text(value.t.desc!, softWrap: true, style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.normal , decoration: TextDecoration.none)),
                ],
              ));
            }else {
              flnp.show(
                now.second + value.t.id!, value.t.name, value.t.desc, null);
            }
          }
        }
      });

      if(tipW.isNotEmpty) {
        Timer(Duration(seconds: 3), () {
                Navigator.pop(MinRoute.routeContext!);
              });
        showCupertinoModalPopup<void>(
                context: MinRoute.routeContext!,
                builder: (BuildContext context) => SafeArea(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(6.0),
                    // The Bottom margin is provided to align the popup above the system navigation bar.
                    margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    // Provide a background color for the popup.
                    color: CupertinoColors.systemBackground.resolveFrom(context),
                    // Use a SafeArea widget to avoid system overlaps.
                    child: Column(
                      children: tipW,
                    ),
                  ),
                ));
      }
    });
  }
}
