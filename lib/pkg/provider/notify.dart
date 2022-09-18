import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:focus/pkg/db_types/db.dart';
import 'package:maxilozoz_box/application.dart';
import 'package:maxilozoz_box/modules/config/config.dart';
import 'package:timezone/timezone.dart' as tz;

class appNotify {
  final name = "appNotify";
  void register(Application app) {
    app.bind(name, (Application app, dynamic params) async {
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();
      return flutterLocalNotificationsPlugin;
    });
  }

  void boot(Application app) async {
    FlutterLocalNotificationsPlugin flp = await app.make("appNotify");
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {},
    );
    final MacOSInitializationSettings initializationSettingsMacOS =
        MacOSInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: initializationSettingsMacOS);
    await flp.initialize(initializationSettings);
  }
}
