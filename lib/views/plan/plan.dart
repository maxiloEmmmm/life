import 'package:flutter/material.dart';
import 'package:focus/pkg/db_types/plan.dart' as db_plan;
import 'package:focus/pkg/provider/db.dart';
import 'package:maxilozoz_box/application.dart';
import 'package:sprintf/sprintf.dart';
import 'package:focus/pkg/component/item.dart';

class Plan extends StatefulWidget {
  const Plan({Key? key}) : super(key: key);

  @override
  State<Plan> createState() => _PlanState();
}

class _PlanState extends State<Plan> {
  List<ItemFetch> ifs = [];

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
          var ps = await appDB.planClient.all();
          return ps.map((e) => PlanFetch(e)).toList();
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
        title: const Text('Plan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box),
            onPressed: () {
              Navigator.pushNamed(context, "/plan/add")
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

class PlanFetch extends ItemFetch {
  db_plan.Plan plan;
  String title = "";
  PlanFetch(this.plan);

  @override
  String identity() {
    return plan.name ?? "";
  }

  @override
  Future<ItemInfo> fetch() async {
    db_plan.Plan? p;
    bool error = false;
    try {
      AppDB appDB = await Application.instance!.make("app_db");
      var p = await appDB.planClient.first(plan.id);
    }catch(e) {
      error = true;
    }
    return PlanInfo(p, error);
  }

  @override
  String type() {
    return "Plan";
  }

  @override
  Future remove(BuildContext context) async {
    AppDB appDB = await Application.instance!.make("app_db");
    return await appDB.planClient.delete(plan.id);
  }

  @override
  Future update(BuildContext context) async {
    await Navigator.pushNamed(context, sprintf("/plan/update/%s", [identity()]));
  }
}

class PlanInfo extends ItemInfo {
  db_plan.Plan? p;
  bool error;
  PlanInfo(this.p, this.error);

  @override
  Widget child(BuildContext context) {
    return Row(
      children: [
        Column(
          children: error ? [
            const Text("错误了")
          ] : [
            Row(children: [Text(p!.desc!)],)
          ],
        )
      ],
    );
  }
}
