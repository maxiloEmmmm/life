import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focus/pkg/db_types/db.dart';
import 'package:focus/pkg/fetch/ngrok.dart' as ngrok_sdk;
import 'package:focus/pkg/util/tip.dart';
import 'package:maxilozoz_box/application.dart';
import 'package:sprintf/sprintf.dart';
import 'package:focus/pkg/component/item.dart';

class Ngrok extends StatefulWidget {
  const Ngrok({Key? key}) : super(key: key);

  @override
  State<Ngrok> createState() => _NgrokState();
}

class _NgrokState extends State<Ngrok> {
  @override
  void initState() {
    super.initState();
    fetch();
  }

  void fetch() {
    setState(() {
      _fetch = () async {
        try {
          DBClientSet appDB = await Application.instance!.make("app_db");
          var ngroks = await appDB.Ngrok().all();
          return ngroks;
        } catch (e) {
          return null;
        }
      }();
    });
  }

  Future<List<NgrokType>?>? _fetch;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<NgrokType>?>(
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

  Widget view(BuildContext context, List<NgrokType>? ifs) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ngrok'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box),
            onPressed: () {
              Navigator.pushNamed(context, "/ngrok/add")
                  .then((value) => fetch());
            },
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
        color: Colors.grey[150],
        child: ListView(
            shrinkWrap: true,
            children: ifs!
                .map((e) => Item<NgrokItem>(
                    type: "Ngrok",
                    onRemove: (NgrokItem item) async {
                      try {
                        DBClientSet appDB =
                            await Application.instance!.make("app_db");
                        if ((await appDB.Ngrok().delete(item.ng.id!)) ==
                            1) {
                          tip.TextAlertDescWithCB(context, "成功", () => fetch());
                          return;
                        }
                        throw "失败";
                      } catch (e) {
                        tip.TextAlertDesc(
                            context,
                            sprintf(
                                "[%s] %s", [item.ng.identity, e.toString()]));
                      }
                    },
                    onUpdate: (NgrokItem item, Function() refresh) async {
                      Navigator.pushNamed(
                              context, "/ngrok/update/${item.ng.id}")
                          .then((value) => refresh());
                    },
                    title: (NgrokItem? item) {
                      return item?.ng.identity ?? "";
                    },
                    fetch: () async {
                      List<ngrok_sdk.NgrokAgent> nas = [];
                      try {
                        nas = await ngrok_sdk.Ngrok(e.apiKey!).agent();
                      } catch (ex) {
                        //todo 错误如何显示
                      }
                      return NgrokItem(ng: e, ag: nas);
                    },
                    content: (BuildContext context, NgrokItem? item) {
                      return Row(
                        children: [
                          Column(
                            children: item == null
                                ? [const Text("错误了")]
                                : item.ag
                                    .map((e) => Container(
                                          child: Row(
                                            children: [
                                              Column(
                                                children: [
                                                  Container(
                                                    height: 1,
                                                    color: Colors.grey.shade100,
                                                  ),
                                                  Text(sprintf("Addr: %s",
                                                      [e.publicUrl])),
                                                  Text(sprintf("Local: %s",
                                                      [e.forwardsTo]))
                                                ],
                                              )
                                            ],
                                          ),
                                        ))
                                    .toList(),
                          )
                        ],
                      );
                    }))
                .toList()),
      ),
    );
  }
}

class NgrokItem {
  NgrokType ng;
  List<ngrok_sdk.NgrokAgent> ag = [];
  NgrokItem({
    required this.ng,
    required this.ag,
  });
}
