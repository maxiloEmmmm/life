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
          FormItem(field: PlanClient.descField, title: "描述"),
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
        save: (FormData data) async {
          if (!data.valid) {
            tip.TextAlertDesc(context, "请检查!");
            return;
          }

          DBClientSet appDB = await Application.instance!.make("app_db");

          if (widget.identity == 0) {
            data.data[PlanClient.createdAtField] = DateTime.now();
          }

          await (await appDB.Plan().firstOrNew(widget.identity))
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
