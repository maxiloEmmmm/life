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

  Future<List<Plan>> getPlans(int identity) async {
    return (await db.rawQuery(
            "select * from Plan where id in (select Plan_id from Award_Plan where Award_id=?)",
            [identity]))
        .map((e) => PlanJSONHelp.fromJson(e))
        .toList();
  }

  Future<Thing?> getThing(int identity) async {
    var rows = await db.rawQuery(
        "select t1.* from Award as s left join Thing as t1 where s.id = ? and t1.id = s.Thing_id",
        [identity]);
    if (rows.isEmpty) {
      return null;
    }

    return ThingJSONHelp.fromJson(rows[0]);
  }
// todo: insert update delete

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
  static const dbTable = "Award";
  static const dbSchema = '''
  create table if not exists $dbTable (
      Thing_id INTEGER,
  $idField INTEGER PRIMARY KEY AUTOINCREMENT,
    $nameField TEXT,
    $descField TEXT
  
  );

  create table if not exists Award_Plan (
    Award_id INTEGER,
    Plan_id INTEGER
  );

  ''';
}
