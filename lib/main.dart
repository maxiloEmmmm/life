import 'package:maxilozoz_box/application.dart';
import 'package:maxilozoz_box/modules/route/route.dart';
import 'views/demo.dart';

final Application app = Application();

void main() {
  MinRoute route = app.make('route');
  route.add('/', () => Demo());
  app.run();
}
