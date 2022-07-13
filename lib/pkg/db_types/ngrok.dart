import 'package:focus/pkg/build/build.dart';
import 'package:focus/pkg/build/db.dart';
import 'package:json_annotation/json_annotation.dart';

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