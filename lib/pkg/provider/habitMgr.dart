import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:focus/pkg/db_types/db.dart';
import 'package:focus/pkg/util/date.dart';
import 'package:maxilozoz_box/application.dart';
import 'package:timezone/timezone.dart' as tz;

class habitMgr {
  late Application app;

  updateHabit() async {
    DBClientSet db = await app.make("app_db");
    FlutterLocalNotificationsPlugin flp = await app.make("appNotify");

    var it = (await db.Habit().all()).iterator;
    while (it.moveNext()) {
      var tr = it.current.timeRange;
      int base = it.current.id! * 100;
      var ts = tr.ss.getRange(tr.current, tr.ss.length).toList();
      for (var j = 1; j <= ts.length; j++) {
        int baseIndex = tr.current + j;
        print(
            "schedule habit ${it.current.id} times: $baseIndex at: ${ts[j - 1].toIso8601String()}");
        flp.zonedSchedule(
            base + baseIndex,
            "${it.current.name}($baseIndex)",
            it.current.desc,
            ts[j - 1],
            const NotificationDetails(
                android: AndroidNotificationDetails('life_habit', 'life_habit',
                    channelDescription: 'your channel description')),
            androidAllowWhileIdle: true,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime);
      }
    }
  }

  cancleHabit(HabitType ht) async {
    FlutterLocalNotificationsPlugin flp = await app.make("appNotify");
    int base = ht.id! * 100;

    int c = ht.count!;
    for (var i = 0; i < c; i++) {
      flp.cancel(base + i);
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

  void boot(Application app) async {
    (app.make("appHabit") as habitMgr).updateHabit();
  }
}
