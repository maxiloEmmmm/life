import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focus/pkg/db_types/db.dart';
import 'package:focus/pkg/util/tip.dart';
import 'package:maxilozoz_box/application.dart';
import 'package:focus/pkg/component/item.dart';

class Plan extends StatefulWidget {
  const Plan({Key? key}) : super(key: key);

  @override
  State<Plan> createState() => _PlanState();
}

class _PlanState extends State<Plan> {
  List<PlanType> ifs = [];

  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future<List<PlanType>?>? fetchFunction() async {
    try {
      DBClientSet appDB = await Application.instance!.make("app_db");
      var rs = await appDB.Plan().all();
      rs.sort((a, b) {
        if (!a.finish && !b.finish) {
          return a.id! < b.id! ? 1 : -1;
        }

        return a.finish ? 1 : -1;
      });
      return rs;
    } catch (e) {
      return null;
    }
  }

  Future<void> fetch() async {
    setState(() {
      _fetch = fetchFunction();
    });
  }

  Future<List<PlanType>?>? _fetch;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PlanType>?>(
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

  Widget view(BuildContext context, List<PlanType>? ifs) {
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
                  .map((e) => Item<PlanType>(
                        type: "Plan",
                        title: (PlanType p) {
                          return p.name!;
                        },
                        onRemove: (PlanType p) async {
                          DBClientSet appDB =
                              await Application.instance!.make("app_db");
                          if ((await p.queryAward()).isNotEmpty) {
                            tip.TextAlertDesc(context, "存在奖励记录");
                            return;
                          }
                          await appDB.Plan().delete(p.id!);
                          fetch();
                        },
                        onUpdate: (PlanType p, Function() refresh) async {
                          Navigator.pushNamed(context, "/plan/update/${p.id}")
                              .then((value) => fetch());
                        },
                        fetch: () async {
                          DBClientSet appDB =
                              await Application.instance!.make("app_db");
                          return (await appDB.Plan().first(e.id!))!;
                        },
                        content: (BuildContext context, PlanType? p) {
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
                          ItemAction<PlanType>(
                              cb: (PlanType? p, Function() refresh) async {
                                DBClientSet appDB =
                                    await Application.instance!.make("app_db");
                                var target = (p!.joint ?? 0) + 1;
                                var jc = p.jointCount ?? 0;
                                if (target > jc || jc == 0) {
                                  tip.TextAlertDesc(context, "太大了!");
                                  return;
                                }

                                p.joint = target;
                                if (target == jc) {
                                  p.finishAt = DateTime.now();
                                }
                                await p.save();
                                fetch();
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
