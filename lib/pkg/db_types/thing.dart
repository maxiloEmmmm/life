import 'package:json_annotation/json_annotation.dart';

import "package:maxilozoz_box/modules/storage/sqlite/sqlite.dart";
import 'package:maxilozoz_box/modules/storage/sqlite/build/annotation.dart';
import 'package:focus/pkg/db_types/award.dart';
part 'thing.g.dart';
part 'thing.db.g.dart';

@JsonSerializable(includeIfNull: false)
@DBAnnotation(edges: [DBEdge(relation: "Award", belong: true)])
class Thing {
  @DBPKAnnotation(AutoInsert: true)
  int? id;

  String? name;

  String? desc;

  Thing({this.id, this.name, this.desc});
}
