import 'package:focus/pkg/db_types/db.dart';
import 'package:maxilozoz_box/application.dart';
import 'package:maxilozoz_box/modules/storage/sqlite/sqlite.dart';

class AppDBProvider {
  String name = "app_db";

  void register(Application app) {
    app.bind(name, (Application app, dynamic params) async {
      return DBClientSet((await (app.make("sqlite") as sqlite).DB())!);
    });
  }

  void boot(Application app) {}
}
