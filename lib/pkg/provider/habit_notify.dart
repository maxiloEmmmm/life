import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:focus/pkg/db_types/db.dart';
import 'package:focus/pkg/provider/notify.dart';
import 'package:maxilozoz_box/application.dart';
import 'package:maxilozoz_box/modules/config/config.dart';

class habitNotifyRecord {
  late HabitType t;
  int count = 0;
  DateTime last = DateTime.now().add(Duration(days: 1));
}

class habitNotify {
  final name = "habitNotify";
  void register(Application app) {}

  void boot(Application app) async {
    DBClientSet db = await app.make("app_db");
    FlutterLocalNotificationsPlugin flnp = await app.make("appNotify");
    Map<int, habitNotifyRecord> old = {};
    Set<int> moreId = Set();
    Timer.periodic(const Duration(seconds: 5), (timer) async {
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
      old.forEach((key, value) {
        if (value.t.notBefore!.compareTo(now) <= 0) {
          return;
        }

        if (value.t.notAfter!.compareTo(now) >= 0) {
          return;
        }

        if (value.count < value.t.count!) {
          var per = value.t.notAfter!.difference(value.t.notBefore!).inMinutes;
          if (value.last.add(Duration(seconds: per)).compareTo(now) <= 0) {
            value.last = now;
            value.count++;
            flnp.show(
                now.second + value.t.id!, value.t.name, value.t.desc, null);
          }
        }
      });
    });
  }
}
