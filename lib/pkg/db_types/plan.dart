part of 'db.dart';

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

extension PlanTypeHelp on PlanType {
  bool get finish {
    return joint == jointCount;
  }
}
