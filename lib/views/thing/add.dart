import 'package:flutter/material.dart';
import 'package:focus/pkg/component/form.dart';
import 'package:focus/pkg/db_types/db.dart';
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
        title: "Thing",
        fis: [
          FormItem(
              field: ThingClient.nameField,
              title: "名称",
              validate: (value) => value as String != ""),
          FormItem(field: ThingClient.descField, title: "描述"),
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

          await (await appDB.Thing().firstOrNew(widget.identity))
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
      var p = await appDB.Thing().first(widget.identity);
      fu!.setValue({
        ThingClient.nameField: p!.name,
        ThingClient.descField: p.desc,
      });
      return p;
    }();
  }

  Future<ThingType?>? _fetch;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ThingType?>(
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
