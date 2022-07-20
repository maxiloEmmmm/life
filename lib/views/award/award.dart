import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focus/pkg/db_types/award.dart';
import 'package:focus/pkg/db_types/plan.dart';
import 'package:focus/pkg/db_types/thing.dart';
import 'package:focus/pkg/provider/db.dart';
import 'package:maxilozoz_box/application.dart';
import 'package:focus/pkg/component/item.dart';

class AwardView extends StatefulWidget {
  const AwardView({Key? key}) : super(key: key);

  @override
  State<AwardView> createState() => _AwardViewState();
}

class AwardViewItem {
  Award award;
  List<Plan> plans;
  Thing thing;
  AwardViewItem({
    required this.award,
    required this.plans,
    required this.thing
  });
}

class _AwardViewState extends State<AwardView> {
  List<Award> ifs = [];

  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future<List<Award>?>? fetchFunction() async {
      try {
        AppDB appDB = await Application.instance!.make("app_db");
        return await appDB.awardClient.all();
      }catch(e) {
        return null;
      }
  }

  Future<List<Award>?> fetch() async {
    setState(() {
      _fetch = fetchFunction();
    });
  }

  Future<List<Award>?>? _fetch;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Award>?>(
      future: _fetch,
      builder: (context, snapshot) {
        if(snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
          return view(context, snapshot.data);
        }else {
          return const CupertinoActivityIndicator();
        }
      },
    );
  }

  Widget view(BuildContext context, List<Award>? ifs) {
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
          child: ListView(shrinkWrap: true, children: ifs!.map((e) => Item<AwardViewItem>(
            type: "Award",
            title: (AwardViewItem p) {
              return p.award.name!;
            }, 
            onRemove: (AwardViewItem p) async {
              AppDB appDB = await Application.instance!.make("app_db");
              await appDB.awardClient.delete(p.award.id);
              fetch();
            },
            onUpdate: (AwardViewItem p, Function() refresh) async {
              Navigator.pushNamed(context, "/award/update/${p.award.id}")
                .then((value) => refresh());
            },
            fetch: () async {
              AppDB appDB = await Application.instance!.make("app_db");
              return AwardViewItem(
                award: (await appDB.awardClient.first(e.id))!,
                plans: await appDB.awardClient.getPlans(e.id!),
                thing: (await appDB.awardClient.getThing(e.id!))!,
              );
            },
            content: (BuildContext context, AwardViewItem? p) {
              return Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: p == null ? [
                      const Text("错误了")
                    ] : [
                      Text(p.award.desc!),
                      Text("plans: ${p.plans.map((e) => e.name).toList().join(",")}"),
                      Text("award: ${p.thing.name}"),
                    ],
                  )
                ],
              );
            })).toList()),
        ),
      ),
    );
  }
}