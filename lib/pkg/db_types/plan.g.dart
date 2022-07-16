// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Plan _$PlanFromJson(Map<String, dynamic> json) => Plan(
      id: json['id'] as int?,
      name: json['name'] as String?,
      desc: json['desc'] as String?,
      joint: json['joint'] as int?,
      deadLine: json['deadLine'] == null
          ? null
          : DateTime.parse(json['deadLine'] as String),
    )..jointCount = json['jointCount'] as int?;

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
  writeNotNull('deadLine', instance.deadLine?.toIso8601String());
  writeNotNull('joint', instance.joint);
  writeNotNull('jointCount', instance.jointCount);
  return val;
}
