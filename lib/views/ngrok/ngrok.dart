import 'package:flutter/material.dart';
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
  List<ItemFetch> ifs = [];

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
          return ngroks.map((e) => NgrokFetch(
            e.identity ?? "", e.apiKey ?? "",
            removeHandle: (identity) async {
               try {
                  if((await appDB.ngrokClient.delete(identity)) == 1) {
                    tip.TextAlertDescWithCB(context, "成功", () => fetch());
                    return;
                  }
                  throw "失败";
                }catch(e) {
                  tip.TextAlertDesc(context, sprintf("[%s] %s", [identity, e.toString()]));
                }
            },
          )).toList();
        }catch(e) {
          return null;
        }
      }();
    });
  }

  Future<List<ItemFetch>?>? _fetch;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ItemFetch>?>(
      future: _fetch,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          return view(context, snapshot.data);
        }else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  
  
  Widget view(BuildContext context, List<ItemFetch>? ifs) {
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
        child: ListView(shrinkWrap: true, children: ifs!.map((e) => Item(e)).toList()),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.amber[800],
        onTap: (int index) => {},
      ),
    );
  }
}

class NgrokFetch extends ItemFetch {
  String ak = "";
  String title = "";
  Future<void> Function(String identity)? removeHandle;
  NgrokFetch(this.title, this.ak, {this.removeHandle});

  @override
  String identity() {
    return title;
  }

  @override
  Future<ItemInfo> fetch() async {
    bool error = false;
    List<ngrok_sdk.NgrokAgent> nas = [];
    try {
      nas = await ngrok_sdk.Ngrok(ak).agent();
    }catch(e) {
      error = true;
    }
    return NgrokInfo(nas, error);
  }

  @override
  String type() {
    return "Ngrok";
  }

  @override
  Future remove(BuildContext context) async {
    return await removeHandle!(identity());
  }

  @override
  Future update(BuildContext context) async {
    await Navigator.pushNamed(context, sprintf("/ngrok/update/%s", [identity()]));
  }
}

class NgrokInfo extends ItemInfo {
  List<ngrok_sdk.NgrokAgent> agents;
  bool error;
  NgrokInfo(this.agents, this.error);

  @override
  Widget child(BuildContext context) {
    return Row(
      children: [
        Column(
          children: error ? [
            const Text("错误了")
          ] : agents.map((e) => Container(
              child: Row(
                children: [
                  Column(
                    children: [
                      Container(height: 1, color: Colors.grey.shade100,),
                      Text(sprintf("Addr: %s", [e.publicUrl])),
                      Text(sprintf("Local: %s", [e.forwardsTo]))
                    ],
                  )
                ],
              ),
            )).toList(),
        )
      ],
    );
  }
}
