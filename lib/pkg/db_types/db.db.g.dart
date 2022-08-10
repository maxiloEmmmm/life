// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// DBGenerator
// **************************************************************************

part of 'db.dart';

class DBClientSet {
  NgrokClient Ngrok() {
    return NgrokClient(this);
  }

  AwardClient Award() {
    return AwardClient(this);
  }

  PlanDetailClient PlanDetail() {
    return PlanDetailClient(this);
  }

  ThingClient Thing() {
    return ThingClient(this);
  }

  HabitRecordClient HabitRecord() {
    return HabitRecordClient(this);
  }

  PlanClient Plan() {
    return PlanClient(this);
  }

  HabitClient Habit() {
    return HabitClient(this);
  }

  DatabaseExec db;
  static const schema = '''
${NgrokClient.schema}
${AwardClient.schema}
${PlanDetailClient.schema}
${ThingClient.schema}
${HabitRecordClient.schema}
${PlanClient.schema}
${HabitClient.schema}
''';
  DBClientSet(this.db);

  QueryBuild<Map<String, Object?>> query() {
    var qb = QueryBuild<Map<String, Object?>>();
    qb.queryFunc = (String q) async {
      return await db.rawQuery(q);
    };
    return qb;
  }

  Future<void> transaction(Future<void> Function() cb) async {
    var _db = db;
    try {
      await (db as Database).transaction((txn) async {
        db = txn;
        await cb();
      });
    } catch (e) {
      db = _db;
      throw e.toString();
    }
    db = _db;
  }
}

String dateTime2String(DateTime data) {
  return data.toIso8601String();
}

DateTime string2DateTime(String data) {
  return DateTime.parse(data);
}

int bool2Int(bool data) {
  return data ? 0 : 1;
}

bool int2Bool(int data) {
  return data == 0;
}

class NgrokClient {
  DBClientSet clientSet;
  NgrokClient(this.clientSet);

  Future<int> delete(int id) async {
    return await clientSet.db
        .rawDelete("delete from $table where id = ?", [id]);
  }

  Future<NgrokType?> first(int idx) async {
    var rows = await query().where(Eq("id", idx)).query();

    if (rows.isEmpty) {
      return null;
    }

    return rows[0];
  }

  Future<NgrokType> firstOrNew(int idx) async {
    var rows = await query().where(Eq("id", idx)).query();

    if (rows.isEmpty) {
      var item = NgrokType();
      if (idx > 0) {
        item.id = idx;
      }
      return wrapType(item);
    }

    return rows[0];
  }

  NgrokType wrapType(NgrokType typ) {
    typ.clientSet = clientSet;
    return typ;
  }

  Future<List<NgrokType>> all() async {
    return await query().query();
  }

  QueryBuild<NgrokType> query() {
    var qb = QueryBuild<NgrokType>()..table(Table.from(table));
    qb.queryFunc = (String q) async {
      return (await clientSet.db.rawQuery(q))
          .map((e) => newTypeByRow(e))
          .toList();
    };
    return qb;
  }

  Future<int> insert(NgrokType obj) async {
    return await clientSet.db.insert(table, obj.toDB());
  }

  Future<int> update(NgrokType obj) async {
    return await clientSet.db
        .update(table, obj.toDB(), where: "id = ?", whereArgs: [obj.id!]);
  }

  NgrokType newType() {
    return wrapType(NgrokType());
  }

  NgrokType newTypeByRow(Map row) {
    return wrapType(NgrokType.DB(row));
  }

  static const idField = "id";
  static const identityField = "identity";
  static const apiKeyField = "apiKey";
  static const table = "Ngrok";
  static const schema = '''
create table if not exists Ngrok (
  id INTEGER PRIMARY KEY AUTOINCREMENT ,
identity text   ,
apiKey text   
);

''';
}

class NgrokType {
  late DBClientSet clientSet;

  int? id;
  String? identity;
  String? apiKey;

  NgrokType({this.id, this.identity, this.apiKey});

  NgrokType fill(Map data) {
    if (data["id"] != null) {
      id = data["id"] as int;
    }

    if (data["identity"] != null) {
      identity = data["identity"] as String;
    }

    if (data["apiKey"] != null) {
      apiKey = data["apiKey"] as String;
    }

    return this;
  }

  NgrokType fillByType(NgrokType obj) {
    if (obj.id != null) {
      id = obj.id;
    }

    if (obj.identity != null) {
      identity = obj.identity;
    }

    if (obj.apiKey != null) {
      apiKey = obj.apiKey;
    }

    return this;
  }

  NgrokType.DB(Map data) {
    id = data["id"] as int?;
    identity = data["identity"] as String?;
    apiKey = data["apiKey"] as String?;
  }

  Map<String, Object?> toDB() {
    final val = <String, Object?>{};

    void writeNotNull(String key, dynamic value) {
      if (value != null) {
        val[key] = value;
      }
    }

    writeNotNull('id', id);
    writeNotNull('identity', identity);
    writeNotNull('apiKey', apiKey);

    return val;
  }

  Future<NgrokType> save() async {
    if (id == null) {
      id = await clientSet.Ngrok().insert(this);
    } else {
      await clientSet.Ngrok().update(this);
    }

    return (await clientSet.Ngrok().first(id!))!;
  }

  Future<int> destory() async {
    if (id == null) {
      throw "current type not allow this opeart";
    }

    return await clientSet.Ngrok().delete(id!);
  }
}

class AwardClient {
  DBClientSet clientSet;
  AwardClient(this.clientSet);

  Future<int> delete(int id) async {
    return await clientSet.db
        .rawDelete("delete from $table where id = ?", [id]);
  }

  Future<AwardType?> first(int idx) async {
    var rows = await query().where(Eq("id", idx)).query();

    if (rows.isEmpty) {
      return null;
    }

    return rows[0];
  }

  Future<AwardType> firstOrNew(int idx) async {
    var rows = await query().where(Eq("id", idx)).query();

    if (rows.isEmpty) {
      var item = AwardType();
      if (idx > 0) {
        item.id = idx;
      }
      return wrapType(item);
    }

    return rows[0];
  }

  AwardType wrapType(AwardType typ) {
    typ.clientSet = clientSet;
    return typ;
  }

  Future<List<AwardType>> all() async {
    return await query().query();
  }

  QueryBuild<AwardType> query() {
    var qb = QueryBuild<AwardType>()..table(Table.from(table));
    qb.queryFunc = (String q) async {
      return (await clientSet.db.rawQuery(q))
          .map((e) => newTypeByRow(e))
          .toList();
    };
    return qb;
  }

  Future<int> insert(AwardType obj) async {
    return await clientSet.db.insert(table, obj.toDB());
  }

  Future<int> update(AwardType obj) async {
    return await clientSet.db
        .update(table, obj.toDB(), where: "id = ?", whereArgs: [obj.id!]);
  }

  AwardType newType() {
    return wrapType(AwardType());
  }

  AwardType newTypeByRow(Map row) {
    return wrapType(AwardType.DB(row));
  }

  static const idField = "id";
  static const nameField = "name";
  static const descField = "desc";
  static const table = "Award";
  static const schema = '''
create table if not exists Award (
  id INTEGER PRIMARY KEY AUTOINCREMENT ,
name text   ,
desc text   
);

''';
}

class AwardType {
  late DBClientSet clientSet;

  int? id;
  String? name;
  String? desc;

  AwardType({this.id, this.name, this.desc});

  AwardType fill(Map data) {
    if (data["id"] != null) {
      id = data["id"] as int;
    }

    if (data["name"] != null) {
      name = data["name"] as String;
    }

    if (data["desc"] != null) {
      desc = data["desc"] as String;
    }

    return this;
  }

  AwardType fillByType(AwardType obj) {
    if (obj.id != null) {
      id = obj.id;
    }

    if (obj.name != null) {
      name = obj.name;
    }

    if (obj.desc != null) {
      desc = obj.desc;
    }

    return this;
  }

  AwardType.DB(Map data) {
    id = data["id"] as int?;
    name = data["name"] as String?;
    desc = data["desc"] as String?;
  }

  Map<String, Object?> toDB() {
    final val = <String, Object?>{};

    void writeNotNull(String key, dynamic value) {
      if (value != null) {
        val[key] = value;
      }
    }

    writeNotNull('id', id);
    writeNotNull('name', name);
    writeNotNull('desc', desc);

    return val;
  }

  Future<AwardType> save() async {
    if (id == null) {
      id = await clientSet.Award().insert(this);
    } else {
      await clientSet.Award().update(this);
    }

    return (await clientSet.Award().first(id!))!;
  }

  Future<int> destory() async {
    if (id == null) {
      throw "current type not allow this opeart";
    }

    return await clientSet.Award().delete(id!);
  }

  Future<List<PlanType>> queryPlans() async {
    var rows = await clientSet.Plan()
        .query()
        .where(In("id", [
          QueryBuild()
              .select("Plan_ref")
              .table(Table.from("Award_Plan"))
              .where(Eq("Award_ref", id))
        ]))
        .query();

    return rows;
  }

  Future<void> setPlans(List<int> ids) async {
    var it = ids.iterator;
    while (it.moveNext()) {
      await clientSet.db.rawInsert(
          "insert into Award_Plan(Award_ref, Plan_ref) values(?, ?)",
          [id, it.current]);
    }
  }

  Future<ThingType?> queryThing() async {
    var rows = await clientSet.Thing()
        .query()
        .where(In("id", [
          QueryBuild()
              .select("Thing_ref")
              .table(Table.from("Award_Thing"))
              .where(Eq("Award_ref", id))
              .limit(1)
        ]))
        .query();

    if (rows.isEmpty) {
      return null;
    }
    return rows[0];
  }

  Future<void> setThing(int idx) async {
    var it = [idx].iterator;
    while (it.moveNext()) {
      await clientSet.db.rawInsert(
          "insert into Award_Thing(Award_ref, Thing_ref) values(?, ?)",
          [id, it.current]);
    }
  }
}

class PlanDetailClient {
  DBClientSet clientSet;
  PlanDetailClient(this.clientSet);

  Future<int> delete(int id) async {
    return await clientSet.db
        .rawDelete("delete from $table where id = ?", [id]);
  }

  Future<PlanDetailType?> first(int idx) async {
    var rows = await query().where(Eq("id", idx)).query();

    if (rows.isEmpty) {
      return null;
    }

    return rows[0];
  }

  Future<PlanDetailType> firstOrNew(int idx) async {
    var rows = await query().where(Eq("id", idx)).query();

    if (rows.isEmpty) {
      var item = PlanDetailType();
      if (idx > 0) {
        item.id = idx;
      }
      return wrapType(item);
    }

    return rows[0];
  }

  PlanDetailType wrapType(PlanDetailType typ) {
    typ.clientSet = clientSet;
    return typ;
  }

  Future<List<PlanDetailType>> all() async {
    return await query().query();
  }

  QueryBuild<PlanDetailType> query() {
    var qb = QueryBuild<PlanDetailType>()..table(Table.from(table));
    qb.queryFunc = (String q) async {
      return (await clientSet.db.rawQuery(q))
          .map((e) => newTypeByRow(e))
          .toList();
    };
    return qb;
  }

  Future<int> insert(PlanDetailType obj) async {
    return await clientSet.db.insert(table, obj.toDB());
  }

  Future<int> update(PlanDetailType obj) async {
    return await clientSet.db
        .update(table, obj.toDB(), where: "id = ?", whereArgs: [obj.id!]);
  }

  PlanDetailType newType() {
    return wrapType(PlanDetailType());
  }

  PlanDetailType newTypeByRow(Map row) {
    return wrapType(PlanDetailType.DB(row));
  }

  static const idField = "id";
  static const hitField = "hit";
  static const descField = "desc";
  static const createdAtField = "createdAt";
  static const Plan_refField = "Plan_ref";
  static const table = "PlanDetail";
  static const schema = '''
create table if not exists PlanDetail (
  id INTEGER PRIMARY KEY AUTOINCREMENT ,
hit INTEGER   ,
desc text   ,
createdAt text   ,
Plan_ref INTEGER   
);

''';
}

class PlanDetailType {
  late DBClientSet clientSet;

  int? id;
  int? hit;
  String? desc;
  DateTime? createdAt;
  int? Plan_ref;

  PlanDetailType({this.id, this.hit, this.desc, this.createdAt, this.Plan_ref});

  PlanDetailType fill(Map data) {
    if (data["id"] != null) {
      id = data["id"] as int;
    }

    if (data["hit"] != null) {
      hit = data["hit"] as int;
    }

    if (data["desc"] != null) {
      desc = data["desc"] as String;
    }

    if (data["createdAt"] != null) {
      createdAt = data["createdAt"] as DateTime;
    }

    if (data["Plan_ref"] != null) {
      Plan_ref = data["Plan_ref"] as int;
    }

    return this;
  }

  PlanDetailType fillByType(PlanDetailType obj) {
    if (obj.id != null) {
      id = obj.id;
    }

    if (obj.hit != null) {
      hit = obj.hit;
    }

    if (obj.desc != null) {
      desc = obj.desc;
    }

    if (obj.createdAt != null) {
      createdAt = obj.createdAt;
    }

    if (obj.Plan_ref != null) {
      Plan_ref = obj.Plan_ref;
    }

    return this;
  }

  PlanDetailType.DB(Map data) {
    id = data["id"] as int?;
    hit = data["hit"] as int?;
    desc = data["desc"] as String?;
    createdAt = data["createdAt"] == null
        ? null
        : string2DateTime(data["createdAt"] as String);
    Plan_ref = data["Plan_ref"] as int?;
  }

  Map<String, Object?> toDB() {
    final val = <String, Object?>{};

    void writeNotNull(String key, dynamic value) {
      if (value != null) {
        val[key] = value;
      }
    }

    writeNotNull('id', id);
    writeNotNull('hit', hit);
    writeNotNull('desc', desc);
    writeNotNull(
        'createdAt', createdAt == null ? null : dateTime2String(createdAt!));
    writeNotNull('Plan_ref', Plan_ref);

    return val;
  }

  Future<PlanDetailType> save() async {
    if (id == null) {
      id = await clientSet.PlanDetail().insert(this);
    } else {
      await clientSet.PlanDetail().update(this);
    }

    return (await clientSet.PlanDetail().first(id!))!;
  }

  Future<int> destory() async {
    if (id == null) {
      throw "current type not allow this opeart";
    }

    return await clientSet.PlanDetail().delete(id!);
  }

  Future<PlanType?> queryPlan() async {
    var rows = await clientSet.Plan()
        .query()
        .where(Eq("id", Plan_ref))
        .limit(1)
        .query();

    if (rows.isEmpty) {
      return null;
    }
    return rows[0];
  }

  PlanDetailType setPlan(int idx) {
    Plan_ref = idx;
    return this;
  }
}

class ThingClient {
  DBClientSet clientSet;
  ThingClient(this.clientSet);

  Future<int> delete(int id) async {
    return await clientSet.db
        .rawDelete("delete from $table where id = ?", [id]);
  }

  Future<ThingType?> first(int idx) async {
    var rows = await query().where(Eq("id", idx)).query();

    if (rows.isEmpty) {
      return null;
    }

    return rows[0];
  }

  Future<ThingType> firstOrNew(int idx) async {
    var rows = await query().where(Eq("id", idx)).query();

    if (rows.isEmpty) {
      var item = ThingType();
      if (idx > 0) {
        item.id = idx;
      }
      return wrapType(item);
    }

    return rows[0];
  }

  ThingType wrapType(ThingType typ) {
    typ.clientSet = clientSet;
    return typ;
  }

  Future<List<ThingType>> all() async {
    return await query().query();
  }

  QueryBuild<ThingType> query() {
    var qb = QueryBuild<ThingType>()..table(Table.from(table));
    qb.queryFunc = (String q) async {
      return (await clientSet.db.rawQuery(q))
          .map((e) => newTypeByRow(e))
          .toList();
    };
    return qb;
  }

  Future<int> insert(ThingType obj) async {
    return await clientSet.db.insert(table, obj.toDB());
  }

  Future<int> update(ThingType obj) async {
    return await clientSet.db
        .update(table, obj.toDB(), where: "id = ?", whereArgs: [obj.id!]);
  }

  ThingType newType() {
    return wrapType(ThingType());
  }

  ThingType newTypeByRow(Map row) {
    return wrapType(ThingType.DB(row));
  }

  static const idField = "id";
  static const nameField = "name";
  static const descField = "desc";
  static const table = "Thing";
  static const schema = '''
create table if not exists Thing (
  id INTEGER PRIMARY KEY AUTOINCREMENT ,
name text   ,
desc text   
);
create table if not exists Award_Thing (
Thing_ref INTEGER not null,
Award_ref INTEGER not null
);

''';
}

class ThingType {
  late DBClientSet clientSet;

  int? id;
  String? name;
  String? desc;

  ThingType({this.id, this.name, this.desc});

  ThingType fill(Map data) {
    if (data["id"] != null) {
      id = data["id"] as int;
    }

    if (data["name"] != null) {
      name = data["name"] as String;
    }

    if (data["desc"] != null) {
      desc = data["desc"] as String;
    }

    return this;
  }

  ThingType fillByType(ThingType obj) {
    if (obj.id != null) {
      id = obj.id;
    }

    if (obj.name != null) {
      name = obj.name;
    }

    if (obj.desc != null) {
      desc = obj.desc;
    }

    return this;
  }

  ThingType.DB(Map data) {
    id = data["id"] as int?;
    name = data["name"] as String?;
    desc = data["desc"] as String?;
  }

  Map<String, Object?> toDB() {
    final val = <String, Object?>{};

    void writeNotNull(String key, dynamic value) {
      if (value != null) {
        val[key] = value;
      }
    }

    writeNotNull('id', id);
    writeNotNull('name', name);
    writeNotNull('desc', desc);

    return val;
  }

  Future<ThingType> save() async {
    if (id == null) {
      id = await clientSet.Thing().insert(this);
    } else {
      await clientSet.Thing().update(this);
    }

    return (await clientSet.Thing().first(id!))!;
  }

  Future<int> destory() async {
    if (id == null) {
      throw "current type not allow this opeart";
    }
    await clientSet.db
        .rawDelete("delete from Award_Thing where Thing_ref = ?", [id]);
    return await clientSet.Thing().delete(id!);
  }

  Future<List<AwardType>> queryAward() async {
    var rows = await clientSet
        .query()
        .table(Table.from(AwardClient.table))
        .where(In("id", [
          clientSet
              .query()
              .table(Table.from("Award_Thing"))
              .select("Award_ref")
              .where(Eq("Thing_ref", id))
              .limit(1)
        ]))
        .query();
    return rows.map((row) => clientSet.Award().newTypeByRow(row)).toList();
  }

  Future<void> setAwards(List<int> ids) async {
    await clientSet.db
        .rawDelete("delete from Award_Thing where Thing_ref = ?", [id]);
    var it = ids.iterator;
    while (it.moveNext()) {
      await clientSet.db.rawInsert(
          "insert into Award_Thing(Thing_ref, Award_ref) values(?, ?)",
          [id, it.current]);
    }
    return;
  }
}

class HabitRecordClient {
  DBClientSet clientSet;
  HabitRecordClient(this.clientSet);

  Future<int> delete(int id) async {
    return await clientSet.db
        .rawDelete("delete from $table where id = ?", [id]);
  }

  Future<HabitRecordType?> first(int idx) async {
    var rows = await query().where(Eq("id", idx)).query();

    if (rows.isEmpty) {
      return null;
    }

    return rows[0];
  }

  Future<HabitRecordType> firstOrNew(int idx) async {
    var rows = await query().where(Eq("id", idx)).query();

    if (rows.isEmpty) {
      var item = HabitRecordType();
      if (idx > 0) {
        item.id = idx;
      }
      return wrapType(item);
    }

    return rows[0];
  }

  HabitRecordType wrapType(HabitRecordType typ) {
    typ.clientSet = clientSet;
    return typ;
  }

  Future<List<HabitRecordType>> all() async {
    return await query().query();
  }

  QueryBuild<HabitRecordType> query() {
    var qb = QueryBuild<HabitRecordType>()..table(Table.from(table));
    qb.queryFunc = (String q) async {
      return (await clientSet.db.rawQuery(q))
          .map((e) => newTypeByRow(e))
          .toList();
    };
    return qb;
  }

  Future<int> insert(HabitRecordType obj) async {
    return await clientSet.db.insert(table, obj.toDB());
  }

  Future<int> update(HabitRecordType obj) async {
    return await clientSet.db
        .update(table, obj.toDB(), where: "id = ?", whereArgs: [obj.id!]);
  }

  HabitRecordType newType() {
    return wrapType(HabitRecordType());
  }

  HabitRecordType newTypeByRow(Map row) {
    return wrapType(HabitRecordType.DB(row));
  }

  static const idField = "id";
  static const createdAtField = "createdAt";
  static const Habit_refField = "Habit_ref";
  static const table = "HabitRecord";
  static const schema = '''
create table if not exists HabitRecord (
  id INTEGER PRIMARY KEY AUTOINCREMENT ,
createdAt text   ,
Habit_ref INTEGER   
);

''';
}

class HabitRecordType {
  late DBClientSet clientSet;

  int? id;
  DateTime? createdAt;
  int? Habit_ref;

  HabitRecordType({this.id, this.createdAt, this.Habit_ref});

  HabitRecordType fill(Map data) {
    if (data["id"] != null) {
      id = data["id"] as int;
    }

    if (data["createdAt"] != null) {
      createdAt = data["createdAt"] as DateTime;
    }

    if (data["Habit_ref"] != null) {
      Habit_ref = data["Habit_ref"] as int;
    }

    return this;
  }

  HabitRecordType fillByType(HabitRecordType obj) {
    if (obj.id != null) {
      id = obj.id;
    }

    if (obj.createdAt != null) {
      createdAt = obj.createdAt;
    }

    if (obj.Habit_ref != null) {
      Habit_ref = obj.Habit_ref;
    }

    return this;
  }

  HabitRecordType.DB(Map data) {
    id = data["id"] as int?;
    createdAt = data["createdAt"] == null
        ? null
        : string2DateTime(data["createdAt"] as String);
    Habit_ref = data["Habit_ref"] as int?;
  }

  Map<String, Object?> toDB() {
    final val = <String, Object?>{};

    void writeNotNull(String key, dynamic value) {
      if (value != null) {
        val[key] = value;
      }
    }

    writeNotNull('id', id);
    writeNotNull(
        'createdAt', createdAt == null ? null : dateTime2String(createdAt!));
    writeNotNull('Habit_ref', Habit_ref);

    return val;
  }

  Future<HabitRecordType> save() async {
    if (id == null) {
      createdAt ??= DateTime.now();

      id = await clientSet.HabitRecord().insert(this);
    } else {
      await clientSet.HabitRecord().update(this);
    }

    return (await clientSet.HabitRecord().first(id!))!;
  }

  Future<int> destory() async {
    if (id == null) {
      throw "current type not allow this opeart";
    }

    return await clientSet.HabitRecord().delete(id!);
  }

  Future<HabitType?> queryHabit() async {
    var rows = await clientSet.Habit()
        .query()
        .where(Eq("id", Habit_ref))
        .limit(1)
        .query();

    if (rows.isEmpty) {
      return null;
    }
    return rows[0];
  }

  HabitRecordType setHabit(int idx) {
    Habit_ref = idx;
    return this;
  }
}

class PlanClient {
  DBClientSet clientSet;
  PlanClient(this.clientSet);

  Future<int> delete(int id) async {
    return await clientSet.db
        .rawDelete("delete from $table where id = ?", [id]);
  }

  Future<PlanType?> first(int idx) async {
    var rows = await query().where(Eq("id", idx)).query();

    if (rows.isEmpty) {
      return null;
    }

    return rows[0];
  }

  Future<PlanType> firstOrNew(int idx) async {
    var rows = await query().where(Eq("id", idx)).query();

    if (rows.isEmpty) {
      var item = PlanType();
      if (idx > 0) {
        item.id = idx;
      }
      return wrapType(item);
    }

    return rows[0];
  }

  PlanType wrapType(PlanType typ) {
    typ.clientSet = clientSet;
    return typ;
  }

  Future<List<PlanType>> all() async {
    return await query().query();
  }

  QueryBuild<PlanType> query() {
    var qb = QueryBuild<PlanType>()..table(Table.from(table));
    qb.queryFunc = (String q) async {
      return (await clientSet.db.rawQuery(q))
          .map((e) => newTypeByRow(e))
          .toList();
    };
    return qb;
  }

  Future<int> insert(PlanType obj) async {
    return await clientSet.db.insert(table, obj.toDB());
  }

  Future<int> update(PlanType obj) async {
    return await clientSet.db
        .update(table, obj.toDB(), where: "id = ?", whereArgs: [obj.id!]);
  }

  PlanType newType() {
    return wrapType(PlanType());
  }

  PlanType newTypeByRow(Map row) {
    return wrapType(PlanType.DB(row));
  }

  static const idField = "id";
  static const nameField = "name";
  static const descField = "desc";
  static const createdAtField = "createdAt";
  static const deadLineField = "deadLine";
  static const finishAtField = "finishAt";
  static const jointField = "joint";
  static const jointCountField = "jointCount";
  static const table = "Plan";
  static const schema = '''
create table if not exists Plan (
  id INTEGER PRIMARY KEY AUTOINCREMENT ,
name text   ,
desc text   ,
createdAt text   ,
deadLine text   ,
finishAt text   ,
joint INTEGER   ,
jointCount INTEGER   
);
create table if not exists Award_Plan (
Plan_ref INTEGER not null,
Award_ref INTEGER not null
);

''';
}

class PlanType {
  late DBClientSet clientSet;

  int? id;
  String? name;
  String? desc;
  DateTime? createdAt;
  DateTime? deadLine;
  DateTime? finishAt;
  int? joint;
  int? jointCount;

  PlanType(
      {this.id,
      this.name,
      this.desc,
      this.createdAt,
      this.deadLine,
      this.finishAt,
      this.joint,
      this.jointCount});

  PlanType fill(Map data) {
    if (data["id"] != null) {
      id = data["id"] as int;
    }

    if (data["name"] != null) {
      name = data["name"] as String;
    }

    if (data["desc"] != null) {
      desc = data["desc"] as String;
    }

    if (data["createdAt"] != null) {
      createdAt = data["createdAt"] as DateTime;
    }

    if (data["deadLine"] != null) {
      deadLine = data["deadLine"] as DateTime;
    }

    if (data["finishAt"] != null) {
      finishAt = data["finishAt"] as DateTime;
    }

    if (data["joint"] != null) {
      joint = data["joint"] as int;
    }

    if (data["jointCount"] != null) {
      jointCount = data["jointCount"] as int;
    }

    return this;
  }

  PlanType fillByType(PlanType obj) {
    if (obj.id != null) {
      id = obj.id;
    }

    if (obj.name != null) {
      name = obj.name;
    }

    if (obj.desc != null) {
      desc = obj.desc;
    }

    if (obj.createdAt != null) {
      createdAt = obj.createdAt;
    }

    if (obj.deadLine != null) {
      deadLine = obj.deadLine;
    }

    if (obj.finishAt != null) {
      finishAt = obj.finishAt;
    }

    if (obj.joint != null) {
      joint = obj.joint;
    }

    if (obj.jointCount != null) {
      jointCount = obj.jointCount;
    }

    return this;
  }

  PlanType.DB(Map data) {
    id = data["id"] as int?;
    name = data["name"] as String?;
    desc = data["desc"] as String?;
    createdAt = data["createdAt"] == null
        ? null
        : string2DateTime(data["createdAt"] as String);
    deadLine = data["deadLine"] == null
        ? null
        : string2DateTime(data["deadLine"] as String);
    finishAt = data["finishAt"] == null
        ? null
        : string2DateTime(data["finishAt"] as String);
    joint = data["joint"] as int?;
    jointCount = data["jointCount"] as int?;
  }

  Map<String, Object?> toDB() {
    final val = <String, Object?>{};

    void writeNotNull(String key, dynamic value) {
      if (value != null) {
        val[key] = value;
      }
    }

    writeNotNull('id', id);
    writeNotNull('name', name);
    writeNotNull('desc', desc);
    writeNotNull(
        'createdAt', createdAt == null ? null : dateTime2String(createdAt!));
    writeNotNull(
        'deadLine', deadLine == null ? null : dateTime2String(deadLine!));
    writeNotNull(
        'finishAt', finishAt == null ? null : dateTime2String(finishAt!));
    writeNotNull('joint', joint);
    writeNotNull('jointCount', jointCount);

    return val;
  }

  Future<PlanType> save() async {
    if (id == null) {
      joint ??= 0;

      id = await clientSet.Plan().insert(this);
    } else {
      await clientSet.Plan().update(this);
    }

    return (await clientSet.Plan().first(id!))!;
  }

  Future<int> destory() async {
    if (id == null) {
      throw "current type not allow this opeart";
    }
    await clientSet.db
        .rawDelete("delete from Award_Plan where Plan_ref = ?", [id]);
    return await clientSet.Plan().delete(id!);
  }

  Future<List<AwardType>> queryAward() async {
    var rows = await clientSet
        .query()
        .table(Table.from(AwardClient.table))
        .where(In("id", [
          clientSet
              .query()
              .table(Table.from("Award_Plan"))
              .select("Award_ref")
              .where(Eq("Plan_ref", id))
              .limit(1)
        ]))
        .query();
    return rows.map((row) => clientSet.Award().newTypeByRow(row)).toList();
  }

  Future<void> setAwards(List<int> ids) async {
    await clientSet.db
        .rawDelete("delete from Award_Plan where Plan_ref = ?", [id]);
    var it = ids.iterator;
    while (it.moveNext()) {
      await clientSet.db.rawInsert(
          "insert into Award_Plan(Plan_ref, Award_ref) values(?, ?)",
          [id, it.current]);
    }
    return;
  }

  Future<List<PlanDetailType>> queryPlanDetails() async {
    var rows =
        await clientSet.PlanDetail().query().where(Eq("Plan_ref", id)).query();

    return rows;
  }
}

class HabitClient {
  DBClientSet clientSet;
  HabitClient(this.clientSet);

  Future<int> delete(int id) async {
    return await clientSet.db
        .rawDelete("delete from $table where id = ?", [id]);
  }

  Future<HabitType?> first(int idx) async {
    var rows = await query().where(Eq("id", idx)).query();

    if (rows.isEmpty) {
      return null;
    }

    return rows[0];
  }

  Future<HabitType> firstOrNew(int idx) async {
    var rows = await query().where(Eq("id", idx)).query();

    if (rows.isEmpty) {
      var item = HabitType();
      if (idx > 0) {
        item.id = idx;
      }
      return wrapType(item);
    }

    return rows[0];
  }

  HabitType wrapType(HabitType typ) {
    typ.clientSet = clientSet;
    return typ;
  }

  Future<List<HabitType>> all() async {
    return await query().query();
  }

  QueryBuild<HabitType> query() {
    var qb = QueryBuild<HabitType>()..table(Table.from(table));
    qb.queryFunc = (String q) async {
      return (await clientSet.db.rawQuery(q))
          .map((e) => newTypeByRow(e))
          .toList();
    };
    return qb;
  }

  Future<int> insert(HabitType obj) async {
    return await clientSet.db.insert(table, obj.toDB());
  }

  Future<int> update(HabitType obj) async {
    return await clientSet.db
        .update(table, obj.toDB(), where: "id = ?", whereArgs: [obj.id!]);
  }

  HabitType newType() {
    return wrapType(HabitType());
  }

  HabitType newTypeByRow(Map row) {
    return wrapType(HabitType.DB(row));
  }

  static const idField = "id";
  static const nameField = "name";
  static const descField = "desc";
  static const countField = "count";
  static const notBeforeField = "notBefore";
  static const notAfterField = "notAfter";
  static const createdAtField = "createdAt";
  static const table = "Habit";
  static const schema = '''
create table if not exists Habit (
  id INTEGER PRIMARY KEY AUTOINCREMENT ,
name text   ,
desc text   ,
count INTEGER   ,
notBefore text   ,
notAfter text   ,
createdAt text   
);

''';
}

class HabitType {
  late DBClientSet clientSet;

  int? id;
  String? name;
  String? desc;
  int? count;
  DateTime? notBefore;
  DateTime? notAfter;
  DateTime? createdAt;

  HabitType(
      {this.id,
      this.name,
      this.desc,
      this.count,
      this.notBefore,
      this.notAfter,
      this.createdAt});

  HabitType fill(Map data) {
    if (data["id"] != null) {
      id = data["id"] as int;
    }

    if (data["name"] != null) {
      name = data["name"] as String;
    }

    if (data["desc"] != null) {
      desc = data["desc"] as String;
    }

    if (data["count"] != null) {
      count = data["count"] as int;
    }

    if (data["notBefore"] != null) {
      notBefore = data["notBefore"] as DateTime;
    }

    if (data["notAfter"] != null) {
      notAfter = data["notAfter"] as DateTime;
    }

    if (data["createdAt"] != null) {
      createdAt = data["createdAt"] as DateTime;
    }

    return this;
  }

  HabitType fillByType(HabitType obj) {
    if (obj.id != null) {
      id = obj.id;
    }

    if (obj.name != null) {
      name = obj.name;
    }

    if (obj.desc != null) {
      desc = obj.desc;
    }

    if (obj.count != null) {
      count = obj.count;
    }

    if (obj.notBefore != null) {
      notBefore = obj.notBefore;
    }

    if (obj.notAfter != null) {
      notAfter = obj.notAfter;
    }

    if (obj.createdAt != null) {
      createdAt = obj.createdAt;
    }

    return this;
  }

  HabitType.DB(Map data) {
    id = data["id"] as int?;
    name = data["name"] as String?;
    desc = data["desc"] as String?;
    count = data["count"] as int?;
    notBefore = data["notBefore"] == null
        ? null
        : string2DateTime(data["notBefore"] as String);
    notAfter = data["notAfter"] == null
        ? null
        : string2DateTime(data["notAfter"] as String);
    createdAt = data["createdAt"] == null
        ? null
        : string2DateTime(data["createdAt"] as String);
  }

  Map<String, Object?> toDB() {
    final val = <String, Object?>{};

    void writeNotNull(String key, dynamic value) {
      if (value != null) {
        val[key] = value;
      }
    }

    writeNotNull('id', id);
    writeNotNull('name', name);
    writeNotNull('desc', desc);
    writeNotNull('count', count);
    writeNotNull(
        'notBefore', notBefore == null ? null : dateTime2String(notBefore!));
    writeNotNull(
        'notAfter', notAfter == null ? null : dateTime2String(notAfter!));
    writeNotNull(
        'createdAt', createdAt == null ? null : dateTime2String(createdAt!));

    return val;
  }

  Future<HabitType> save() async {
    if (id == null) {
      count ??= 1;

      createdAt ??= DateTime.now();

      id = await clientSet.Habit().insert(this);
    } else {
      await clientSet.Habit().update(this);
    }

    return (await clientSet.Habit().first(id!))!;
  }

  Future<int> destory() async {
    if (id == null) {
      throw "current type not allow this opeart";
    }

    return await clientSet.Habit().delete(id!);
  }

  Future<List<HabitRecordType>> queryHabitRecords() async {
    var rows = await clientSet.HabitRecord()
        .query()
        .where(Eq("Habit_ref", id))
        .query();

    return rows;
  }
}
