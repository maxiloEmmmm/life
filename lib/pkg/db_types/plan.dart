part of 'db.dart';

@DBSchema(
  fields: [
    DBMetaField(name: "name"),
    DBMetaField(name: "desc"),
    DBMetaField(name: "createdAt", type: DBFieldType.DateTime),
    DBMetaField(name: "deadLine", type: DBFieldType.DateTime),
    DBMetaField(name: "finishAt", type: DBFieldType.DateTime),
    DBMetaField(name: "joint", type: DBFieldType.Int, defaultDefine: "0"),
    DBMetaField(name: "jointCount", type: DBFieldType.Int),
  ],
  edges: [
    DBMetaEdge(table: "Award", type: DBEdgeType.From),
    DBMetaEdge(table: "PlanDetail", type: DBEdgeType.To),
  ],
)
class Plan {}

class PlanWeek {
  late int jointCount;
  late DateTime start;
  late DateTime end;
  late int week;
  late int joint;
}

extension PlanTypeHelp on PlanType {
  bool get finish {
    return joint == jointCount;
  }

  int get weekNum {
    return diffWeek(createdAt!, deadLine!);
  }

  int get goesDay {
    return diffDay(createdAt!, DateTime.now());
  }

  int get hasDay {
    return diffDay(DateTime.now(), deadLine!);
  }

  int get currentWeek {
    return diffWeek(createdAt!, DateTime.now());
  }

  List<PlanWeek> get eachWeekJoint {
    List<PlanWeek> ret = [];
    int cur = 1;
    int wn = weekNum;
    int eachWeekJoint = (jointCount! / wn).floor();
    while(cur <= wn) {
      PlanWeek pw = PlanWeek();
      pw.week = cur;
      pw.start = createdAt!.add(Duration(days: (cur-1)*7));
      pw.end = createdAt!.add(Duration(days: cur*7));

      int currWeekShould = cur * eachWeekJoint;
      pw.jointCount = currWeekShould > jointCount! ? currWeekShould - jointCount! : currWeekShould;
      ret.add(pw);
      cur++;
    }
    return ret;
  }

  Future<List<PlanWeek>> eachWeekJointStatus() async {
    var es = eachWeekJoint;
    var it = es.iterator;
    List<PlanWeek> piws = [];
    while(it.moveNext()) {
      var pdRows = await clientSet.PlanDetail().query("select * from ${PlanDetailClient.table} where ${PlanDetailClient.Plan_refField} = ? and ${PlanDetailClient.createdAtField} >= ? and ${PlanDetailClient.createdAtField} <= ?", [id, it.current.start.toString(), it.current.end.toString()]);
      it.current.joint = pdRows.length;
    }
    return es;
  }
}
