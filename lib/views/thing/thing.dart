import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focus/pkg/db_types/db.dart';
import 'package:focus/pkg/util/tip.dart';
import 'package:maxilozoz_box/application.dart';
import 'package:focus/pkg/component/item.dart';

class ThingView extends StatefulWidget {
  const ThingView({Key? key}) : super(key: key);

  @override
  State<ThingView> createState() => _ThingViewState();
}

class _ThingViewState extends State<ThingView> {
  List<ThingType> ifs = [];

  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future<List<ThingType>?>? fetchFunction() async {
    try {
      DBClientSet appDB = await Application.instance!.make("app_db");
      return await appDB.Thing().all();
    } catch (e) {
      return null;
    }
  }

  Future<void> fetch() async {
    setState(() {
      _fetch = fetchFunction();
    });
  }

  Future<List<ThingType>?>? _fetch;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ThingType>?>(
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

  Widget view(BuildContext context, List<ThingType>? ifs) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thing'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box),
            onPressed: () {
              Navigator.pushNamed(context, "/thing/add")
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
                  .map((e) => Item<ThingType>( type: "Plan",
                      title: (ThingType p) {
                        return p.name!;
                      },
                      onRemove: (ThingType p) async {
                        DBClientSet appDB =
                            await Application.instance!.make("app_db");
                        if ((await p.queryAward()).isNotEmpty) {
                          tip.TextAlertDesc(context, "存在奖励记录");
                          return;
                        }
                        await p.destory();
                        fetch();
                      },
                      onUpdate: (ThingType p, Function() refresh) async {
                        Navigator.pushNamed(context, "/thing/update/${p.id}")
                            .then((value) => refresh());
                      },
                      fetch: () async {
                        DBClientSet appDB =
                            await Application.instance!.make("app_db");
                        return (await appDB.Thing().first(e.id!))!;
                      },
                      content: (BuildContext context, ThingType? p) {
                        return Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: p == null
                                  ? [const Text("错误了")]
                                  : [
                                      Text(p.desc!),
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
