import "package:maxilozoz_box/modules/storage/sqlite/sqlite.dart";
import 'package:maxilozoz_box/modules/storage/sqlite/build/annotation.dart';
part 'db.db.g.dart';

@DBSchema(
  fields: [
    DBMetaField(name: "identity"),
    DBMetaField(name: "apiKey"),
  ],
)
class Ngrok {}

@DBSchema(
  fields: [
    DBMetaField(name: "name"),
    DBMetaField(name: "desc"),
  ],
  edges: [
    DBMetaEdge(table: "Plan", type: DBEdgeType.To),
    DBMetaEdge(table: "Thing", type: DBEdgeType.To, unique: true),
  ],
)
class Award {}

@DBSchema(
  fields: [
    DBMetaField(name: "name"),
    DBMetaField(name: "desc"),
    DBMetaField(name: "createdAt", type: DBFieldType.DateTime),
    DBMetaField(name: "deadLine", type: DBFieldType.DateTime),
    DBMetaField(name: "finishAt", type: DBFieldType.DateTime),
    DBMetaField(name: "joint", type: DBFieldType.Int),
    DBMetaField(name: "jointCount", type: DBFieldType.Int),
  ],
  edges: [
    DBMetaEdge(table: "Award", type: DBEdgeType.From),
    DBMetaEdge(table: "PlanDetail", type: DBEdgeType.To),
  ],
)
class Plan {}

@DBSchema(
  fields: [
    DBMetaField(name: "hit", type: DBFieldType.Int),
    DBMetaField(name: "desc"),
    DBMetaField(name: "createdAt", type: DBFieldType.DateTime),
  ],
  edges: [
    DBMetaEdge(table: "Plan", type: DBEdgeType.From, unique: true),
  ],
)
class PlanDetail {}

@DBSchema(
  fields: [
    DBMetaField(name: "name"),
    DBMetaField(name: "desc"),
  ],
  edges: [
    DBMetaEdge(table: "Award", type: DBEdgeType.From),
  ],
)
class Thing {}
