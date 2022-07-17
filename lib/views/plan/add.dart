import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focus/pkg/component/form.dart';
import 'package:focus/pkg/db_types/ngrok.dart';
import 'package:focus/pkg/db_types/plan.dart';
import 'package:focus/pkg/provider/db.dart';
import 'package:focus/pkg/util/tip.dart';
import 'package:focus/pkg/util/transform.dart';
import 'package:maxilozoz_box/application.dart';

class Add extends StatefulWidget {
  int identity = 0;
  Add(this.identity);

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  FormUtil? fu;

  @override
  initState() {
    super.initState();
    fu = FormUtil(
      title: "Plan",
      fis: [
        FormItem(field: PlanClient.nameField, title: "名称"),
        FormItem(field: PlanClient.descField, title: "描述"),
        FormItem(field: PlanClient.deadLineField, title: "结束日期", type: FormItemType.datetimeType),
        FormItem(field: PlanClient.jointCountField, title: "阶段总计", help: "大于0哦", type: FormItemType.intType, validate: (value) => value as int > 0)
      ],
      change: () {
        setState(() {
          
        });
      },
      save: (FormData data) async {
        if(!data.valid) {
          tip.TextAlertDesc(context, "请检查!");
          return;
        }

        AppDB appDB = await Application.instance!.make("app_db");

        map2DB(data.data);
        if(widget.identity == 0) {
          await appDB.planClient.insert(PlanJSONHelp.fromJson(data.data));
        }else {
          await appDB.planClient.update(widget.identity, PlanJSONHelp.fromJson(data.data));
        }

        tip.TextAlertDescWithCB(context, "一切都好", () => Navigator.pop(context));
      }
    );

    if(widget.identity != 0) {
      try {
        fetch();
      }catch(e) {
        tip.TextAlertDescWithCB(context, e.toString(), () => Navigator.pop(context));
      }
    }
  }

  void fetch() {
    _fetch = () async {
      AppDB appDB = await Application.instance!.make("app_db");
      var p = await appDB.planClient.first(widget.identity);
      fu!.setValue({
        PlanClient.nameField: p!.name,
        PlanClient.descField: p.desc,
        PlanClient.deadLineField: p.deadLine,
        PlanClient.jointCountField: p.jointCount,
      });
      return p;
    }();
  }

  Future<Plan?>? _fetch;


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Plan?>(
      future: _fetch,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done || snapshot.connectionState == ConnectionState.none) {
          return fu!.view(context);
        }else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
