import 'package:flutter/material.dart';
import 'package:focus/pkg/db_types/ngrok.dart' as ngrok_db;
import 'package:focus/pkg/fetch/ngrok.dart' as ngrok_sdk;
import 'package:focus/pkg/util/tip.dart';
import 'package:maxilozoz_box/application.dart';
import 'package:maxilozoz_box/modules/storage/sqlite/sqlite.dart';
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
          var db = await (await Application.instance!.make("sqlite") as sqlite).DB();
          var ngroks = await db!.rawQuery("select * from ${ngrok_db.NgrokDBMetadata.dbTable}");
          return ngroks.map((e) => ngrok_db.Ngrok.fromJson(e)).map((e) => NgrokFetch(
            e.identity ?? "", e.apiKey ?? "",
            removeHandle: (identity) async {
              var res = await db.rawDelete("delete from ${ngrok_db.NgrokDBMetadata.dbTable} where ${ngrok_db.NgrokDBMetadata.identityField} = ?", [identity]) == 1;
              fetch();
              return res;
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
            icon: Icon(Icons.add_box),
            onPressed: () {
              Navigator.pushNamed(context, "/ngrok/add")
                .then((value) => fetch());
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(8, 4, 8, 8),
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
  Future<bool?> Function(String identity)? removeHandle;
  NgrokFetch(this.title, this.ak, {this.removeHandle});

  @override
  Future<ItemInfo> fetch() async {
    bool error = false;
    List<ngrok_sdk.NgrokAgent> nas = [];
    try {
      nas = await ngrok_sdk.Ngrok(ak).agent();
    }catch(e) {
      error = true;
    }
    return NgrokInfo(title, nas, error);
  }

  @override
  String type() {
    return "Ngrok";
  }

  @override
  Future remove(BuildContext context, String identity) async {
    try {
      if((await removeHandle!(identity))!) {
        tip.TextAlertDesc(context, "成功");
        return;
      }
      throw "失败";
    }catch(e) {
      tip.TextAlertDesc(context, sprintf("[%s] %s", [identity, e.toString()]));
    }
  }

  @override
  Future update(BuildContext context, String identity) async {
    await Navigator.pushNamed(context, sprintf("/ngrok/update/%s", [identity]));
  }
}

class NgrokInfo extends ItemInfo {
  List<ngrok_sdk.NgrokAgent> agents;
  String title = "";
  bool error;
  NgrokInfo(this.title, this.agents, this.error);

  @override
  String identity() {
    return title;
  }

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
