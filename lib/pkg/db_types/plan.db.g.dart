// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// DBGenerator
// **************************************************************************

part of 'plan.dart';

class PlanJSONHelp {
  static Plan fromJson(Map<String, dynamic> json) => _$PlanFromJson(json);
  static Map<String, dynamic> toJson(Plan obj) => _$PlanToJson(obj);
}

class PlanClient {
  Database db;
  PlanClient(this.db);

  Future<List<Plan>> all() async {
    return (await db.rawQuery("select * from $dbTable"))
        .map((e) => PlanJSONHelp.fromJson(e))
        .toList();
  }

  Future<int> insert(Plan obj) async {
    return await db.insert(dbTable, PlanJSONHelp.toJson(obj));
  }

  Future<int> updateWhere(
      Plan obj, String? where, List<Object?>? whereArgs) async {
    return await db.update(dbTable, PlanJSONHelp.toJson(obj),
        where: where, whereArgs: whereArgs);
  }

  Future<int> delete(int? id) async {
    return await db.rawDelete("delete from $dbTable where $idField = ?", [id]);
  }

  Future<int> update(int? id, Plan obj) async {
    return await updateWhere(obj, "$idField = ?", [id]);
  }

  Future<Plan?> first(int? id) async {
    //ignore more rows
    var rows = await db
        .rawQuery("select * from $dbTable where $idField = ? limit 1", [id]);
    if (rows.isEmpty) {
      return null;
    }

    return PlanJSONHelp.fromJson(rows[0]);
  }

  static const idField = "id";
  static const nameField = "name";
  static const descField = "desc";
  static const repeatField = "repeat";
  static const enableRepeatField = "enableRepeat";
  static const deadLineField = "deadLine";
  static const relationIDField = "relationID";
  static const enableRelationField = "enableRelation";
  static const dbTable = "Plan";
  static const dbSchema = '''
  create table if not exists $dbTable (
    $idField INTEGER,
    $nameField TEXT,
    $descField TEXT,
    $repeatField INTEGER,
    $enableRepeatField INTEGER,
    $deadLineField INTEGER,
    $relationIDField INTEGER,
    $enableRelationField INTEGER
  
  );
  ''';
}
