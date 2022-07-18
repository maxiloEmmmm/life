// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'award.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Award _$AwardFromJson(Map<String, dynamic> json) => Award(
      id: json['id'] as int?,
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
  return val;
}
