import 'package:json_annotation/json_annotation.dart';

import "package:maxilozoz_box/modules/storage/sqlite/sqlite.dart";
import 'package:maxilozoz_box/modules/storage/sqlite/build/annotation.dart';

part 'ngrok.g.dart';
part 'ngrok.db.g.dart';

@JsonSerializable(includeIfNull: false)
@DBAnnotation()
class Ngrok {
  @DBPKAnnotation()
  String? identity;

  @JsonKey(name: "api_key")
  String? apiKey;

  Ngrok({
    this.apiKey,
    this.identity
  });
}