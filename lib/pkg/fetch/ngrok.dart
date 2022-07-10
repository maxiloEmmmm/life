import 'package:json_annotation/json_annotation.dart';
import 'package:maxilozoz_box/application.dart';
import 'package:maxilozoz_box/modules/http/http.dart';
import 'package:dio/src/options.dart';
import 'package:sprintf/sprintf.dart';

part 'ngrok.g.dart';

class Ngrok {
  String key;

  Ngrok(this.key);

  Future<List<NgrokAgent>> agent() async {
    Http http = Application.instance?.make("http");

    try {
      var resp = await http.get("https://api.ngrok.com/tunnels",
          options: Options(headers: {
            'Authorization': sprintf("Bearer %s", [key]),
            'Ngrok-Version': 2,
          }));
      return NgrokAgentList.fromJson(resp.data).tunnels!;
    } catch (e) {
      return [];
    }
  }
}

@JsonSerializable()
class NgrokAgentList {
  List<NgrokAgent>? tunnels;
  String? uri;
  @JsonKey(name: 'next_page_uri')
  String? nextPageUri;

  NgrokAgentList();

  factory NgrokAgentList.fromJson(Map<String, dynamic> json) =>
      _$NgrokAgentListFromJson(json);

  Map<String, dynamic> toJson() => _$NgrokAgentListToJson(this);
}

@JsonSerializable()
class NgrokAgent {
  String? id;
  @JsonKey(name: 'public_url')
  String? publicUrl;
  @JsonKey(name: 'forwards_to')
  String? forwardsTo;

  NgrokAgent();

  factory NgrokAgent.fromJson(Map<String, dynamic> json) =>
      _$NgrokAgentFromJson(json);

  Map<String, dynamic> toJson() => _$NgrokAgentToJson(this);
}
