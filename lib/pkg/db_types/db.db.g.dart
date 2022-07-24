// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// DBGenerator
// **************************************************************************

part of 'db.dart';

class DBClientSet {
  NgrokClient Ngrok() {
    return NgrokClient(db, this);
  }

  AwardClient Award() {
    return AwardClient(db, this);
  }

  PlanClient Plan() {
    return PlanClient(db, this);
  }

  PlanDetailClient PlanDetail() {
    return PlanDetailClient(db, this);
  }

  ThingClient Thing() {
    return ThingClient(db, this);
  }

  Database db;
  static const schema = '''
${NgrokClient.schema}
${AwardClient.schema}
${PlanClient.schema}
${PlanDetailClient.schema}
${ThingClient.schema}
''';
  DBClientSet(this.db);
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
  Database db;
  NgrokClient(this.db, this.clientSet);

  Future<int> delete(int id) async {
    return await db.rawDelete("delete from $table where id = ?", [id]);
  }

  Future<NgrokType?> first(int id) async {
    var rows = await query("select * from $table where id = ?", [id]);
    if (rows.isEmpty) {
      return null;
    }

    return rows[0];
  }

  NgrokType wrapType(NgrokType typ) {
    typ.clientSet = clientSet;
    return typ;
  }

  Future<List<NgrokType>> all() async {
    return await query("select * from $table", []);
  }

  Future<List<NgrokType>> query(String query,
      [List<Object?>? arguments]) async {
    return (await db.rawQuery(query, arguments))
        .map((e) => newTypeByRow(e))
        .toList();
  }

  Future<int> insert(NgrokType obj) async {
    return await db.insert(table, obj.toDB());
  }

  Future<int> update(NgrokType obj) async {
    return await db
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
  id INTEGER PRIMARY KEY AUTOINCREMENT 
identity text   
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
  Database db;
  AwardClient(this.db, this.clientSet);

  Future<int> delete(int id) async {
    return await db.rawDelete("delete from $table where id = ?", [id]);
  }

  Future<AwardType?> first(int id) async {
    var rows = await query("select * from $table where id = ?", [id]);
    if (rows.isEmpty) {
      return null;
    }

    return rows[0];
  }

  AwardType wrapType(AwardType typ) {
    typ.clientSet = clientSet;
    return typ;
  }

  Future<List<AwardType>> all() async {
    return await query("select * from $table", []);
  }

  Future<List<AwardType>> query(String query,
      [List<Object?>? arguments]) async {
    return (await db.rawQuery(query, arguments))
        .map((e) => newTypeByRow(e))
        .toList();
  }

  Future<int> insert(AwardType obj) async {
    return await db.insert(table, obj.toDB());
  }

  Future<int> update(AwardType obj) async {
    return await db
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
  id INTEGER PRIMARY KEY AUTOINCREMENT 
name text   
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
    var rows = await clientSet.db.rawQuery(
        "select * from ${PlanClient.table} where id in (select Plan_ref from Award_Plan where Award_ref = ? )",
        [id]);
    return rows.map((row) => clientSet.Plan().newTypeByRow(row)).toList();
  }

  Future<void> setPlans(List<int> ids) async {
    while (ids.iterator.moveNext()) {
      await clientSet.db.rawInsert(
          "insert into Award_Plan(Award_ref, Plan_ref) values(?, ?)",
          [id, ids.iterator.current]);
    }
  }

  Future<ThingType?> queryThing() async {
    var rows = await clientSet.db.rawQuery(
        "select * from ${ThingClient.table} where id in (select Thing_ref from Award_Thing where Award_ref = ? limit 1)",
        [id]);
    if (rows.isEmpty) {
      return null;
    }
    return clientSet.Thing().newTypeByRow(rows[0]);
  }

  Future<void> setThing(int id) async {
    var ids = [id];
    while (ids.iterator.moveNext()) {
      await clientSet.db.rawInsert(
          "insert into Award_Thing(Award_ref, Thing_ref) values(?, ?)",
          [id, ids.iterator.current]);
    }
  }
}

class PlanClient {
  DBClientSet clientSet;
  Database db;
  PlanClient(this.db, this.clientSet);

  Future<int> delete(int id) async {
    return await db.rawDelete("delete from $table where id = ?", [id]);
  }

  Future<PlanType?> first(int id) async {
    var rows = await query("select * from $table where id = ?", [id]);
    if (rows.isEmpty) {
      return null;
    }

    return rows[0];
  }

  PlanType wrapType(PlanType typ) {
    typ.clientSet = clientSet;
    return typ;
  }

  Future<List<PlanType>> all() async {
    return await query("select * from $table", []);
  }

  Future<List<PlanType>> query(String query, [List<Object?>? arguments]) async {
    return (await db.rawQuery(query, arguments))
        .map((e) => newTypeByRow(e))
        .toList();
  }

  Future<int> insert(PlanType obj) async {
    return await db.insert(table, obj.toDB());
  }

  Future<int> update(PlanType obj) async {
    return await db
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
  id INTEGER PRIMARY KEY AUTOINCREMENT 
name text   
desc text   
createdAt text   
deadLine text   
finishAt text   
joint INTEGER   
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
    var rows = await clientSet.db.rawQuery(
        "select * from ${AwardClient.table} where id in (select Award_ref from Award_Plan where Plan_ref = ? limit 1)",
        [id]);
    return rows.map((row) => clientSet.Award().newTypeByRow(row)).toList();
  }

  Future<void> setAwards(List<int> ids) async {
    await clientSet.db
        .rawDelete("delete from Award_Plan where Plan_ref = ?", [id]);
    while (ids.iterator.moveNext()) {
      await clientSet.db.rawInsert(
          "insert into Award_Plan(Plan_ref, Award_ref) values(?, ?)",
          [id, ids.iterator.current]);
    }
    return;
  }

  Future<List<PlanDetailType>> queryPlanDetails() async {
    var rows = clientSet.PlanDetail().query("where Plan_ref = ? ", [id]);
    return rows;
  }
}

class PlanDetailClient {
  DBClientSet clientSet;
  Database db;
  PlanDetailClient(this.db, this.clientSet);

  Future<int> delete(int id) async {
    return await db.rawDelete("delete from $table where id = ?", [id]);
  }

  Future<PlanDetailType?> first(int id) async {
    var rows = await query("select * from $table where id = ?", [id]);
    if (rows.isEmpty) {
      return null;
    }

    return rows[0];
  }

  PlanDetailType wrapType(PlanDetailType typ) {
    typ.clientSet = clientSet;
    return typ;
  }

  Future<List<PlanDetailType>> all() async {
    return await query("select * from $table", []);
  }

  Future<List<PlanDetailType>> query(String query,
      [List<Object?>? arguments]) async {
    return (await db.rawQuery(query, arguments))
        .map((e) => newTypeByRow(e))
        .toList();
  }

  Future<int> insert(PlanDetailType obj) async {
    return await db.insert(table, obj.toDB());
  }

  Future<int> update(PlanDetailType obj) async {
    return await db
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
  static const table = "PlanDetail";
  static const schema = '''
create table if not exists PlanDetail (
  id INTEGER PRIMARY KEY AUTOINCREMENT 
hit INTEGER   
desc text   
createdAt text   
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
    var rows = await clientSet.Plan().query("where id = ? limit 1", [Plan_ref]);
    if (rows.isEmpty) {
      return null;
    }
    return rows[0];
  }

  Future<PlanDetailType> setPlan(int id) async {
    Plan_ref = id;
    return await save();
  }
}

class ThingClient {
  DBClientSet clientSet;
  Database db;
  ThingClient(this.db, this.clientSet);

  Future<int> delete(int id) async {
    return await db.rawDelete("delete from $table where id = ?", [id]);
  }

  Future<ThingType?> first(int id) async {
    var rows = await query("select * from $table where id = ?", [id]);
    if (rows.isEmpty) {
      return null;
    }

    return rows[0];
  }

  ThingType wrapType(ThingType typ) {
    typ.clientSet = clientSet;
    return typ;
  }

  Future<List<ThingType>> all() async {
    return await query("select * from $table", []);
  }

  Future<List<ThingType>> query(String query,
      [List<Object?>? arguments]) async {
    return (await db.rawQuery(query, arguments))
        .map((e) => newTypeByRow(e))
        .toList();
  }

  Future<int> insert(ThingType obj) async {
    return await db.insert(table, obj.toDB());
  }

  Future<int> update(ThingType obj) async {
    return await db
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
  id INTEGER PRIMARY KEY AUTOINCREMENT 
name text   
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
    var rows = await clientSet.db.rawQuery(
        "select * from ${AwardClient.table} where id in (select Award_ref from Award_Thing where Thing_ref = ? limit 1)",
        [id]);
    return rows.map((row) => clientSet.Award().newTypeByRow(row)).toList();
  }

  Future<void> setAwards(List<int> ids) async {
    await clientSet.db
        .rawDelete("delete from Award_Thing where Thing_ref = ?", [id]);
    while (ids.iterator.moveNext()) {
      await clientSet.db.rawInsert(
          "insert into Award_Thing(Thing_ref, Award_ref) values(?, ?)",
          [id, ids.iterator.current]);
    }
    return;
  }
}
