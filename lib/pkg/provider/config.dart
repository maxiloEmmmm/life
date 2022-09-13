import 'package:focus/pkg/db_types/db.dart';
import 'package:maxilozoz_box/application.dart';
import 'package:maxilozoz_box/modules/config/config.dart';

class appConfig {
  final name = "app_config";
  void register(Application app) {}

  void boot(Application app) {
    Config config = app.make("config");
    var opt = {
      "db_enable": true,
      "db_schema": DBClientSet.schema,
      "db_migrate": [
        HabitClient.schema,
        HabitRecordClient.schema,
      ],
    };
    config.add(opt, inDev: true);
    config.add(opt, inDev: false);
  }
}
