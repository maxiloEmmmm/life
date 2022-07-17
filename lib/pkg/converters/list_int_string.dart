import 'package:json_annotation/json_annotation.dart';

class ListInt2String extends JsonConverter<List<int>, String> {
  const ListInt2String();

  @override
  List<int> fromJson(String json) {
    List<int> rets = [];
    json.split(",").forEach((element) {rets.add(int.parse(element));});
    return rets;
  }

  @override
  String toJson(List<int> object) {
    List<String> rets = [];
    object.forEach((element) {rets.add("$element");});
    return rets.join(",");
  }
}