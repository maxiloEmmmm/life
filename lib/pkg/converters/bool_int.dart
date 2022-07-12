import 'package:json_annotation/json_annotation.dart';

class Bool2Int extends JsonConverter<bool, int> {
  const Bool2Int();

  @override
  bool fromJson(int json) {
    return json == 0;
  }

  @override
  int toJson(bool object) {
    return object ? 0 : 1;
  }
}