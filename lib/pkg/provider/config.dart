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
create table ngrok (
  identity text,
  api_key text
)
'''
    }, inDev: true);
  }
}
