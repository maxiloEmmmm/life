import 'package:flutter/material.dart';
import 'package:focus/pkg/fetch/ngrok.dart';
import 'package:maxilozoz_box/application.dart';
import 'package:maxilozoz_box/modules/storage/sqlite/sqlite.dart';
import 'package:sprintf/sprintf.dart';
import './item.dart';

class Demo extends StatefulWidget {
  const Demo({Key? key}) : super(key: key);

  @override
  State<Demo> createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  List<ItemFetch> ifs = [];

  //2Bk4TjVjGYgW443S5vCbcdGlrWN_5dqQ3WV4GF6wkkBuaXM9y
  //2BneJIDZFnV6PaUxTvmgZfxjlL6_2ku2y3yn41wdZzJTVc8vG

  @override
  void initState() {
    super.initState();
    _fetch = fetch();
  }

  Future<List<ItemFetch>?> fetch() async {
    try {
      var db = await (await Application.instance!.make("sqlite") as sqlite).DB();
      var ngroks = await db!.rawQuery("select * from ngrok");
      return ngroks.map((e) => NgrokFetch(e["identity"] as String, e["api_key"] as String)).toList();
    }catch(e) {
      return null;
    }
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
              Navigator.pushNamed(context, "/ngrok/add");
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(8, 4, 8, 8),
        color: Colors.grey[150],
        child: ListView(children: ifs!.map((e) => Item(e)).toList()),
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
  NgrokFetch(this.title, this.ak);

  @override
  Future<ItemInfo> fetch() async {
    return NgrokInfo(this.title, await Ngrok(ak).agent());
  }

  @override
  String type() {
    return "Ngrok";
  }
}

class NgrokInfo extends ItemInfo {
  List<NgrokAgent> agents;
  String title = "";
  NgrokInfo(this.title, this.agents);

  @override
  String identity() {
    return title;
  }

  @override
  Widget child(BuildContext context) {
    return Row(
      children: [
        Column(
          children: agents.map((e) => Container(
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
