// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ngrok.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ngrok _$NgrokFromJson(Map<String, dynamic> json) => Ngrok(
      apiKey: json['api_key'] as String?,
      identity: json['identity'] as String?,
    );

Map<String, dynamic> _$NgrokToJson(Ngrok instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('identity', instance.identity);
  writeNotNull('api_key', instance.apiKey);
  return val;
}
