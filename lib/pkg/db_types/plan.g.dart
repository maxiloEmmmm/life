// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Plan _$PlanFromJson(Map<String, dynamic> json) => Plan(
      id: json['id'] as int?,
      name: json['name'] as String?,
      desc: json['desc'] as String?,
      repeat: json['repeat'] as int?,
      enableRelation: _$JsonConverterFromJson<int, bool>(
          json['enableRelation'], const Bool2Int().fromJson),
      enableRepeat: _$JsonConverterFromJson<int, bool>(
          json['enableRepeat'], const Bool2Int().fromJson),
      relationID: json['relationID'] as int?,
      deadLine: json['deadLine'] == null
          ? null
          : DateTime.parse(json['deadLine'] as String),
    );

Map<String, dynamic> _$PlanToJson(Plan instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('name', instance.name);
  writeNotNull('desc', instance.desc);
  writeNotNull('repeat', instance.repeat);
  writeNotNull(
      'enableRepeat',
      _$JsonConverterToJson<int, bool>(
          instance.enableRepeat, const Bool2Int().toJson));
  writeNotNull('deadLine', instance.deadLine?.toIso8601String());
  writeNotNull('relationID', instance.relationID);
  writeNotNull(
      'enableRelation',
      _$JsonConverterToJson<int, bool>(
          instance.enableRelation, const Bool2Int().toJson));
  return val;
}

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
