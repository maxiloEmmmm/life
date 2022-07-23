import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focus/pkg/db_types/thing.dart';
import 'package:focus/pkg/provider/db.dart';
import 'package:focus/pkg/util/tip.dart';
import 'package:maxilozoz_box/application.dart';
import 'package:focus/pkg/component/item.dart';

class ThingView extends StatefulWidget {
  const ThingView({Key? key}) : super(key: key);

  @override
  State<ThingView> createState() => _ThingViewState();
}

class _ThingViewState extends State<ThingView> {
  List<Thing> ifs = [];

  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future<List<Thing>?>? fetchFunction() async {
    try {
      AppDB appDB = await Application.instance!.make("app_db");
      return await appDB.thingClient.all();
    } catch (e) {
      return null;
    }
  }

  Future<void> fetch() async {
    setState(() {
      _fetch = fetchFunction();
    });
  }

  Future<List<Thing>?>? _fetch;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Thing>?>(
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

  Widget view(BuildContext context, List<Thing>? ifs) {
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
                  .map((e) => Item<Thing>( type: "Plan",
                      title: (Thing p) {
                        return p.name!;
                      },
                      onRemove: (Thing p) async {
                        AppDB appDB =
                            await Application.instance!.make("app_db");
                        if (await appDB.thingClient.existAward(p.id!)) {
                          tip.TextAlertDesc(context, "存在奖励记录");
                          return;
                        }
                        await appDB.thingClient.delete(p.id);
                        fetch();
                      },
                      onUpdate: (Thing p, Function() refresh) async {
                        Navigator.pushNamed(context, "/thing/update/${p.id}")
                            .then((value) => refresh());
                      },
                      fetch: () async {
                        AppDB appDB =
                            await Application.instance!.make("app_db");
                        return (await appDB.thingClient.first(e.id))!;
                      },
                      content: (BuildContext context, Thing? p) {
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
