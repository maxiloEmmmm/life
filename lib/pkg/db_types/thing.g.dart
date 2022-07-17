// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Thing _$ThingFromJson(Map<String, dynamic> json) => Thing(
      id: json['id'] as int?,
      name: json['name'] as String?,
      desc: json['desc'] as String?,
    );

Map<String, dynamic> _$ThingToJson(Thing instance) {
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
