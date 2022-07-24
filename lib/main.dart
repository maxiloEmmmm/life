import 'package:focus/pkg/provider/config.dart';
import 'package:focus/pkg/provider/db_provider.dart';
import 'package:focus/views/award/award.dart';
import 'package:focus/views/index.dart';
import 'package:focus/views/ngrok/add.dart' as ngrok_add;
import 'package:focus/views/plan/add.dart' as plan_add;
import 'package:focus/views/thing/add.dart' as thing_add;
import 'package:focus/views/award/add.dart' as award_add;
import 'package:focus/views/plan/plan.dart';
import 'package:focus/views/thing/thing.dart';
import 'package:maxilozoz_box/application.dart';
import 'package:maxilozoz_box/modules/route/route.dart';
import 'views/ngrok/ngrok.dart';

final Application app = Application();

void main() {
  MinRoute route = app.make('route');
  route.add('/', () => Index());
  route.add('/plan', () => const Plan());
  route.add('/plan/add', () => plan_add.Add(0));
  route.add(
      '/plan/update/:id', (Map data) => plan_add.Add(int.parse(data["id"])));
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
  app.run();
}
