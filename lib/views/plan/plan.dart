import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focus/pkg/db_types/plan.dart' as db_plan;
import 'package:focus/pkg/provider/db.dart';
import 'package:focus/pkg/util/tip.dart';
import 'package:maxilozoz_box/application.dart';
import 'package:sprintf/sprintf.dart';
import 'package:focus/pkg/component/item.dart';

class Plan extends StatefulWidget {
  const Plan({Key? key}) : super(key: key);

  @override
  State<Plan> createState() => _PlanState();
}

class _PlanState extends State<Plan> {
  List<ItemFetch> ifs = [];

  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future<List<ItemFetch>?>? fetchFunction() async {
      try {
        AppDB appDB = await Application.instance!.make("app_db");
        var ps = await appDB.planClient.all();
        return ps.map((e) => PlanFetch(() => context, e, () => fetch())).toList();
      }catch(e) {
        return null;
      }
  }

  Future<void> fetch() async {
    setState(() {
      _fetch = fetchFunction();
    });
  }

  Future<List<ItemFetch>?>? _fetch;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ItemFetch>?>(
      future: _fetch,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          return view(context, snapshot.data);
        }else {
          return const CupertinoActivityIndicator();
        }
      },
    );
  }

  Widget view(BuildContext context, List<ItemFetch>? ifs) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box),
            onPressed: () {
              Navigator.pushNamed(context, "/plan/add")
                .then((value) => fetch());
            },
          )
        ],

      ),
      body: RefreshIndicator(
        onRefresh: () => fetch(),
        child: Container(
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
          color: Colors.grey[150],
          child: ListView(shrinkWrap: true, children: ifs!.map((e) => Item(ng: e, actions: [
            IconButton(onPressed: () async {
              AppDB appDB = await Application.instance!.make("app_db");
              var p = (e as PlanFetch).plan;
              var target = (p.joint ?? 0) + 1;
              var jc = p.jointCount ?? 0;
              if(target > jc || jc == 0) {
                tip.TextAlertDesc(context, "太大了!");
                return;
              }
              await appDB.planClient.update(p.id, db_plan.Plan(joint: (p.joint ?? 0) + 1));
              tip.TextAlertDescWithCB(context, "ok", () async {
                // todo 现在setState会导致整个树被rebuild 重构一下item
                setState(() {
                });
              });
            }, icon: const Icon(Icons.plus_one)),
          ],)).toList()),
        ),
      ),
    );
  }
}

class PlanFetch extends ItemFetch {
  db_plan.Plan plan;
  String title = "";
  BuildContext Function() getCtx;
  Function() onChange;
  PlanFetch(this.getCtx, this.plan, this.onChange);

  @override
  String identity() {
    return plan.name ?? "";
  }

  @override
  Future<ItemInfo> fetch() async {
    bool error = false;
    try {
      AppDB appDB = await Application.instance!.make("app_db");
      plan = (await appDB.planClient.first(plan.id))!;
    }catch(e) {
      error = true;
    }
    return PlanInfo(plan, error);
  }

  @override
  String type() {
    return "Plan";
  }

  @override
  Future remove(BuildContext context) async {
    try {
      AppDB appDB = await Application.instance!.make("app_db");
      await appDB.planClient.delete(plan.id);
      onChange();
    }catch(e) {
      tip.TextAlertDesc(getCtx(), "出错了");
    }
  }

  @override
  Future update(BuildContext context) async {
    // todo 返回后刷新 因为update是在item里被调用
    // 无法在返回时调用列表刷新
    await Navigator.pushNamed(context, "/plan/update/${plan.id}");
  }
}

class PlanInfo extends ItemInfo {
  db_plan.Plan? p;
  bool error;
  PlanInfo(this.p, this.error);

  @override
  Widget child(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: error ? [
            const Text("错误了")
          ] : [
            Text(p!.desc!),
            Text("joint: ${p!.joint ?? 0}/${p!.jointCount ?? 0}"),
            Text("deadline: ${p!.deadLine!.year}.${p!.deadLine!.month}.${p!.deadLine!.day}, 还有${p!.deadLine!.difference(DateTime.now()).inDays}天")
          ],
        )
      ],
    );
  }
}
