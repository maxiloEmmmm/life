import 'dart:async';

import 'package:maxilozoz_box/modules/storage/sqlite/build/annotation.dart';
import "package:maxilozoz_box/modules/storage/sqlite/sqlite.dart";
import 'package:focus/pkg/converters/bool_int.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:focus/pkg/db_types/plan.dart';

part 'planDetail.g.dart';
part 'planDetail.db.g.dart';

@JsonSerializable(includeIfNull: false, converters: [Bool2Int()])
@DBAnnotation(edges: [DBEdge(relation: "Plan", unique: true)])
class PlanDetail {
  @DBPKAnnotation(AutoInsert: true)
  int? id;

  int? hit;
  String? desc;

  DateTime? createdAt;

  PlanDetail({
    this.id,
    this.hit,
    this.desc,
    this.createdAt,
  });
}
