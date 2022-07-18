import 'package:focus/pkg/converters/list_int_string.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:focus/pkg/db_types/plan.dart';
import 'package:focus/pkg/db_types/thing.dart';
import "package:maxilozoz_box/modules/storage/sqlite/sqlite.dart";
import 'package:maxilozoz_box/modules/storage/sqlite/build/annotation.dart';

part 'award.g.dart';
part 'award.db.g.dart';

@JsonSerializable(includeIfNull: false)
@DBAnnotation(edges: [
  DBEdge(relation: "Plan"),
  DBEdge(relation: "Thing", unique: true)
])
@ListInt2String()
class Award {
  @DBPKAnnotation(AutoInsert: true)
  int? id;

  String? name;

  String? desc;

  Award({
    this.id,
    this.desc,
    this.name
  });
}