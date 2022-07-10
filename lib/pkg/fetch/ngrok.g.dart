// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ngrok.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NgrokAgentList _$NgrokAgentListFromJson(Map<String, dynamic> json) =>
    NgrokAgentList()
      ..tunnels = (json['tunnels'] as List<dynamic>?)
          ?.map((e) => NgrokAgent.fromJson(e as Map<String, dynamic>))
          .toList()
      ..uri = json['uri'] as String?
      ..nextPageUri = json['next_page_uri'] as String?;

Map<String, dynamic> _$NgrokAgentListToJson(NgrokAgentList instance) =>
    <String, dynamic>{
      'tunnels': instance.tunnels,
      'uri': instance.uri,
      'next_page_uri': instance.nextPageUri,
    };

NgrokAgent _$NgrokAgentFromJson(Map<String, dynamic> json) => NgrokAgent()
  ..id = json['id'] as String?
  ..publicUrl = json['public_url'] as String?
  ..forwardsTo = json['forwards_to'] as String?;

Map<String, dynamic> _$NgrokAgentToJson(NgrokAgent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'public_url': instance.publicUrl,
      'forwards_to': instance.forwardsTo,
    };
