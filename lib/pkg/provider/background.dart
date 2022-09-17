import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:focus/pkg/db_types/db.dart';
import 'package:focus/pkg/provider/habitMgr.dart';
import 'package:focus/pkg/util/date.dart';
import 'package:maxilozoz_box/application.dart';
import 'package:maxilozoz_box/modules/config/config.dart';
import 'package:maxilozoz_box/modules/route/route.dart';

class habitNotifyRecord {
  late HabitType t;
  int count = 0;
  DateTime last = DateTime.now().add(Duration(days: -1));
}

bool startx(ServiceInstance service) {
  print("?startx");
  service.invoke("refresh", null);
  return true;
}

start(ServiceInstance service) {
  startx(service);
}

class appBgService {
  final name = "app_bg_service";
  late FlutterBackgroundService s;
  void register(Application app) {
    app.bind("app_bg_service", (Application app, dynamic params) {
      return s;
    });
  }

  void boot(Application app) async {
    s = FlutterBackgroundService();
    await s.configure(
      androidConfiguration: AndroidConfiguration(
        // auto start service
        autoStart: true,
        onStart: start,
        isForegroundMode: false,
      ),
      iosConfiguration: IosConfiguration(
        // auto start service
        autoStart: true,
        onForeground: start,
        // you have to enable background fetch capability on xcode project
        onBackground: startx,
      ),
    );
    s.startService();
    print("bind refresh");
    s.on("refresh").listen((event) async {
      habitMgr flp = await app.make("appHabit");
      flp.updateHabit();
    });
  }
}
