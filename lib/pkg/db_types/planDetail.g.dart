// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'planDetail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlanDetail _$PlanDetailFromJson(Map<String, dynamic> json) => PlanDetail(
      id: json['id'] as int?,
      hit: json['hit'] as int?,
      desc: json['desc'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$PlanDetailToJson(PlanDetail instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('hit', instance.hit);
  writeNotNull('desc', instance.desc);
  writeNotNull('createdAt', instance.createdAt?.toIso8601String());
  return val;
}
