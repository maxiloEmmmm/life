import 'package:json_annotation/json_annotation.dart';

import "package:maxilozoz_box/modules/storage/sqlite/sqlite.dart";
import 'package:maxilozoz_box/modules/storage/sqlite/build/db.dart';

part 'ngrok.g.dart';
part 'ngrok.db.g.dart';

@JsonSerializable(includeIfNull: false)
@DBAnnotation()
class Ngrok {
  @DBPKAnnotation()
  String? identity;

  String? apiKey;

  Ngrok({
    this.apiKey,
    this.identity
  });

  factory Ngrok.fromJson(Map<String, dynamic> json) =>
      _$NgrokFromJson(json);

  Map<String, dynamic> toJson() => _$NgrokToJson(this);
}