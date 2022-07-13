import 'package:focus/pkg/provider/config.dart';
import 'package:focus/pkg/provider/db_provider.dart';
import 'package:focus/views/ngrok/add.dart' as ngrok_add;
import 'package:focus/views/plan/plan.dart';
import 'package:maxilozoz_box/application.dart';
import 'package:maxilozoz_box/modules/route/route.dart';
import 'views/ngrok/ngrok.dart';

final Application app = Application();

void main() {
  MinRoute route = app.make('route');
  route.add('/', () => const Ngrok());
  route.add('/ngrok', () => const Ngrok());
  route.add('/ngrok/add', () => ngrok_add.Add(""));
  route.add('/ngrok/update/:id', (Map data) => ngrok_add.Add(data["id"]));
  app.serviceProvider.register(appConfig());
  app.serviceProvider.register(AppDBProvider());
  app.run();
}
