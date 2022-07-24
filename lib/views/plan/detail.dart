import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focus/pkg/db_types/db.dart';
import 'package:maxilozoz_box/application.dart';

class Detail extends StatefulWidget {
  int id;
  Detail(this.id);

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PlanDetailType>>(
      future: () async {
        DBClientSet appDB = await Application.instance!.make("app_db");
        return await (await appDB.Plan().first(widget.id))!.queryPlanDetails();
      }(),
      builder:
          (BuildContext context, AsyncSnapshot<List<PlanDetailType>> snapshot) {
        if (snapshot.hasData) {
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
              .map((e) => Container(
                  height: 60,
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Text(
                              "${e.createdAt!.year}.${e.createdAt!.month}.${e.createdAt!.day}/${e.hit}"),
                          Text(e.desc ?? "")
                        ],
                      )
                    ],
                  )))
              .toList(),
        ),
      ),
    );
  }
}
