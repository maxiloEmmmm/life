import 'package:focus/views/demo_param.dart';
import 'package:focus/views/ngrok/add.dart' as ngrokAdd;
import 'package:maxilozoz_box/application.dart';
import 'package:maxilozoz_box/modules/route/route.dart';
import 'views/demo.dart';
import 'views/demo_param.dart';
import 'views/demo_param2.dart';

final Application app = Application();

void main() {
  MinRoute route = app.make('route');
  route.add('/', () => Demo());
  route.add('/ngrok/add', () => ngrokAdd.Add());
  app.run();
}
