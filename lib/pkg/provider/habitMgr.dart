import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:focus/pkg/db_types/db.dart';
import 'package:maxilozoz_box/application.dart';
import 'package:maxilozoz_box/modules/config/config.dart';
import 'package:maxilozoz_box/modules/storage/sqlite/sqlite.dart';

class habitMgr {
  late Application app;

  updateHabit() async {
    DBClientSet db = await app.make("app_db");
    FlutterLocalNotificationsPlugin flp = await app.make("app_notify");

    var it = (await db.Habit().all()).iterator;
    while (it.moveNext()) {
      var dr = it.current.notAfter!.difference(it.current.notBefore!).inSeconds / (it.current.count! + 1);
      int c = it.current.count!;

      while(c > 0) {
        flp.zonedSchedule(id, title, body, scheduledDate, notificationDetails, uiLocalNotificationDateInterpretation: uiLocalNotificationDateInterpretation, androidAllowWhileIdle: androidAllowWhileIdle)
      }

    }
  }

  cancleHabit() async {
    DBClientSet db = await app.make("app_db");
    FlutterLocalNotificationsPlugin flp = await app.make("app_notify");

    // 计算一个
    var it = (await db.Habit().query().orderBy(HabitClient.idField) all()).iterator;
    var limitHabit = 1000;
    while (it.moveNext()) {
      var dr = it.current.notAfter!.difference(it.current.notBefore!).inSeconds / (it.current.count! + 1);
      int base = it.current.id! * 100;




    }
  }
}

class appHabit {
  final name = "appHabit";
  void register(Application app) {
    app.bind("appHabit", (Application app, dynamic params) {
      habitMgr m = habitMgr();
      m.app = app;
      return m;
    });
  }

  void boot(Application app) {}
}
