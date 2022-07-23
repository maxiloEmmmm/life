import 'dart:async';

import 'package:maxilozoz_box/modules/storage/sqlite/build/annotation.dart';
import "package:maxilozoz_box/modules/storage/sqlite/sqlite.dart";
import 'package:focus/pkg/converters/bool_int.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:focus/pkg/db_types/planDetail.dart';
import 'package:focus/pkg/db_types/award.dart';
part 'plan.g.dart';
part 'plan.db.g.dart';

@JsonSerializable(includeIfNull: false, converters: [Bool2Int()])
@DBAnnotation(edges: [
  DBEdge(relation: "PlanDetail"),
  DBEdge(relation: "Award", belong: true),
])
class Plan {
  @DBPKAnnotation(AutoInsert: true)
  int? id;

  String? name;
  String? desc;

  DateTime? deadLine;
  DateTime? createdAt;
  DateTime? finishAt;

  int? joint;
  int? jointCount;

  bool get finish => joint == jointCount;
}
