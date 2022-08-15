import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:focus/pkg/db_types/db.dart';
import 'package:focus/pkg/util/date.dart';
import 'package:maxilozoz_box/application.dart';
import 'package:maxilozoz_box/modules/config/config.dart';
import 'package:maxilozoz_box/modules/route/route.dart';

class habitNotifyRecord {
  late HabitType t;
  int count = 0;
  DateTime last = DateTime.now().add(Duration(days: -1));
}

void start(ServiceInstance service) {
  Timer.periodic(Duration(seconds: 30), (timer) {
    service.invoke("habitNotify");
  });
}

bool startx(ServiceInstance service) {
  print("?startx");
  return true;
}

Map<int, habitNotifyRecord> habitNotifyOld = {};
Set<int> habitMoreId = Set();
void habitNotify(Application app) async {
  DBClientSet db = await app.make("app_db");
  FlutterLocalNotificationsPlugin flnp = await app.make("appNotify");
    print("periodic");
    List<HabitType> hs = await db.Habit().all();
    print("query db");
    hs.forEach((element) {
      habitMoreId.add(element.id!);
      if (habitNotifyOld[element.id] == null) {
        habitNotifyOld[element.id!] = habitNotifyRecord();
      }
      habitNotifyOld[element.id]!.t = element;
    });

    habitNotifyOld.forEach((key, value) {
      if (!habitMoreId.contains(key)) {
        habitNotifyOld.remove(key);
      }
    });

    var now = DateTime.now();
    List<Widget> tipW = [];
    habitNotifyOld.forEach((key, value) {
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
            print("后台顶部提示");
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
}

class appBgService {
  final name = "app_bg_service";
  late FlutterBackgroundService s;
  void register(Application app) {
    app.bind("habitNotifyRecord", (Application app, dynamic params) {
      return habitNotifyOld;
    });
    app.bind("app_bg_service", (Application app, dynamic params) {
      return s;
    });
  }

  void boot(Application app) async {
    s = FlutterBackgroundService();
    await s.configure(
        androidConfiguration: AndroidConfiguration(
          // this will be executed when app is in foreground or background in separated isolate
          onStart: start,
          // auto start service
          autoStart: true,
          isForegroundMode: true,
      ),
      iosConfiguration: IosConfiguration(
        // auto start service
        autoStart: true,

        // this will be executed when app is in foreground in separated isolate
        onForeground: start,
        // you have to enable background fetch capability on xcode project
        onBackground: startx,
      ),
    );
    s.startService();
    s.on("habitNotify").listen((event) {
      habitNotify(app);
    });
  }
}
