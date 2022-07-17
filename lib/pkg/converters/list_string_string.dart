import 'package:json_annotation/json_annotation.dart';

class ListString2String extends JsonConverter<List<String>, String> {
  const ListString2String();

  @override
  List<String> fromJson(String json) {
    return json.split(",");
  }

  @override
  String toJson(List<String> object) {
    return object.join(",");
  }
}