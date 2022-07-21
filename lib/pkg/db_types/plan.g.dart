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
      jointCount: json['jointCount'] as int?,
      deadLine: json['deadLine'] == null
          ? null
          : DateTime.parse(json['deadLine'] as String),
    )
      ..createdAt = json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String)
      ..finishAt = json['finishAt'] == null
          ? null
          : DateTime.parse(json['finishAt'] as String);

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
  writeNotNull('createdAt', instance.createdAt?.toIso8601String());
  writeNotNull('finishAt', instance.finishAt?.toIso8601String());
  writeNotNull('joint', instance.joint);
  writeNotNull('jointCount', instance.jointCount);
  return val;
}
