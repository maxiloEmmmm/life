import 'package:focus/pkg/db_types/ngrok.dart';
import 'package:focus/pkg/db_types/plan.dart';
import 'package:maxilozoz_box/application.dart';
import 'package:maxilozoz_box/modules/config/config.dart';

class appConfig {
  final name = "app_config";
  void register(Application app) {}

  void boot(Application app) {
    Config config = app.make("config");
    config.add({
      "db_enable": true,
      "db_schema": '''
${NgrokClient.dbSchema}
${PlanClient.dbSchema}
''',
      "db_migrate": [
        "drop table ${NgrokClient.dbTable}",
        "drop table ${PlanClient.dbTable}",
        NgrokClient.dbSchema,
        PlanClient.dbSchema
      ],
    }, inDev: true);
  }
}
