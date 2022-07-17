import 'package:focus/pkg/db_types/award.dart';
import 'package:focus/pkg/db_types/ngrok.dart';
import 'package:focus/pkg/db_types/plan.dart';
import 'package:focus/pkg/db_types/thing.dart';
import 'package:maxilozoz_box/modules/storage/sqlite/sqlite.dart';

class AppDB {
  Database db;
  NgrokClient ngrokClient;
  PlanClient planClient;
  AwardClient awardClient;
  ThingClient thingClient;
  AppDB(this.db): 
    ngrokClient = NgrokClient(db),
    planClient = PlanClient(db),
    awardClient = AwardClient(db),
    thingClient = ThingClient(db);
}
