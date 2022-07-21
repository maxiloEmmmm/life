// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// DBGenerator
// **************************************************************************

part of 'planDetail.dart';

class PlanDetailJSONHelp {
  static PlanDetail fromJson(Map<String, dynamic> json) =>
      _$PlanDetailFromJson(json);
  static Map<String, dynamic> toJson(PlanDetail obj) => _$PlanDetailToJson(obj);
}

class PlanDetailClient {
  Database db;
  PlanDetailClient(this.db);

  Future<int> setPlan(int identity, int Plan_identity) async {
    return await db.rawUpdate("update PlanDetail set Plan_id = ? where id = ?",
        [Plan_identity, identity]);
  }

  Future<Plan?> getPlan(int identity) async {
    var rows = await db.rawQuery(
        "select t1.* from PlanDetail as s left join Plan as t1 where s.id = ? and t1.id = s.Plan_id",
        [identity]);
    if (rows.isEmpty) {
      return null;
    }

    return PlanJSONHelp.fromJson(rows[0]);
  }

  Future<List<PlanDetail>> all() async {
    return (await db.rawQuery("select * from $dbTable"))
        .map((e) => PlanDetailJSONHelp.fromJson(e))
        .toList();
  }

  Future<int> insert(PlanDetail obj) async {
    return await db.insert(dbTable, PlanDetailJSONHelp.toJson(obj));
  }

  Future<int> updateWhere(
      PlanDetail obj, String? where, List<Object?>? whereArgs) async {
    return await db.update(dbTable, PlanDetailJSONHelp.toJson(obj),
        where: where, whereArgs: whereArgs);
  }

  Future<int> delete(int? id) async {
    return await db.rawDelete("delete from $dbTable where $idField = ?", [id]);
  }

  Future<int> update(int? id, PlanDetail obj) async {
    return await updateWhere(obj, "$idField = ?", [id]);
  }

  Future<PlanDetail?> first(int? id) async {
    //ignore more rows
    var rows = await db
        .rawQuery("select * from $dbTable where $idField = ? limit 1", [id]);
    if (rows.isEmpty) {
      return null;
    }

    return PlanDetailJSONHelp.fromJson(rows[0]);
  }

  static const idField = "id";
  static const hitField = "hit";
  static const descField = "desc";
  static const createdAtField = "createdAt";
  static const dbTable = "PlanDetail";
  static const dbSchema = '''
  create table if not exists $dbTable (
      Plan_id INTEGER,
  $idField INTEGER PRIMARY KEY AUTOINCREMENT,
    $hitField INTEGER,
    $descField TEXT,
    $createdAtField INTEGER
  
  );
  
''';
}
