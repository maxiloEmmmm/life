import 'package:focus/pkg/db_types/db.dart';
import 'package:maxilozoz_box/application.dart';
import 'package:maxilozoz_box/modules/config/config.dart';

class appConfig {
  final name = "app_config";
  void register(Application app) {}

  void boot(Application app) {
    Config config = app.make("config");
    config.add({
      "db_enable": true,
      "db_schema": DBClientSet.schema,
      "db_migrate": [
        '''
insert into Plan(joint,jointCount,createdAt,deadLine,name,desc) values(2, 500,"2022-07-12", "2022-09-13", "t1", "")
'''
      ],
    }, inDev: true);
  }
}
