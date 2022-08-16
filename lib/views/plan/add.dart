import 'package:flutter/material.dart';
import 'package:focus/pkg/component/form.dart';
import 'package:focus/pkg/db_types/db.dart';
import 'package:focus/pkg/util/tip.dart';
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
          FormItem(
              field: PlanClient.descField, title: "描述", option: {"maxLine": 5}),
          FormItem(
              field: PlanClient.createdAtField,
              title: "开始日期",
              type: FormItemType.datetimeType, defaultValue: DateTime.now()),
          FormItem(
              field: PlanClient.deadLineField,
              title: "结束日期",
              type: FormItemType.datetimeType),
          FormItem(
              field: PlanClient.jointCountField,
              title: "阶段总计",
              help: "大于0哦",
              type: FormItemType.intType,
              validate: (value) => value as int > 0)
        ],
        change: () {
          setState(() {});
        },
        save: (BuildContext context, FormData data) async {
          if (!data.valid) {
            tip.TextAlertDesc(context, "请检查!");
            return;
          }

          DBClientSet appDB = await Application.instance!.make("app_db");

          PlanType p;
          if (widget.identity == 0) {
            p = appDB.Plan().newType();
            data.data[PlanClient.createdAtField] = DateTime.now();
          }else {
            p = (await appDB.Plan().first(widget.identity))!;
            var modd = (data.data[PlanClient.createdAtField] as DateTime);
            if((await p.queryPlanDetails()).where((element) => element.createdAt!.compareTo(modd) < 0).isNotEmpty) {
              tip.TextAlertDesc(context, "存在超前的计划日志，创建日期拒绝修改!");
              return;
            }
          }

          if((data.data[PlanClient.createdAtField] as DateTime).compareTo((data.data[PlanClient.deadLineField] as DateTime)) >= 0) {
            tip.TextAlertDesc(context, "开始日期晚于结束日期!");
            return;
          }

          await p
              .fill(data.data)
              .save();

          tip.TextAlertDescWithCB(
              context, "一切都好", () => Navigator.pop(context));
        });

    if (widget.identity != 0) {
      try {
        fetch();
      } catch (e) {
        tip.TextAlertDescWithCB(
            context, e.toString(), () => Navigator.pop(context));
      }
    }
  }

  void fetch() {
    _fetch = () async {
      DBClientSet appDB = await Application.instance!.make("app_db");
      var p = (await appDB.Plan().first(widget.identity))!;
      fu!.setValue({
        PlanClient.nameField: p.name,
        PlanClient.descField: p.desc,
        PlanClient.deadLineField: p.deadLine,
        PlanClient.jointCountField: p.jointCount,
      });
      return p;
    }();
  }

  Future<PlanType?>? _fetch;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PlanType?>(
      future: _fetch,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done ||
            snapshot.connectionState == ConnectionState.none) {
          return fu!.view(context);
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
