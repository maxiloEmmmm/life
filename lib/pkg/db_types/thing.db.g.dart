// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// DBGenerator
// **************************************************************************

part of 'thing.dart';

class ThingJSONHelp {
  static Thing fromJson(Map<String, dynamic> json) => _$ThingFromJson(json);
  static Map<String, dynamic> toJson(Thing obj) => _$ThingToJson(obj);
}

class ThingClient {
  Database db;
  ThingClient(this.db);

  Future<List<Award>?> getAwards(int identity) async {
    return (await db
            .rawQuery("select * from Award where Thing_id = ?", [identity]))
        .map((e) => AwardJSONHelp.fromJson(e))
        .toList();
  }

  Future<List<Thing>> all() async {
    return (await db.rawQuery("select * from $dbTable"))
        .map((e) => ThingJSONHelp.fromJson(e))
        .toList();
  }

  Future<int> insert(Thing obj) async {
    return await db.insert(dbTable, ThingJSONHelp.toJson(obj));
  }

  Future<int> updateWhere(
      Thing obj, String? where, List<Object?>? whereArgs) async {
    return await db.update(dbTable, ThingJSONHelp.toJson(obj),
        where: where, whereArgs: whereArgs);
  }

  Future<int> delete(int? id) async {
    return await db.rawDelete("delete from $dbTable where $idField = ?", [id]);
  }

  Future<int> update(int? id, Thing obj) async {
    return await updateWhere(obj, "$idField = ?", [id]);
  }

  Future<Thing?> first(int? id) async {
    //ignore more rows
    var rows = await db
        .rawQuery("select * from $dbTable where $idField = ? limit 1", [id]);
    if (rows.isEmpty) {
      return null;
    }

    return ThingJSONHelp.fromJson(rows[0]);
  }

  static const idField = "id";
  static const nameField = "name";
  static const descField = "desc";
  static const dbTable = "Thing";
  static const dbSchema = '''
  create table if not exists $dbTable (
    $idField INTEGER PRIMARY KEY AUTOINCREMENT,
    $nameField TEXT,
    $descField TEXT
  
  );
  
''';
}
