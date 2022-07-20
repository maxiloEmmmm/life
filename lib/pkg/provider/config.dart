import 'package:focus/pkg/db_types/award.dart';
import 'package:focus/pkg/db_types/ngrok.dart';
import 'package:focus/pkg/db_types/plan.dart';
import 'package:focus/pkg/db_types/thing.dart';
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
${AwardClient.dbSchema},
${ThingClient.dbSchema},
''',
      "db_migrate": [
        NgrokClient.dbSchema,
        PlanClient.dbSchema,
        AwardClient.dbSchema,
        ...AwardClient.dbEdgeSchemas,
        ThingClient.dbSchema
      ],
    }, inDev: true);
  }
}
