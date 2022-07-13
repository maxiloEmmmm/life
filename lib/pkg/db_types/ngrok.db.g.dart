// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// DBGenerator
// **************************************************************************

part of 'ngrok.dart';

class NgrokClient {
  Database db;
  NgrokClient(this.db);

  Future<List<Ngrok>> all() async {
    return (await db.rawQuery("select * from Ngrok"))
        .map((e) => Ngrok.fromJson(e))
        .toList();
  }

  Future<int> insert(Ngrok obj) async {
    return await db.insert("Ngrok", obj.toJson());
  }

  Future<int> updateWhere(
      Ngrok obj, String? where, List<Object?>? whereArgs) async {
    return await db.update("Ngrok", obj.toJson(),
        where: where, whereArgs: whereArgs);
  }

  Future<int> delete(String? identity) async {
    return await db
        .rawDelete("delete from Ngrok where identity = ?", [identity]);
  }

  Future<int> update(String? identity, Ngrok obj) async {
    return await updateWhere(obj, "identity = ?", [identity]);
  }

  Future<Ngrok?> first(String? identity) async {
    //ignore more rows
    var rows = await db
        .rawQuery("select * from Ngrok where identity = ? limit 1", [identity]);
    if (rows.isEmpty) {
      return null;
    }

    return Ngrok.fromJson(rows[0]);
  }

  static var identityField = "identity";
  static var apiKeyField = "apiKey";
  static var dbTable = "Ngrok";
  static var dbSchema = '''
  create table Ngrok (
    identity TEXT;
    apiKey TEXT;
  
  );
  ''';
}
