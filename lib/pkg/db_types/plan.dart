import 'dart:async';

import 'package:focus/pkg/build/db.dart';
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
  int? id;

  String? name;
  String? desc;

  int? repeat;
  bool? enableRepeat;

  DateTime? deadLine;

  int? relationID;
  bool? enableRelation;

  Plan({
    this.id,
    this.name,
    this.desc,
    this.repeat,
    this.enableRelation,
    this.enableRepeat,
    this.relationID,
    this.deadLine
  });

  factory Plan.fromJson(Map<String, dynamic> json) =>
      _$PlanFromJson(json);

  Map<String, dynamic> toJson() => _$PlanToJson(this);
}