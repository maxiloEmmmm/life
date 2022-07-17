// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// DBGenerator
// **************************************************************************

part of 'award.dart';

class AwardJSONHelp {
  static Award fromJson(Map<String, dynamic> json) => _$AwardFromJson(json);
  static Map<String, dynamic> toJson(Award obj) => _$AwardToJson(obj);
}

class AwardClient {
  Database db;
  AwardClient(this.db);

  Future<List<Award>> all() async {
    return (await db.rawQuery("select * from $dbTable"))
        .map((e) => AwardJSONHelp.fromJson(e))
        .toList();
  }

  Future<int> insert(Award obj) async {
    return await db.insert(dbTable, AwardJSONHelp.toJson(obj));
  }

  Future<int> updateWhere(
      Award obj, String? where, List<Object?>? whereArgs) async {
    return await db.update(dbTable, AwardJSONHelp.toJson(obj),
        where: where, whereArgs: whereArgs);
  }

  Future<int> delete(int? id) async {
    return await db.rawDelete("delete from $dbTable where $idField = ?", [id]);
  }

  Future<int> update(int? id, Award obj) async {
    return await updateWhere(obj, "$idField = ?", [id]);
  }

  Future<Award?> first(int? id) async {
    //ignore more rows
    var rows = await db
        .rawQuery("select * from $dbTable where $idField = ? limit 1", [id]);
    if (rows.isEmpty) {
      return null;
    }

    return AwardJSONHelp.fromJson(rows[0]);
  }

  static const idField = "id";
  static const nameField = "name";
  static const descField = "desc";
  static const thingIDField = "thing_id";
  static const planIDsField = "plan_ids";
  static const dbTable = "Award";
  static const dbSchema = '''
  create table if not exists $dbTable (
    $idField INTEGER PRIMARY KEY AUTOINCREMENT,
    $nameField TEXT,
    $descField TEXT,
    $thingIDField INTEGER,
    $planIDsField INTEGER
  
  );
  ''';
}
