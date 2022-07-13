import 'package:focus/pkg/db_types/ngrok.dart';
import 'package:maxilozoz_box/modules/storage/sqlite/sqlite.dart';

class AppDB {
  Database db;
  NgrokClient ngrokClient;
  AppDB(this.db): 
    ngrokClient = NgrokClient(db);
}
