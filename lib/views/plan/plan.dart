import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focus/pkg/component/form.dart';
import 'package:focus/pkg/component/process.dart';
import 'package:focus/pkg/db_types/db.dart';
import 'package:focus/pkg/util/date.dart';
import 'package:focus/pkg/util/tip.dart';
import 'package:maxilozoz_box/application.dart';
import 'package:focus/pkg/component/item.dart';

class Plan extends StatefulWidget {
  const Plan({Key? key}) : super(key: key);

  @override
  State<Plan> createState() => _PlanState();
}

class PlanInfo {
  late PlanType pt;
  late List<PlanWeek> pw;
}

class _PlanState extends State<Plan> {
  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future<List<PlanType>?>? fetchFunction() async {
    try {
      DBClientSet appDB = await Application.instance!.make("app_db");
      var rs = await appDB.Plan().all();
      var now = DateTime.now();
      rs.sort((a, b) {
        if (!a.finish || !b.finish) {
          // 过期往前放
          if (diffDay(a.deadLine!, now) > 0) {
            return -1;
          }

          // 过期往前放
          if (diffDay(b.deadLine!, now) > 0) {
            return 1;
          }
        }

        if (!a.finish && !b.finish) {
          // 没完成 最近创建的往前放
          return a.id! < b.id! ? 1 : -1;
        }

        // 完成的往后放
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
                  .map((e) => Item<PlanInfo>(
                        type: "Plan",
                        title: (PlanInfo p) {
                          return p.pt.name!;
                        },
                        onRemove: (PlanInfo p) async {
                          DBClientSet appDB =
                              await Application.instance!.make("app_db");
                          if ((await p.pt.queryAward()).isNotEmpty) {
                            tip.TextAlertDesc(context, "存在奖励记录");
                            return;
                          }
                          await appDB.Plan().delete(p.pt.id!);
                          fetch();
                        },
                        onUpdate: (PlanInfo p, Function() refresh) async {
                          Navigator.pushNamed(
                                  context, "/plan/update/${p.pt.id}")
                              .then((value) => fetch());
                        },
                        fetch: () async {
                          DBClientSet appDB =
                              await Application.instance!.make("app_db");
                          PlanInfo pi = PlanInfo();
                          pi.pt = (await appDB.Plan().first(e.id!))!;
                          pi.pw = await pi.pt.eachWeekJointStatus();
                          return pi;
                        },
                        content: (BuildContext context, PlanInfo? p) {
                          return Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: p == null
                                      ? [const Text("错误了")]
                                      : [
                                          Text(p.pt.desc!),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: () {
                                              var oldWeek = p.pw
                                                  .where((e) =>
                                                      diffDay(DateTime.now(),
                                                          e.end) <=
                                                      7)
                                                  .toList();
                                              return oldWeek.getRange(
                                                  oldWeek.length >= 3
                                                      ? oldWeek.length - 3
                                                      : 0,
                                                  oldWeek.length);
                                            }()
                                                .map((pw) => Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4),
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(2),
                                                            decoration: BoxDecoration(
                                                                color: pw.week ==
                                                                        p.pt
                                                                            .currentWeek
                                                                    ? Colors.red
                                                                    : Colors
                                                                        .orange
                                                                        .shade600,
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            6))),
                                                            child: Text(
                                                              "第${pw.week}周",
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                          Text(
                                                              "${pw.joint}/${pw.jointCount == pw.jointCount.truncate().toDouble() ? pw.jointCount.truncate() : pw.jointCount.toStringAsFixed(1)}"),
                                                          pw.week ==
                                                                  p.pt
                                                                      .currentWeek
                                                              ? Text(
                                                                  "剩${diffDay(DateTime.now(), pw.end)}天")
                                                              : Container()
                                                        ],
                                                      ),
                                                    ))
                                                .toList(),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  "${p.pt.createdAt!.year}.${p.pt.createdAt!.month}.${p.pt.createdAt!.day} ~ ${p.pt.deadLine!.year}.${p.pt.deadLine!.month}.${p.pt.deadLine!.day}"),
                                              Text(
                                                  "joint: ${p.pt.joint ?? 0}/${p.pt.jointCount ?? 0}"),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("${p.pt.goesDay}天"),
                                              Expanded(
                                                flex: 1,
                                                child: Center(
                                                  child: Text(
                                                      "共${diffDay(p.pt.createdAt!, p.pt.deadLine!)}天, ${diffWeek(p.pt.createdAt!, p.pt.deadLine!)}周"),
                                                ),
                                              ),
                                              Text("${p.pt.hasDay}天")
                                            ],
                                          ),
                                          Container(
                                              child: Process(
                                                p.pt.goesDay /
                                                    diffDay(p.pt.createdAt!,
                                                        p.pt.deadLine!),
                                                color: Colors.deepOrange,
                                              ),
                                              height: 10),
                                        ],
                                ),
                              )
                            ],
                          );
                        },
                        actions: [
                          ItemAction<PlanInfo>(
                              cb: (PlanInfo? p, Function() refresh) async {
                                DBClientSet appDB =
                                    await Application.instance!.make("app_db");

                                var pdt = PlanDetailType(
                                  hit: 1,
                                  createdAt: DateTime.now(),
                                );
                                // todo only save
                                var fu = FormUtil(
                                    title: "记录",
                                    fis: [
                                      FormItem(
                                          field: PlanDetailClient.hitField,
                                          title: "增加",
                                          type: FormItemType.intType,
                                          defaultValue: "1",
                                          help: ">0",
                                          validate: (value) =>
                                              value as int > 0),
                                      FormItem(
                                          field: PlanDetailClient.descField,
                                          title: "描述")
                                    ],
                                    save:
                                        (BuildContext context, FormData data) {
                                      pdt.fill(data.data);
                                      Navigator.pop(context);
                                    });

                                await showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        fu.view(context));
                                var jc = p!.pt.jointCount ?? 0;
                                var target = pdt.hit! + p.pt.joint!;
                                if (target > jc || jc == 0) {
                                  tip.TextAlertDesc(context, "太大了!");
                                  return;
                                }

                                p.pt.joint = target;
                                if (target == jc) {
                                  p.pt.finishAt = DateTime.now();
                                }
                                await p.pt.save();
                                await appDB.PlanDetail()
                                    .newType()
                                    .fillByType(pdt)
                                    .setPlan(p.pt.id!)
                                    .save();
                                fetch();
                              },
                              icon: const Icon(Icons.plus_one)),
                          ItemAction<PlanInfo>(
                              cb: (PlanInfo? p, Function() refresh) {
                                Navigator.pushNamed(
                                        context, "/plan/${p!.pt.id}/detail")
                                    .then((value) => fetch());
                              },
                              icon: const Icon(Icons.info))
                        ],
                      ))
                  .toList()),
        ),
      ),
    );
  }
}
