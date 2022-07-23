import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focus/pkg/db_types/ngrok.dart' as ngrok_db;
import 'package:focus/pkg/fetch/ngrok.dart' as ngrok_sdk;
import 'package:focus/pkg/provider/db.dart';
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
  List<ngrok_db.Ngrok> ns = [];

  //2Bk4TjVjGYgW443S5vCbcdGlrWN_5dqQ3WV4GF6wkkBuaXM9y
  //2BneJIDZFnV6PaUxTvmgZfxjlL6_2ku2y3yn41wdZzJTVc8vG

  @override
  void initState() {
    super.initState();
    fetch();
  }

  void fetch() {
    setState(() {
      _fetch = () async {
        try {
          AppDB appDB = await Application.instance!.make("app_db");
          var ngroks = await appDB.ngrokClient.all();
          return ngroks;
          // return ngroks.map((e) => NgrokFetch(
          //   e.identity ?? "", e.apiKey ?? "",
          //   removeHandle: (identity) async {
          //      try {
          //         if((await appDB.ngrokClient.delete(identity)) == 1) {
          //           tip.TextAlertDescWithCB(context, "成功", () => fetch());
          //           return;
          //         }
          //         throw "失败";
          //       }catch(e) {
          //         tip.TextAlertDesc(context, sprintf("[%s] %s", [identity, e.toString()]));
          //       }
          //   },
          //)).toList();
        } catch (e) {
          return null;
        }
      }();
    });
  }

  Future<List<ngrok_db.Ngrok>?>? _fetch;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ngrok_db.Ngrok>?>(
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

  Widget view(BuildContext context, List<ngrok_db.Ngrok>? ifs) {
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
                        AppDB appDB =
                            await Application.instance!.make("app_db");
                        if ((await appDB.ngrokClient
                                .delete(item.ng.identity)) ==
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
                              context, "/ngrok/update/${item.ng.identity}")
                          .then((value) => refresh());
                    },
                    title: (NgrokItem item) {
                      return item.ng.identity!;
                    },
                    fetch: () async {
                      List<ngrok_sdk.NgrokAgent> nas = [];
                      try {
                        nas = await ngrok_sdk.Ngrok(e.apiKey!).agent();
                      } catch (e) {
                        return null;
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
  ngrok_db.Ngrok ng;
  List<ngrok_sdk.NgrokAgent> ag = [];
  NgrokItem({
    required this.ng,
    required this.ag,
  });
}
