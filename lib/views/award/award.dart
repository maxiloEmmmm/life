import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focus/pkg/db_types/db.dart';
import 'package:maxilozoz_box/application.dart';
import 'package:focus/pkg/component/item.dart';

class AwardView extends StatefulWidget {
  const AwardView({Key? key}) : super(key: key);

  @override
  State<AwardView> createState() => _AwardViewState();
}

class AwardViewItem {
  AwardType award;
  List<PlanType> plans;
  ThingType thing;
  AwardViewItem(
      {required this.award, required this.plans, required this.thing});
}

class _AwardViewState extends State<AwardView> {
  List<AwardType> ifs = [];

  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future<List<AwardType>?>? fetchFunction() async {
    try {
      DBClientSet appDB = await Application.instance!.make("app_db");
      appDB.db
          .rawQuery("select * from Award_Thing")
          .then((value) => print(value));
      return await appDB.Award().all();
    } catch (e) {
      return null;
    }
  }

  Future<List<AwardType>?> fetch() async {
    setState(() {
      _fetch = fetchFunction();
    });
  }

  Future<List<AwardType>?>? _fetch;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AwardType>?>(
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

  Widget view(BuildContext context, List<AwardType>? ifs) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Award'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box),
            onPressed: () {
              Navigator.pushNamed(context, "/award/add")
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
                  .map((e) => Item<AwardViewItem>(
                      type: "Award",
                      title: (AwardViewItem p) {
                        return p.award.name!;
                      },
                      onRemove: (AwardViewItem p) async {
                        DBClientSet appDB =
                            await Application.instance!.make("app_db");
                        await appDB.Award().delete(p.award.id!);
                        fetch();
                      },
                      onUpdate: (AwardViewItem p, Function() refresh) async {
                        Navigator.pushNamed(
                                context, "/award/update/${p.award.id}")
                            .then((value) => refresh());
                      },
                      fetch: () async {
                        DBClientSet appDB =
                            await Application.instance!.make("app_db");
                        var item = (await appDB.Award().first(e.id!))!;
                        return AwardViewItem(
                          award: item,
                          plans: await item.queryPlans(),
                          thing: (await item.queryThing())!,
                        );
                      },
                      content: (BuildContext context, AwardViewItem? p) {
                        return Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: p == null
                                  ? [const Text("错误了")]
                                  : [
                                      Text(p.award.desc!),
                                      Text(
                                          "plans: ${p.plans.map((e) => e.name).toList().join(",")}"),
                                      Text("award: ${p.thing.name}"),
                                    ],
                            )
                          ],
                        );
                      }))
                  .toList()),
        ),
      ),
    );
  }
}
