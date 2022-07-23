// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// DBGenerator
// **************************************************************************

part of 'ngrok.dart';

class NgrokClient {
  Database db;
  NgrokClient(this.db);

  Future<List<NgrokType>> all() async {
    return (await db.rawQuery("select * from $table"))
        .map((e) => NgrokType.fromMap(e))
        .toList();
  }

  Future<List<NgrokType>> query(String sub, [List<Object?>? arguments]) async {
    return (await db.rawQuery("select * from $table $sub", arguments))
        .map((e) => NgrokType.fromMap(e))
        .toList();
  }

  Future<int> insert(NgrokType obj) async {
    return await db.insert(table, obj.toMap());
  }

  Future<int> updateWhere(
      NgrokType obj, String? where, List<Object?>? whereArgs) async {
    return await db.update(table, obj.toMap(),
        where: where, whereArgs: whereArgs);
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
  int? id;
  String? identity;
  String? apiKey;

  NgrokType({this.id, this.identity, this.apiKey});

  // idea from JsonSerializableGenerator
  NgrokType.fromMap(Map data) {
    id = data["id"] as int?;
    identity = data["identity"] as String?;
    apiKey = data["apiKey"] as String?;
  }

  // idea from JsonSerializableGenerator
  Map<String, Object?> toMap() {
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
