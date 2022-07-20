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

  Future<void> delPlans(int identity) async {
    await db.rawDelete("delete from Award_Plan where Award_id = ?", [identity]);
  }

  Future<void> setPlans(int identity, List<int> Plan_identities) async {
    await delPlans(identity);
    var iterator = Plan_identities.iterator;
    while (iterator.moveNext()) {
      await db.rawInsert(
          "insert into Award_Plan(Award_id, Plan_id) values(?, ?)",
          [identity, iterator.current]);
    }
  }

  Future<List<Plan>> getPlans(int identity) async {
    return (await db.rawQuery(
            "select * from Plan where id in (select Plan_id from Award_Plan where Award_id=?)",
            [identity]))
        .map((e) => PlanJSONHelp.fromJson(e))
        .toList();
  }

  Future<int> setThing(int identity, int Thing_identity) async {
    return await db.rawUpdate("update Award set Thing_id = ? where id = ?",
        [Thing_identity, identity]);
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
    await delPlans(id!);

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
''';

  static const dbEdgeSchemas = [
    '''create table if not exists Award_Plan (
    Award_id INTEGER PRIMARY KEY,
    Plan_id INTEGER
  );
'''
  ];
}
