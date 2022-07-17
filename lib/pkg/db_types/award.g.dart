// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'award.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Award _$AwardFromJson(Map<String, dynamic> json) => Award(
      id: json['id'] as int?,
      thingID: json['thing_id'] as int?,
      planIDs: _$JsonConverterFromJson<String, List<int>>(
          json['plan_ids'], const ListInt2String().fromJson),
      desc: json['desc'] as String?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$AwardToJson(Award instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('name', instance.name);
  writeNotNull('desc', instance.desc);
  writeNotNull('thing_id', instance.thingID);
  writeNotNull(
      'plan_ids',
      _$JsonConverterToJson<String, List<int>>(
          instance.planIDs, const ListInt2String().toJson));
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
