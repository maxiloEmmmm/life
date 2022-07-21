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
  List<db_plan.Plan> ifs = [];

  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future<List<db_plan.Plan>?>? fetchFunction() async {
    try {
      AppDB appDB = await Application.instance!.make("app_db");
      return await appDB.planClient.all();
    } catch (e) {
      return null;
    }
  }

  Future<void> fetch() async {
    setState(() {
      _fetch = fetchFunction();
    });
  }

  Future<List<db_plan.Plan>?>? _fetch;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<db_plan.Plan>?>(
      future: _fetch,
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          return view(context, snapshot.data);
        } else {
          return const CupertinoActivityIndicator();
        }
      },
    );
  }

  Widget view(BuildContext context, List<db_plan.Plan>? ifs) {
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
          child: ListView(
              shrinkWrap: true,
              children: ifs!
                  .map((e) => Item<db_plan.Plan>(
                        type: "Plan",
                        title: (db_plan.Plan p) {
                          return p.name!;
                        },
                        onRemove: (db_plan.Plan p) async {
                          AppDB appDB =
                              await Application.instance!.make("app_db");
                          await appDB.planClient.delete(p.id);
                          fetch();
                        },
                        onUpdate: (db_plan.Plan p, Function() refresh) async {
                          Navigator.pushNamed(context, "/plan/update/${p.id}")
                              .then((value) => refresh());
                        },
                        fetch: () async {
                          AppDB appDB =
                              await Application.instance!.make("app_db");
                          return (await appDB.planClient.first(e.id))!;
                        },
                        content: (BuildContext context, db_plan.Plan? p) {
                          return Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: p == null
                                    ? [const Text("错误了")]
                                    : [
                                        Text(p.desc!),
                                        Text(
                                            "joint: ${p.joint ?? 0}/${p.jointCount ?? 0}"),
                                        Text(
                                            "deadline: ${p.deadLine!.year}.${p.deadLine!.month}.${p.deadLine!.day}, 还有${p.deadLine!.difference(DateTime.now()).inDays}天"),
                                        Text(
                                            "day goes: ${DateTime.now().difference(p.createdAt!).inDays}天")
                                      ],
                              )
                            ],
                          );
                        },
                        actions: [
                          ItemAction<db_plan.Plan>(
                              cb: (db_plan.Plan? p, Function() refresh) async {
                                AppDB appDB =
                                    await Application.instance!.make("app_db");
                                var target = (p!.joint ?? 0) + 1;
                                var jc = p.jointCount ?? 0;
                                if (target > jc || jc == 0) {
                                  tip.TextAlertDesc(context, "太大了!");
                                  return;
                                }

                                var pp = db_plan.Plan(joint: target);
                                if (target == jc) {
                                  pp.finishAt = DateTime.now();
                                }
                                await appDB.planClient
                                    .update(p.id, pp);
                                refresh();
                              },
                              icon: const Icon(Icons.plus_one)),
                        ],
                      ))
                  .toList()),
        ),
      ),
    );
  }
}
