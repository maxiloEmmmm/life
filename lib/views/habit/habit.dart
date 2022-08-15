import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focus/pkg/component/assert.dart';
import 'package:focus/pkg/component/form.dart';
import 'package:focus/pkg/component/process.dart';
import 'package:focus/pkg/db_types/db.dart';
import 'package:focus/pkg/provider/habit_notify.dart';
import 'package:focus/pkg/util/date.dart';
import 'package:focus/pkg/util/tip.dart';
import 'package:maxilozoz_box/application.dart';
import 'package:focus/pkg/component/item.dart';

class Habit extends StatefulWidget {
  const Habit({Key? key}) : super(key: key);

  @override
  State<Habit> createState() => _HabitState();
}

class HabitInfo {
  late HabitType typ;
  late bool todayOk;
  late int count;
}

class _HabitState extends State<Habit> {
  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future<List<HabitType>?>? fetchFunction() async {
    DBClientSet appDb = await Application.instance!.make("app_db");
    return await appDb.Habit().all();
  }

  Future<void> fetch() async {
    setState(() {
      _fetch = fetchFunction();
    });
  }

  Future<List<HabitType>?>? _fetch;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<HabitType>?>(
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

  Widget view(BuildContext context, List<HabitType>? ifs) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box),
            onPressed: () {
              Navigator.pushNamed(context, "/habit/add")
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
                  .map((e) => Item<HabitInfo>(
                        type: "Habit",
                        title: (HabitInfo p) {
                          return "${p.typ.name!}${p.todayOk ? " 已完成!" : ""}";
                        },
                        onRemove: (HabitInfo p) async {
                          DBClientSet appDB =
                              await Application.instance!.make("app_db");
                          await appDB.Habit().delete(p.typ.id!);
                          (await p.typ.queryHabitRecords()).forEach((element) {
                            appDB.HabitRecord().delete(element.id!);
                          });
                          fetch();
                        },
                        onUpdate: (HabitInfo p, Function() refresh) async {
                          Navigator.pushNamed(
                                  context, "/habit/update/${p.typ.id}")
                              .then((value) => fetch());
                        },
                        fetch: () async {
                          DBClientSet appDb =
                              await Application.instance!.make("app_db");
                          var h = (await appDb.Habit().first(e.id!))!;
                          // todo 加个主动通知刷新页面
                          var hr = Application.instance!.make("habitNotifyRecord");
                          var hi = HabitInfo();
                          if(hr != null) {
                            hi.count = (hr as Map<int, habitNotifyRecord>)[e.id!]?.count ?? 0;
                          }
                          hi.typ = h;
                          hi.todayOk = (await h.dayHad()) == 1;
                          return hi;
                        },
                        content: (BuildContext context, HabitInfo? p) {
                          return Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: p == null
                                      ? [const Text("错误了")]
                                      : [
                                          IfTrue(p.typ.desc != "",
                                              Text(p.typ.desc!)),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  "始于${p.typ.createdAt!.year}.${p.typ.createdAt!.month}.${p.typ.createdAt!.day}"),
                                              IfTrue(true, Text("还剩${p.count}/${p.typ.count!}次"))
                                            ],
                                          ),
                                        ],
                                ),
                              )
                            ],
                          );
                        },
                        actions: [
                          ItemAction<HabitInfo>(
                              filter: (HabitInfo? p) {
                                return p != null && !p.todayOk;
                              },
                              cb: (HabitInfo? p, Function() refresh) async {
                                DBClientSet appDB =
                                    await Application.instance!.make("app_db");

                                await appDB.HabitRecord()
                                    .newType()
                                    .setHabit(p!.typ.id!)
                                    .save();

                                tip.TextAlertDescWithCB(context, "ok", fetch);
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
