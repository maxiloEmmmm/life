import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focus/pkg/component/item.dart';
import 'package:focus/pkg/db_types/db.dart';
import 'package:focus/pkg/util/tip.dart';
import 'package:maxilozoz_box/application.dart';

class Detail extends StatefulWidget {
  int id;
  Detail(this.id);

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  Future<List<PlanDetailType>>? _fetch;

  @override
  void initState() {
    super.initState();
    fetch();
  }

  void fetch() {
    setState(() {
      _fetch = () async {
        DBClientSet appDB = await Application.instance!.make("app_db");
        return await (await appDB.Plan().first(widget.id))!.queryPlanDetails();
      }();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PlanDetailType>>(
      future: _fetch,
      builder:
          (BuildContext context, AsyncSnapshot<List<PlanDetailType>> snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          return view(context, snapshot.data!);
        } else {
          return const CupertinoActivityIndicator();
        }
      },
    );
  }

  Widget view(BuildContext context, List<PlanDetailType> pds) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plan Detail'),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Column(
            children: pds
                .map((e) => Item<PlanDetailType>(
                      type: "Detail",
                      title: (PlanDetailType pdt) {
                        return "${e.hit}";
                      },
                      fetch: () async {
                        return e;
                      },
                      onRemove: (PlanDetailType pdt) async {
                        var p = await pdt.queryPlan();
                        await pdt.destory();
                        p!.joint = p.joint! - pdt.hit!;
                        await p.save();
                        tip.TextAlertDescWithCB(context, "ok", () => fetch());
                      },
                      content: (BuildContext context, PlanDetailType? pdt) {
                        return Row(
                          children: [
                            Text(
                                "${e.createdAt!.year}.${e.createdAt!.month}.${e.createdAt!.day}/${e.hit}"),
                            Text(e.desc ?? "", softWrap: true)
                          ],
                        );
                      },
                    ))
                .toList()),
      ),
    );
  }
}
