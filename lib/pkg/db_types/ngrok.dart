import "package:maxilozoz_box/modules/storage/sqlite/sqlite.dart";
import 'package:maxilozoz_box/modules/storage/sqlite/build/annotation.dart';
part 'ngrok.db.g.dart';

@DBSchema(
  fields: [
    DBMetaField(name: "identity"),
    DBMetaField(name: "apiKey"),
  ],
  table: "Ngrok",
)
class Ngrok {}
