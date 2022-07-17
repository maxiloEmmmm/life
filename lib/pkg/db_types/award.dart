import 'package:focus/pkg/converters/list_int_string.dart';
import 'package:json_annotation/json_annotation.dart';

import "package:maxilozoz_box/modules/storage/sqlite/sqlite.dart";
import 'package:maxilozoz_box/modules/storage/sqlite/build/annotation.dart';

part 'award.g.dart';
part 'award.db.g.dart';

@JsonSerializable(includeIfNull: false)
@DBAnnotation()
@ListInt2String()
class Award {
  @DBPKAnnotation(AutoInsert: true)
  int? id;

  String? name;

  String? desc;

  @JsonKey(name: "thing_id")
  int? thingID;

  @JsonKey(name: "plan_ids")
  List<int>? planIDs;

  Award({
    this.id,
    this.thingID,
    this.planIDs,
    this.desc,
    this.name
  });
}