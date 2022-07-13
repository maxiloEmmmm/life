// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// DBGenerator
// **************************************************************************

part of 'plan.dart';

class PlanClient {
  Database db;
  PlanClient(this.db);

  Future<List<Plan>> all() async {
    return (await db.rawQuery("select * from Plan"))
        .map((e) => Plan.fromJson(e))
        .toList();
  }

  Future<int> insert(Plan obj) async {
    return await db.insert("Plan", obj.toJson());
  }

  Future<int> updateWhere(
      Plan obj, String? where, List<Object?>? whereArgs) async {
    return await db.update("Plan", obj.toJson(),
        where: where, whereArgs: whereArgs);
  }

  Future<int> delete(int? id) async {
    return await db.rawDelete("delete from Plan where id = ?", [id]);
  }

  Future<int> update(int? id, Plan obj) async {
    return await updateWhere(obj, "id = ?", [id]);
  }

  Future<Plan?> first(int? id) async {
    //ignore more rows
    var rows =
        await db.rawQuery("select * from Plan where id = ? limit 1", [id]);
    if (rows.isEmpty) {
      return null;
    }

    return Plan.fromJson(rows[0]);
  }

  static var idField = "id";
  static var nameField = "name";
  static var descField = "desc";
  static var repeatField = "repeat";
  static var enableRepeatField = "enableRepeat";
  static var deadLineField = "deadLine";
  static var relationIDField = "relationID";
  static var enableRelationField = "enableRelation";
  static var dbTable = "Plan";
  static var dbSchema = '''
  create table Plan (
    id INTEGER;
    name TEXT;
    desc TEXT;
    repeat INTEGER;
    enableRepeat INTEGER;
    deadLine INTEGER;
    relationID INTEGER;
    enableRelation INTEGER;
  
  );
  ''';
}
