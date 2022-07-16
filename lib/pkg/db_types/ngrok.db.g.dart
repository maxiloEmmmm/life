// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// DBGenerator
// **************************************************************************

part of 'ngrok.dart';

class NgrokJSONHelp {
  static Ngrok fromJson(Map<String, dynamic> json) => _$NgrokFromJson(json);
  static Map<String, dynamic> toJson(Ngrok obj) => _$NgrokToJson(obj);
}

class NgrokClient {
  Database db;
  NgrokClient(this.db);

  Future<List<Ngrok>> all() async {
    return (await db.rawQuery("select * from $dbTable"))
        .map((e) => NgrokJSONHelp.fromJson(e))
        .toList();
  }

  Future<int> insert(Ngrok obj) async {
    return await db.insert(dbTable, NgrokJSONHelp.toJson(obj));
  }

  Future<int> updateWhere(
      Ngrok obj, String? where, List<Object?>? whereArgs) async {
    return await db.update(dbTable, NgrokJSONHelp.toJson(obj),
        where: where, whereArgs: whereArgs);
  }

  Future<int> delete(String? identity) async {
    return await db
        .rawDelete("delete from $dbTable where $identityField = ?", [identity]);
  }

  Future<int> update(String? identity, Ngrok obj) async {
    return await updateWhere(obj, "$identityField = ?", [identity]);
  }

  Future<Ngrok?> first(String? identity) async {
    //ignore more rows
    var rows = await db.rawQuery(
        "select * from $dbTable where $identityField = ? limit 1", [identity]);
    if (rows.isEmpty) {
      return null;
    }

    return NgrokJSONHelp.fromJson(rows[0]);
  }

  static const identityField = "identity";
  static const apiKeyField = "api_key";
  static const dbTable = "Ngrok";
  static const dbSchema = '''
  create table if not exists $dbTable (
    $identityField TEXT PRIMARY KEY ,
    $apiKeyField TEXT
  
  );
  ''';
}
