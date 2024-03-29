import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:focus/pkg/component/form.dart';
import 'package:focus/pkg/db_types/db.dart';
import 'package:focus/pkg/provider/habitMgr.dart';
import 'package:focus/pkg/provider/notify.dart';
import 'package:focus/pkg/util/date.dart';
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
        title: "Habit",
        fis: [
          FormItem(field: HabitClient.nameField, title: "名称"),
          FormItem(
              field: HabitClient.descField,
              title: "描述",
              option: {"maxLine": 5}),
          FormItem(
              field: HabitClient.notBeforeField,
              title: "不早于",
              type: FormItemType.timepickType,
              defaultValue: DateTime.parse("2011-01-01 09:00:00")),
          FormItem(
              field: HabitClient.notAfterField,
              title: "不晚于",
              type: FormItemType.timepickType,
              defaultValue: DateTime.parse("2011-01-01 18:00:00")),
          FormItem(
              field: HabitClient.countField,
              title: "共计",
              type: FormItemType.intType,
              help: "大于0",
              defaultValue: "1",
              validate: (val) => (val as int) > 0),
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

          HabitType ht = appDB.Habit().newType();
          habitMgr flp = await Application.instance!.make("appHabit");
          if (widget.identity != 0) {
            ht = (await appDB.Habit().first(widget.identity))!;
            flp.cancleHabit(ht);
          }

          ht = ht.fill(data.data);
          if (ht.timeRange.stepMinutes <= 5) {
            tip.TextAlertDesc(context,
                "提醒间隔(${ht.timeRange.stepMinutes}分钟)小于等于5分钟 请确认次数及开始截止日期");
            return;
          }

          await ht.save();

          tip.TextAlertDescWithCB(context, "一切都好", () {
            flp.updateHabit();
            Navigator.pop(context);
          });
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
      var p = (await appDB.Habit().first(widget.identity))!;
      fu!.setValue({
        HabitClient.nameField: p.name,
        HabitClient.descField: p.desc,
        HabitClient.notBeforeField: p.notBefore,
        HabitClient.notAfterField: p.notAfter,
        HabitClient.countField: p.count,
      });
      return p;
    }();
  }

  Future<HabitType?>? _fetch;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<HabitType?>(
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
