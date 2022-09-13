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
  late double jointCount;
  late DateTime start;
  late DateTime end;
  late int week;
  late int joint;
  late double weekCompensate;
}

extension PlanTypeHelp on PlanType {
  bool get finish {
    return joint == jointCount;
  }

  int get weekNum {
    return diffWeek(createdAt!, deadLine!);
  }

  int get dayNum {
    return diffDay(createdAt!, deadLine!) + 1;
  }

  int get goesDay {
    return diffDay(createdAt!, DateTime.now());
  }

  bool get willStart {
    return goesDay < 0;
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
    double eachWeekJoint = jointCount! / wn;
    var jc = joint ?? 0;
    while(cur <= wn) {
      PlanWeek pw = PlanWeek();
      pw.week = cur;
      pw.start = createdAt!.add(Duration(days: (cur-1)*7));
      pw.end = createdAt!.add(Duration(days: cur*7));

      var eu = eachWeekJoint * cur;
      pw.jointCount = eu > jointCount! ? eu - jointCount! : eachWeekJoint;
      pw.weekCompensate = 0;
      
      if(cur == currentWeek) {
        // 这周要多做一点
        var diffJoint = (eu - jc);
        if(diffJoint > pw.jointCount) {
          pw.weekCompensate = diffJoint - pw.jointCount;
          pw.jointCount += pw.weekCompensate;
        }

        //  做的太多了这周可少做点
        var diffPreJoint = jc - (eachWeekJoint * (cur - 1));
        if(diffPreJoint > 0) {
          pw.jointCount -= diffPreJoint;
          if(pw.jointCount < 0) {
            pw.jointCount = 0;
          }
          pw.weekCompensate = -diffPreJoint;
        }
      }
        
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
      var pdRows = await clientSet.PlanDetail().query()
        .where(And([
          // todo 生成父级查询
          Eq(PlanDetailClient.Plan_refField, id),
          GtE(PlanDetailClient.createdAtField, it.current.start.toString()),
          LtE(PlanDetailClient.createdAtField, it.current.end.toString())
        ])).query();
      int count = 0;
      pdRows.forEach((element) {count += element.hit!;});
      it.current.joint = count;
    }
    return es;
  }
}
