import 'dart:async';

import 'package:maxilozoz_box/modules/storage/sqlite/build/annotation.dart';
import "package:maxilozoz_box/modules/storage/sqlite/sqlite.dart";
import 'package:focus/pkg/converters/bool_int.dart';
import 'package:json_annotation/json_annotation.dart';

part 'plan.g.dart';
part 'plan.db.g.dart';
@JsonSerializable(
  includeIfNull: false,
  converters: [Bool2Int()]
)
@DBAnnotation()
class Plan {
  @DBPKAnnotation(AutoInsert: true)
  int? id;

  String? name;
  String? desc;

  DateTime? deadLine;

  int? joint;
  int? jointCount;


  Plan({
    this.id,
    this.name,
    this.desc,
    this.joint,
    this.jointCount,
    this.deadLine
  });
}