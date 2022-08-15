import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:focus/pkg/provider/background.dart';
import 'package:focus/pkg/provider/config.dart';
import 'package:focus/pkg/provider/db_provider.dart';
import 'package:focus/pkg/provider/notify.dart';
import 'package:focus/views/award/award.dart';
import 'package:focus/views/habit/habit.dart';
import 'package:focus/views/index.dart';
import 'package:focus/views/ngrok/add.dart' as ngrok_add;
import 'package:focus/views/plan/add.dart' as plan_add;
import 'package:focus/views/plan/detail.dart' as plan_detail;
import 'package:focus/views/thing/add.dart' as thing_add;
import 'package:focus/views/award/add.dart' as award_add;
import 'package:focus/views/habit/add.dart' as habit_add;
import 'package:focus/views/plan/plan.dart';
import 'package:focus/views/thing/thing.dart';
import 'package:maxilozoz_box/application.dart';
import 'package:maxilozoz_box/modules/route/route.dart';
import 'views/ngrok/ngrok.dart';

final Application app = Application();
void main() {
  MinRoute route = app.make('route');
  route.add('/', () => Index());
  route.add('/habit', () => const Habit());
  route.add('/habit/add', () => habit_add.Add(0));
  route.add(
      '/habit/update/:id', (Map data) => habit_add.Add(int.parse(data["id"])));
  route.add('/plan', () => const Plan());
  route.add('/plan/add', () => plan_add.Add(0));
  route.add(
      '/plan/update/:id', (Map data) => plan_add.Add(int.parse(data["id"])));
  route.add('/plan/:id/detail',
      (Map data) => plan_detail.Detail(int.parse(data["id"])));
  route.add('/ngrok', () => const Ngrok());
  route.add('/ngrok/add', () => ngrok_add.Add(0));
  route.add('/ngrok/update/:id', (Map data) => ngrok_add.Add(data["id"]));
  route.add('/thing', () => const ThingView());
  route.add('/thing/add', () => thing_add.Add(0));
  route.add(
      '/thing/update/:id', (Map data) => thing_add.Add(int.parse(data["id"])));
  route.add('/award', () => const AwardView());
  route.add('/award/add', () => award_add.Add(0));
  route.add(
      '/award/update/:id', (Map data) => award_add.Add(int.parse(data["id"])));
  app.serviceProvider.register(appConfig());
  app.serviceProvider.register(AppDBProvider());
  app.serviceProvider.register(appNotify());
  app.serviceProvider.register(appBgService());
  app.run();
}
